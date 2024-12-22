#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

OVERLAY_ENABLED=$(df -h | grep overlay)

MUSICBOX_CONFIG='/boot/firmware/musicbox.txt'
# shellcheck disable=SC1090
. "${MUSICBOX_CONFIG}"

if [ -n "${OVERLAY_ENABLED}" ]; then
    raspi-config nonint disable_overlayfs
    raspi-config nonint disable_bootro
    echo "Read only file system is activated and will be deactivated after reboot. Please rerun $(basename 0)"
    echo "Rebooting in 5 seconds..."
    sleep 5
    reboot
else
    /usr/local/bin/firstboot.sh
    sudo -u pi usr/local/bin/firstlogin.sh

fi
