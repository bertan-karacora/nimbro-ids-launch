# nimbro-ids-launch

## Links

- [IDS peak SDK](https://en.ids-imaging.com/download-details/1009698.html?os=linux&version=&bus=64)

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

## Usage

```bash
cd nimbro-ids-launch
scripts/download_resources.sh

Docker/build.sh
Docker/run.sh
```

<!-- TODO: Load from sciebo script -->
<!-- TODO: Watchdog -->
<!-- TODO: Camera name -->
<!-- TODO: timestamps -->
<!-- TODO: ros2 message params -->
