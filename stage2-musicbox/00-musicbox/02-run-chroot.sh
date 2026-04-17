#!/bin/bash -e

# install additional deb files
sudo apt-get -y install -f /tmp/*.deb
rm /tmp/*.deb

# remove dev packages, installed by default in raspberry pi os
sudo apt-get -y remove build-essential manpages-dev gdb pkg-config
sudo apt-get -y autoremove -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0

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
