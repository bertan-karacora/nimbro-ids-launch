FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

ARG USERNAME_GITLAB
ARG TOKEN_GITLAB
ARG DEBIAN_FRONTEND=noninteractive

# Install tools
RUN apt-get update -qq
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

# Install dependencies
RUN apt-get update -qq
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

# Install IDS peak
# Assume package is in /resources
COPY resources/ids-peak_*.deb /tmp/
RUN apt-get update -qq
RUN apt-get install -y -qq --no-install-recommends \
    /tmp/ids-peak_*.deb

# Alternative: Install IDS peak
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
# RUN apt-get update -qq
# RUN apt-get install -y -qq --no-install-recommends \
#     ids-peak

# Install Python tools
RUN pip install \
    ipykernel

# Install Python dependencies
RUN pip install \
    numpy

# Install Python bindings
# Assume Python 3.10
RUN pip install \
    /usr/local/share/ids/bindings/python/wheel/ids_peak-*-cp37-abi3-linux_*.whl \
    /usr/local/share/ids/bindings/python/wheel/ids_peak_afl-*-cp37-abi3-linux_*.whl \
    /usr/local/share/ids/bindings/python/wheel/ids_peak_ipl-*-cp310-cp310-linux_*.whl

# Add explicit Python modules
RUN git clone "https://$USERNAME_GITLAB:$TOKEN_GITLAB@git.ais.uni-bonn.de/athome/nimbro_utils.git" /colcon_ws/src/nimbro_utils
RUN git clone https://github.com/bertan-karacora/nimbro_camera_ids.git /colcon_ws/src/nimbro_camera_ids

# Build ROS 2 workspace using colcon
WORKDIR /colcon_ws
RUN source /opt/ros/humble/setup.bash && \
    colcon build --symlink-install
WORKDIR /

# Cleanup
RUN apt-get autoremove -y -qq
RUN apt-get clean -qq
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=teletype
ENV DISPLAY=:0

ENTRYPOINT ["/repos/nimbro-ids-launch/scripts/start_all.sh"]
CMD ["/bin/bash"]
