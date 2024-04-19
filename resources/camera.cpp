#include <cam_input/cameras/cam_ids.hpp>

CameraIDS::CameraIDS() : m_height(0), m_width(0), m_threadRate(1), m_autoGain(false), m_autoWhiteBalance(false), m_autoExposure(false) {
    m_publish = true;
    m_threadRunning = false;
    mp_params = VisionParameters::getInstance();
}

CameraIDS::~CameraIDS() {
    terminate();
}

int CameraIDS::terminate() {
    stopCapturing();
    if (mp_dataStream) {
        mp_dataStream->Flush(peak::core::DataStreamFlushMode::DiscardAll);

        for (const auto &buffer : mp_dataStream->AnnouncedBuffers()) {
            mp_dataStream->RevokeBuffer(buffer);
        }
    }
    mp_camDevice.reset();
    peak::Library::Close();
}

bool CameraIDS::startCapturing() {

    if (m_initialized != true) {
        ROS_ERROR("Camera thread can not be started before initialization!");
        return false;
    }
    if (m_deviceOpen != true) {
        ROS_ERROR("Camera thread can not be started without an open device!");
        return false;
    }
    if (m_capturing == true) {
        ROS_WARN_THROTTLE(1, "Camera is already capturing!");
        return true;
    }
    m_capturing = true;
    try {
        mp_dataStream->StartAcquisition(peak::core::AcquisitionStartMode::Default, PEAK_INFINITE_NUMBER);
        mp_deviceNodeMap->FindNode<peak::core::nodes::IntegerNode>("TLParamsLocked")->SetValue(1);
        mp_deviceNodeMap->FindNode<peak::core::nodes::CommandNode>("AcquisitionStart")->Execute();
    } catch (const peak::core::Exception &e) {
        ROS_ERROR_THROTTLE(1, "Unable to start acquisition: %s", e.what());
        m_capturing = false;
        return false;
    }
    mp_captureThread = std::make_unique<std::thread>(&CameraIDS::captureThreaded, this);
    // usleep(1000);
    m_threadRunning = true;
    return true;
}

bool CameraIDS::stopCapturing() {
    m_capturing = false;
    m_threadRunning = false;
    m_deviceOpen = false;
    usleep(1000);
    mp_captureThread->join();
    mp_deviceNodeMap->FindNode<peak::core::nodes::CommandNode>("AcquisitionStop")->Execute();
    mp_deviceNodeMap->FindNode<peak::core::nodes::IntegerNode>("TLParamsLocked")->SetValue(0);
    mp_dataStream->StopAcquisition(peak::core::AcquisitionStopMode::Default);
    m_deviceOpen = true;
    return true;
}

bool CameraIDS::captureThreaded() {
    /*
        Background thread to continuously read images from the camera.
        The most recent image can then be retrieved when required.
    */

    if (!m_initialized || !m_deviceOpen) {
        ROS_ERROR("Camera thread started without proper initialization!");
        return false;
    }
    while (m_deviceOpen) {
        initialize(false);
        shared_ptr<peak::core::Buffer> buffer;
        if (m_capturing) {
            try {
                buffer = mp_dataStream->WaitForFinishedBuffer(5000);
            } catch (const std::exception &e) {
                ROS_WARN_THROTTLE(1, "Exception while waiting for buffer: %s", e.what());
                continue;
            }
            try {
                if (m_height == 0) {
                    m_height = buffer->Height();
                    m_width = buffer->Width();
                    m_rawImage_internal = cv::Mat(m_height, m_width, CV_8UC3);
                    m_rawImage_internal_ready = cv::Mat(m_height, m_width, CV_8UC3);
                }
                const auto image = BufferTo(buffer);
                mp_imageConverter->Convert(image, peak::ipl::PixelFormatName::BGR8, m_rawImage_internal.data, m_rawImage_internal.total() * m_rawImage_internal.elemSize());
            } catch (const std::exception &e) {
                ROS_ERROR_THROTTLE(1, "Unable to convert buffer: %s", e.what());
                mp_dataStream->QueueBuffer(buffer);
                continue;
            }
            mp_dataStream->QueueBuffer(buffer);

            m_rawImgMutex.lock();
            m_rawImage_internal_ready = m_rawImage_internal.clone();
            if (mp_params->camera->flipHor() && mp_params->camera->flipVer()) {
                flip(m_rawImage_internal_ready, m_rawImage_internal_ready, -1);
            } else if (mp_params->camera->flipHor()) {
                flip(m_rawImage_internal_ready, m_rawImage_internal_ready, 1);
            } else if (mp_params->camera->flipVer()) {
                flip(m_rawImage_internal_ready, m_rawImage_internal_ready, 0);
            }
            m_rawImgMutex.unlock();
        } else {
            ROS_WARN_THROTTLE(2, "Camera thread is running without capturing");
        }
        m_threadRate.sleep();
    }

    return true;
}

bool CameraIDS::initialize(bool firstTime) {
    /*
        Initialize the camera interface.
        If firstTime is true, every required parameters is set within the interface and the VideoCapture object.
        This function is intendended to be called continuously such that the interface is automatically udpated
        on the go if the config parameters change.
    */
    int retryTimeout = 10;
    int counter = 0;
    bool opened = false;
    ros::Duration timeout = ros::Duration(1.0);
    if (firstTime) {
        peak::Library::Initialize();
        auto &deviceManager = peak::DeviceManager::Instance();
        while (!opened) {
            deviceManager.Update();
            auto devices = deviceManager.Devices();
            if (devices.empty()) {
                ROS_WARN_THROTTLE(2, "No camera devices found!");
                timeout.sleep();
                continue;
            }
            shared_ptr<peak::core::Device> device = nullptr;
            ROS_INFO_THROTTLE(1, "Initializing new camera... Found camera devices:");
            for (const auto &descriptor : devices) {
                auto name = descriptor->UserDefinedName();
                ROS_INFO_THROTTLE(1, "Camera: %s", name.c_str());
            }
            try {
                mp_camDevice = devices[0]->OpenDevice(peak::core::DeviceAccessType::Control);
                ROS_INFO_THROTTLE(1, "Camera %s successfully opened", devices[0]->UserDefinedName().c_str());
                opened = true;
            } catch (...) {
                ROS_WARN_THROTTLE(2, "Failed to open camera device");
                timeout.sleep();
            }
            counter++;
            if (counter >= retryTimeout) {
                return false;
            }
        }
        m_deviceOpen = true;
        mp_deviceNodeMap = mp_camDevice->RemoteDevice()->NodeMaps().at(0);
        setSettings();
        bool foundStream = false;
        counter = 0;
        while (!foundStream) {
            auto dataStreams = mp_camDevice->DataStreams();
            if (dataStreams.empty()) {
                ROS_WARN_THROTTLE(2, "No data streams found!");
                counter++;
                if (counter >= retryTimeout) {
                    return false;
                }
                timeout.sleep();
                continue;
            }
            foundStream = true;
        }
        mp_dataStream = mp_camDevice->DataStreams().at(0)->OpenDataStream();
        std::shared_ptr<peak::core::NodeMap> nodemapDataStream = mp_dataStream->NodeMaps().at(0);
        if (mp_dataStream) {
            int64_t payloadSize = mp_deviceNodeMap->FindNode<peak::core::nodes::IntegerNode>("PayloadSize")->Value();

            // Get number of minimum required buffers
            int numBuffersMinRequired = mp_dataStream->NumBuffersAnnouncedMinRequired();

            // Alloc buffers
            for (size_t count = 0; count < numBuffersMinRequired; count++) {
                auto buffer = mp_dataStream->AllocAndAnnounceBuffer(static_cast<size_t>(payloadSize), nullptr);
                mp_dataStream->QueueBuffer(buffer);
            }
        }
        m_initialized = true;
        m_capturing = false;
        mp_imageConverter = std::make_shared<peak::ipl::ImageConverter>();
        mp_imageConverter->SetConversionMode(peak::ipl::ConversionMode::Fast);
    }
    // Load the configuration file and load the camera settings

    if (firstTime || m_fps != mp_params->camera->threadedFps()) {
        if (m_threadRunning == true) {
            m_capturing = false;
            usleep(1000);
        }
        m_fps = mp_params->camera->threadedFps();
        ROS_INFO("Setting the threaded FPS to %i", m_fps);
        m_threadRate = ros::Rate(m_fps);
        if (m_threadRunning == true) {
            m_capturing = true;
        }
    }
    // if(firstTime || m_autoExposure!=mp_params->camera->autoExposure()){
    //     if(m_threadRunning == true){
    //         m_capturing = false;
    //         usleep(1000);
    //     }
    //
    //    m_autoExposure = mp_params->camera->autoExposure();
    //    ROS_INFO("Setting the auto exposure to %i", m_autoExposure);
    //
    //    if (m_threadRunning == true){
    //        m_capturing = true;
    //    }
    //}
    if (firstTime || m_topic != mp_params->rightEyeTopic()) {
        m_topic = mp_params->rightEyeTopic();
        m_publish = false;
        usleep(1000);
        try {
            mp_imagePublisher = std::make_unique<MatPublisher>(m_topic);
            ROS_INFO("Initialized camera publisher for topic %s", m_topic.c_str());
        } catch (exception e) {
            ROS_ERROR("Failed to initialize camera publisher:\n%s", e.what());
            return false;
        }
        m_publish = true;
    }
    m_initialized = true;
    return true;
}

bool CameraIDS::setImageSize(int width, int height) {
    int closestWidth = round(height / m_sizeRatio);
    int closestHeight = round(width / m_sizeRatio);
    if (closestWidth <= width) {
        m_width = closestWidth;
        m_height = height;
    } else {
        m_width = width;
        m_height = closestHeight;
    }
    ROS_INFO_THROTTLE(1, "Image size set to %ix%i (%ix%i)", m_width, m_height, width, height);
    return true;
}

bool CameraIDS::setSettings() {
    if (mp_camDevice == nullptr) {
        ROS_WARN_THROTTLE(2, "Camera device is not initialized!");
        return false;
    }
    auto packagePath = ros::package::getPath("launch");
    // if(rp.find(packageName, packagePath)){
    //     packagePath = packagePath + "/config/vision";
    //     std::string configFile = params->camera->configFileName();
    //     std::string configPath = packagePath + "/vision/" + configFile;
    //     mp_deviceNodeMap->LoadFromFile(configPath);
    //     return true;
    // }
    std::string configFile = mp_params->camera->configFileName();
    std::string configPath = packagePath + "/config/vision/" + configFile;
    mp_deviceNodeMap->LoadFromFile(configPath);
    ROS_INFO("Successfully loaded camera settings from %s", configPath.c_str());
    return true;
}

int CameraIDS::capture(bool send) {
    if (!(send && m_publish)) {
        ROS_WARN_THROTTLE(1, "Publishing is currently disabled!");
        return -1;
    }
    if (m_rawImage_internal.empty()) {
        ROS_WARN_THROTTLE(1, "No image to publish!");
        return -1;
    }
    m_rawImgMutex.lock();
    m_rawImageTime = m_captureTime;
    m_rawImage = m_rawImage_internal_ready.clone();
    m_rawImgMutex.unlock();

    mp_imagePublisher->publish_fast(m_rawImage, MatPublisher::bgr);
    m_lastPublishTime = ros::WallTime::now();
    return 1;
}

bool CameraIDS::isReady() {
    return m_initialized & m_deviceOpen;
}

bool CameraIDS::isCapturing() {
    return m_capturing & m_threadRunning;
}