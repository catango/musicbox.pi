# MusicBoxPi

## Usage and features

This is a simple headless audio player for the Raspberry Pi, based on Raspberry Pi OS (Bookworm).

Following features are included:

* Spotify client (https://github.com/librespot-org/librespot)
* Bluetooth audio sink
* Scream audio sink (https://github.com/duncanthrax/scream)
* Airplay sink (via shairport-sync)
* Music player deamon, supporting remote audio share via sshfs and remote database

Features can be configured via configuration files in /boot/firmware folder on SD card.

musicbox.txt to automatically enable services
wifi_config.txt to configure wifi

## Build

The build is performed with the official raspberry pi os builder [pi-gen](https://github.com/RPi-Distro/pi-gen) to automatically build OS images.

Use Ubuntu or other Debian-based systems

### Required dependencies for pi-gen build on plain debian:
quilt parted qemu-user-static debootstrap zerofree zip dosfstools libarchive-tools rsync xz-utils curl xxd file bc gpg pigz arch-test

An apt proxy may be configured to speed up building

```bash
git clone --depth 1 https://github.com/catango/musicbox.pi.git
./init.sh

# install build dependencies, if not installed yet. Reboot may be required to load all kernel modules properly
sudo apt install quilt parted qemu-user-static debootstrap zerofree zip dosfstools libarchive-tools rsync xz-utils curl xxd file bc gpg pigz arch-test

sudo ./build.sh
```

For further details refer to:
- pi-gen: https://github.com/RPi-Distro/pi-gen

## Credits

Inspired by Nico Kaiser's simple audio receiver https://github.com/nicokaiser/rpi-audio-receiver
