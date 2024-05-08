# nimbro-ids-launch

## Links

- [IDS peak manual](https://en.ids-imaging.com/download-details/1009698.html?os=linux&version=&bus=64)
- [Application notes for U3-36P1XLS Rev.1.2](https://www.1stvision.com/cameras/IDS/IDS-manuals/en/application-notes-u3-36px.html)
- [Product website for U3-36P1XLS Rev.1.2](https://en.ids-imaging.com/store/u3-36p1xls-rev-1-2.html)
- [IDS Camera Node implementation for ROS 2](https://github.com/bertan-karacora/nimbro-ids-ros2)

## Usage

```bash
cd nimbro-ids-launch
scripts/download_resources.sh

Docker/build.sh --clean
Docker/run.sh
```

Adjust `Docker/config.sh`. Check USB bus of IDS camera via

```bash
lsusb
```

<!-- TODO: Load from sciebo script? -->
<!-- TODO: Set USB buffer in run.sh or outside (needs sudo)? -->
<!-- TODO: RMW Implementation? Adapt scripts if necessary. -->
<!-- TODO: Watchdog -->
<!-- TODO: What for: mkdir -p $HOME/.ros -->
<!-- TODO: Bashrc in tmux -->
<!-- TODO: Where set settings which config to use, which topics to watch? -->
<!-- TODO: Launch at start like Orbbec or not?-->
