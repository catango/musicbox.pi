#!/bin/sh

MUSICBOX_CONFIG='/boot/firmware/musicbox.txt'
#MUSICBOX_CONFIG='./musicbox.txt'

# shellcheck disable=SC1090
. "${MUSICBOX_CONFIG}"

# mpd is only enabled after config is properly created. This is done after first login.

# shellcheck disable=SC2154
if [ "${librespot_enable}" -eq 1 ]; then
    systemctl enable librespot
else
    systemctl disable librespot
fi

# shellcheck disable=SC2154
if [ "${scream_enable}" -eq 1 ]; then
    systemctl enable scream
else
    systemctl disable scream
fi

# shellcheck disable=SC2154
if [ "${bluetooth_enable}" -eq 1 ]; then
    systemctl enable bluetooth.service
    systemctl enable bt-agent@hci0.service
else
    systemctl disable bluetooth.service
    systemctl disable bt-agent@hci0.service
fi

# shellcheck disable=SC2154
if [ "${shairport_sync_enable}" -eq 1 ]; then
    systemctl enable shairport-sync
else
    systemctl disable shairport-sync
fi

systemctl disable firstboot.service

# if no additional mpd config is required at first login, system can be set to read only
# shellcheck disable=SC2154
if [ "${mpd_enable}" -ne 1 ]; then
    systemctl disable mpd-tunnel
    systemctl disable mpd
    raspi-config nonint enable_overlayfs
    raspi-config nonint enable_bootro
    reboot
fi

echo "Configuration from ${MUSICBOX_CONFIG} applied successfully"
