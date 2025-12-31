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

# librespot
# no permissions to add

#scream
usermod -aG pulse-access scream

# bluetooth
usermod -aG bluetooth pulse

# shairport-sync
usermod -aG pulse-access shairport-sync

systemctl enable firstboot.service
