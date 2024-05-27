# nimbro-ids-launch

## Links

- [Documentation and software for U3-36P1XLS-C Rev.1.2](https://en.ids-imaging.com/download-details/1009698.html?os=linux&version=&bus=64)
- [Application notes for U3-36P1XLS-C Rev.1.2](https://www.1stvision.com/cameras/IDS/IDS-manuals/en/application-notes-u3-36px.html)
- [Product website for U3-36P1XLS-C Rev.1.2](https://en.ids-imaging.com/store/u3-36p1xls-rev-1-2.html)
- [Implementation of ROS 2 node](https://github.com/bertan-karacora/nimbro_camera_ids)

## Usage

```bash
cd nimbro-ids-launch
scripts/download_resources.sh

Docker/build.sh --clean
Docker/run.sh
```

Check `Docker/config.sh`. Get the USB bus of IDS camera via

```bash
lsusb
```

<!-- TODO: Load from sciebo script? -->
<!-- TODO: Set USB buffer in run.sh or outside (needs sudo)? -->
<!-- TODO: Hard-coded stuff in start_watchdog.sh  -->
