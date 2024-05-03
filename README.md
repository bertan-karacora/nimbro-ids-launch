# nimbro-ids-launch

## Links

- [IDS peak manual](https://en.ids-imaging.com/download-details/1009698.html?os=linux&version=&bus=64)
- [Application notes for U3-36P1XLS Rev.1.2](https://www.1stvision.com/cameras/IDS/IDS-manuals/en/application-notes-u3-36px.html)
- [Product website for U3-36P1XLS Rev.1.2](https://en.ids-imaging.com/store/u3-36p1xls-rev-1-2.html)
- [IDS Camera Node implementation for ROS 2](https://github.com/bertan-karacora/nimbro-ids-ros2)

## Temporary notes

Soccer config:

- Auto functions disabled
- FPS set to 25
- Horizontal and vertical binning with factor 2

<!-- For GUI:
xhost +
export DISPLAY=:0 -->

<!-- For config: Check USB bus of IDS camera via:

```bash
lsusb
``` -->

<!-- ros2 topic hz /camera_ids --window 20 -->

## Usage

```bash
cd nimbro-ids-launch
scripts/download_resources.sh

Docker/build.sh --clean
Docker/run.sh
```

<!-- TODO: Load from sciebo script -->
<!-- TODO: Watchdog -->
<!-- TODO: timestamps -->
<!-- TODO: ros2 message params -->
<!-- TODO: Camera config -->
<!-- TODO: Use Launch instead of run -->
