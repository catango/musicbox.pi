#!/bin/bash -e

# install additional deb files
sudo apt-get -y install -f /tmp/*.deb
rm /tmp/*.deb

# pulseaudio
usermod -aG pulse-access pi
systemctl --global disable pulseaudio.service
systemctl enable pulseaudio.service

# mpd
usermod -aG pulse-access mpd
#systemctl enable mpd-tunnel
#systemctl enable mpd

# librespot
#systemctl enable librespot

#scream
usermod -aG pulse-access scream
#systemctl enable scream

# bluetooth
usermod -aG bluetooth pulse
#systemctl enable bluetooth.service
#systemctl enable bt-agent@hci0.service

# shairport-sync
usermod -aG pulse-access shairport-sync
#systemctl enable shairport-sync

systemctl enable firstboot.service
