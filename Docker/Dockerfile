FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

ARG CONTAINER_ROS_DOMAIN_ID
ARG CONTAINER_BRIDGE_INTERFACE
ARG USERNAME_GITLAB
ARG TOKEN_GITLAB
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq

# Install tools
RUN apt-get install -y -qq --no-install-recommends \
    curl \
    gdb \
    gettext-base \
    git \
    iputils-ping \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
    ros-humble-rmw-cyclonedds-cpp \
    tmux \
    wget

# Install dependencies for IDS peak
RUN apt-get install -y -qq --no-install-recommends \
    udev \
    libatomic1 \
    libqt5core5a \
    libqt5gui5 \
    libqt5multimedia5 \
    libqt5quick5 \
    libqt5widgets5 \
    libusb-1.0-0 \
    qml-module-qtquick2 \
    qml-module-qtquick-window2 \
    qml-module-qtquick-dialogs \
    qml-module-qtquick-controls \
    qml-module-qtquick-layouts \
    qml-module-qt-labs-folderlistmodel \
    qml-module-qt-labs-settings \
    qtbase5-dev \
    qtdeclarative5-dev

# Assume package is in /include
COPY include/ids-peak_*.deb /tmp/
RUN apt-get update -qq
RUN apt-get install -y -qq --no-install-recommends /tmp/ids-peak_*.deb

# Alternative: Install IDS peak and IDS peak genericSDK
# RUN wget \
#     --http-user=$IDS_USERNAME \
#     --http-password=$IDS_PASSWORD \
#     -O- https://repo.ids-imaging.com/ids.pgp |\
#     gpg --dearmor |\
#     tee /usr/local/share/keyrings/ids-archive-keyring.gpg >\
#     /dev/null
# RUN touch /etc/apt/auth.conf.d/ids-peak-repo.conf
# RUN echo "machine repo.ids-imaging.com/ubuntu login $IDS_USERNAME password $IDS_PASSWORD" |\
#     tee /etc/apt/auth.conf.d/ids-peak-repo.conf >\
#     /dev/null
# RUN touch /etc/apt/sources.list.d/ids-peak-repo.list
# RUN echo "deb [signed-by=/usr/local/share/keyrings/ids-archive-keyring.gpg] https://repo.ids-imaging.com/ubuntu jammy main" |\
#     tee /etc/apt/sources.list.d/ids-peak-repo.list >\
#     /dev/null
# RUN apt-get update
# RUN apt-get install ids-peak -y

# Install Python tools
RUN pip install \
    ipykernel

# Install Python dependencies
RUN pip install \
    numpy

# Install Python bindings (assuming Python 3.10)
RUN pip install \
    /usr/local/share/ids/bindings/python/wheel/ids_peak-*-cp37-abi3-linux_*.whl \
    /usr/local/share/ids/bindings/python/wheel/ids_peak_afl-*-cp37-abi3-linux_*.whl \
    /usr/local/share/ids/bindings/python/wheel/ids_peak_ipl-*-cp310-cp310-linux_*.whl

# Add explicit dependencies
RUN git clone "https://$USERNAME_GITLAB:$TOKEN_GITLAB@git.ais.uni-bonn.de/athome/nimbro_utils.git" /colcon_ws/src/nimbro_utils
RUN git clone https://github.com/bertan-karacora/nimbro_camera_ids.git /colcon_ws/src/nimbro_camera_ids

# Build ROS2 workspace
WORKDIR /colcon_ws
RUN source /opt/ros/humble/setup.bash && colcon build --symlink-install
WORKDIR /

# Cleanup
RUN apt-get autoremove -y -qq
RUN rm -rf /tmp/* /var/tmp/* 
RUN apt-get clean -qq
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /repos

ENV ROS_DOMAIN_ID="$CONTAINER_ROS_DOMAIN_ID"
ENV RC_INTERFACE="$CONTAINER_BRIDGE_INTERFACE"
ENV USE_GEMINI_2L="$CONTAINER_USE_GEMINI_2L"

COPY include/entrypoint.sh /entrypoint.sh
COPY include/cyclonedds.xml.template /cyclonedds.xml.template
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

ENV DISPLAY :0
ENV DEBIAN_FRONTEND teletype
