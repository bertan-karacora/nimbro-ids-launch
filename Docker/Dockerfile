FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

ARG IDS_USERNAME
ARG IDS_PASSWORD
ARG MEMORY_USB_BUFFER
ARG CONTAINER_ROS_DOMAIN_ID
ARG CONTAINER_BRIDGE_INTERFACE
ARG DEBIAN_FRONTEND=noninteractive

ENV ROS_DOMAIN_ID="$CONTAINER_ROS_DOMAIN_ID"
ENV RC_INTERFACE="$CONTAINER_BRIDGE_INTERFACE"
ENV USE_GEMINI_2L="$CONTAINER_USE_GEMINI_2L"

RUN apt-get update -qq

# Install tools
RUN apt-get install -y -qq --no-install-recommends \
    curl \
    gdb \
    git \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
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

# Install IDS peak and IDS peak genericSDK
# TODO: Load from sciebo
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

# Alternative: Mount archive or .deb package and install
RUN apt-get update -qq

# TODO: Get wildcard working
# RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends /repos/nimbro-ids-launch/resources/ids-peak_*.deb

# # Install Python dependencies
# RUN pip install \
#     numpy

# # Install Python bindings (assuming Python 3.10)
# RUN pip install \
#     /usr/local/share/ids/bindings/python/wheel/ids_peak-*-cp37-abi3-linux_*.whl \
#     /usr/local/share/ids/bindings/python/wheel/ids_peak_afl-*-cp37-abi3-linux_*.whl \
#     /usr/local/share/ids/bindings/python/wheel/ids_peak_ipl-*-cp310-cp310-linux_*.whl

# The buffer memory's default value of the USB file system is often too low for a multi-camera system/high resolution cameras.
# Increase the memory value to avoid transfer losses.
# To adjust the memory value, you must change the "usbfs_memory_mb" parameter with root privileges.
# RUN echo "$MEMORY_USB_BUFFER" > /sys/module/usbcore/parameters/usbfs_memory_mb

# Cleanup
RUN apt-get autoremove -y -qq
RUN rm -rf /tmp/* /var/tmp/* 
RUN apt-get clean -qq
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /repos

COPY include/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

ENV DEBIAN_FRONTEND teletype
