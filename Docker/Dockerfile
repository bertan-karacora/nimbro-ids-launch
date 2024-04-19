FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

ARG IDS_USERNAME
ARG IDS_PASSWORD
ARG CONTAINER_ROS_DOMAIN_ID
ARG CONTAINER_BRIDGE_INTERFACE
ARG DEBIAN_FRONTEND=noninteractive

ENV ROS_DOMAIN_ID="$CONTAINER_ROS_DOMAIN_ID"
ENV RC_INTERFACE="$CONTAINER_BRIDGE_INTERFACE"
ENV USE_GEMINI_2L="$CONTAINER_USE_GEMINI_2L"

RUN apt-get update

# Install tools
RUN apt-get install -y -qq --no-install-recommends \
    curl \
    gdb \
    git \
    python-is-python3 \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    tmux \
    wget

# Install dependencies for IDS peak
RUN apt-get install -y -qq --no-install-recommends \
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
# RUN wget \
#     --http-user=$IDS_USERNAME \
#     --http-password=$IDS_PASSWORD \
#     -O- https://repo.ids-imaging.com/ids.pgp |\
#     gpg --dearmor |\
#     sudo tee /usr/local/share/keyrings/ids-archive-keyring.gpg >\
#     /dev/null
# RUN sudo touch /etc/apt/auth.conf.d/ids-peak-repo.conf
# RUN echo "machine repo.ids-imaging.com/ubuntu login $IDS_USERNAME password $IDS_PASSWORD" |\
#     sudo tee /etc/apt/auth.conf.d/ids-peak-repo.conf >\
#     /dev/null
# RUN sudo touch /etc/apt/sources.list.d/ids-peak-repo.list
# RUN echo "deb [signed-by=/usr/local/share/keyrings/ids-archive-keyring.gpg] https://repo.ids-imaging.com/ubuntu jammy main" |\
#     sudo tee /etc/apt/sources.list.d/ids-peak-repo.list >\
#     /dev/null

# RUN sudo apt-get update
# RUN sudo apt-get install ids-peak -y

# RUN pip install ids_peak-*-cp37-abi3-linux_*.whl /usr/local/share/ids/bindings/python/wheel/

# Alternative: Mount archive or .deb package into container and install
# RUN apt-get install -y -qq --no-install-recommends /repos/nimbro-ids-launch/ids-peak_2.9.0.0-48_amd64.deb
# RUN rm ids-peak_2.9.0.0-48_amd64.deb

# Cleanup
RUN apt-get autoremove -y 
RUN rm -rf /tmp/* /var/tmp/* 
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /repos

COPY include/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

ENV DEBIAN_FRONTEND teletype
