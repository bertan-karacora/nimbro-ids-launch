## Temporary notes:

Download the debian package for the SDK from the peak website: https://en.ids-imaging.com/download-details/1009698.html?os=linux&version=&bus=64&floatcalc=
Install potential dependencies (not necessarily required):
 sudo apt-get install libqt5core5a libqt5gui5 libqt5widgets5 libqt5multimedia5 libqt5quick5 qml-module-qtquick-window2 qml-module-qtquick2 qtbase5-dev qtdeclarative5-dev qml-module-qtquick-dialogs qml-module-qtquick-controls qml-module-qtquick-layouts qml-module-qt-labs-settings qml-module-qt-labs-folderlistmodel libusb-1.0-0 libatomic1
Install IDS Peak: sudo apt install ./ids-peak-with-ueyetl_2.8.0.0-16438_amd64.deb
Increase USB buffer size to ensure proper bandwidth (not necessarily required): sudo /usr/local/scripts/ids_set_usb_mem_size.sh
SDK Manual: https://en.ids-imaging.com/manuals/ids-peak/ids-peak-user-manual/2.8.0/en/index.html

Config file: auto funktionen ausgeschaltet, die FPS auf 25 gesetzt und binning in horizontale und vertikale mit faktor 2 gemacht

For GUI: Run xhost + on host and look up docker command (mainly $DISPLAY and some other options)
export DISPLAY=:0

docker_cmd="docker run --net=host -e DISPLAY=$DISPLAY --name $DOCKER_IMAGE_NAME -v $CURRENT_PATH:/mounted/$CURRENT_DIR_NAME -v $CURRENT_PATH/ids-peak_2.9.0.0-48_amd64.deb:/mounted/ids-peak_2.9.0.0-48_amd64.deb --device=/dev:/dev -it $DOCKER_IMAGE_NAME  /bin/bash"
    # docker_cmd="docker run --net=host -e DISPLAY=$DISPLAY --name $DOCKER_IMAGE_NAME -v $CURRENT_PATH:/mounted/$CURRENT_DIR_NAME -v $CURRENT_PATH/ids-peak_2.9.0.0-48_amd64.deb:/mounted/ids-peak_2.9.0.0-48_amd64.deb --device=/dev/bus/usb/004/008 -it $DOCKER_IMAGE_NAME  /bin/bash"

[24633.174699] usb 4-2: USB disconnect, device number 3
[24640.264207] usb 4-2: new SuperSpeed USB device number 4 using xhci_hcd
[24640.285555] usb 4-2: New USB device found, idVendor=1409, idProduct=8000, bcdDevice= 0.00
[24640.285565] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[24640.285567] usb 4-2: Product: U3-36PxXLS-C
[24640.285569] usb 4-2: Manufacturer: IDS Imaging Development Systems GmbH
[24640.285571] usb 4-2: SerialNumber: 4108724364

Set camera parameters

```bash
cd nimbro-ids-launch
Docker/build.sh
Docker/run.sh
```

Success: Loading config changes FPS from 5 to 25. Still needed USB buffer increase.
