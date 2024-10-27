#!/bin/bash -e

HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"

#echo "${MUSIC_SERVER_USER_PASS}" > "${HOME}/user_pass"
#echo "${MUSIC_SERVER_JUSER_PASS}" > "${HOME}/juser_pass"
#envsubst < files/config-musicserver.sh > "${ROOTFS_DIR}/usr/local/bin/config-musicserver.sh"
#install -m 644 files/config-musicserver.service "${ROOTFS_DIR}/etc/systemd/system/"

#install -m 644 files/config.txt "${ROOTFS_DIR}/boot/"
#install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/"

#HOME="${ROOTFS_DIR}/home/${FIRST_USER_NAME}"
#install -m 755 -o 1000 -g 1000 files/kiosk.sh "${HOME}/"

# modify login screen
echo "My IP address: \4" >> "${ROOTFS_DIR}/etc/issue"

#TMP_FILE=$(mktemp)

# imstall config
install -m 644 files/musicbox.txt "${ROOTFS_DIR}/boot/firmware/"

# install script for ssh key generation & setup
#envsubst < files/firstrun.sh > "${TMP_FILE}"
#install -m 755 -o 1000 -g 1000 "${TMP_FILE}" "${HOME}/firstrun.sh"
install -m 755 -o 0 -g 0 files/firstboot.sh "${ROOTFS_DIR}/usr/local/bin/"
install -m 644 -o 0 -g 0 files/firstboot.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 755 -o 0 -g 0 files/firstlogin.sh "${ROOTFS_DIR}/usr/local/bin/"
install -m 755 -o 0 -g 0 files/musicbox-reconfigure.sh "${ROOTFS_DIR}/usr/local/bin/"
install -m 644 -o 1000 -g 1000 files/.bashrc "${HOME}/"

# configure ssh
#install -m 755 -o 1000 -g 1000 -d "${HOME}/.ssh/"
#envsubst < files/ssh_config > "${TMP_FILE}"
#install -m 644 -o 1000 -g 1000 "${TMP_FILE}" "${HOME}/.ssh/config"

# configure mpd tunnel
install -m 644 -o 0 -g 0 files/mpd-tunnel.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 775 -o 1000 -g 1000 -d "${ROOTFS_DIR}/media/music/"
echo "user_allow_other" >> "${ROOTFS_DIR}/etc/fuse.conf"

# configure pulseaudio
install -m 644 -o 0 -g 0 files/pulseaudio.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 644 -o 0 -g 0 files/client.conf "${ROOTFS_DIR}/etc/pulse/client.conf"
install -m 644 -o 0 -g 0 files/socket.pa "${ROOTFS_DIR}/etc/pulse/default.pa.d/socket.pa"
echo "system-instance = yes
resample-method = speex-float-9
default-sample-format = float32le
resample-method = soxr-vhq" >> "${ROOTFS_DIR}/etc/pulse/daemon.conf"

# install mpd config
install -m 755 -o 0 -g 0 -d "${ROOTFS_DIR}/etc/systemd/system/mpd.service.d/"
install -m 644 -o 0 -g 0 files/mpd_override "${ROOTFS_DIR}/etc/systemd/system/mpd.service.d/override"
cat files/mpd.conf > "${ROOTFS_DIR}/etc/mpd.conf"

# install librespot
install -m 644 -o 0 -g 0 files/librespot.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 755 -o 0 -g 0 files/bin/librespot "${ROOTFS_DIR}/usr/local/bin/"

# install scream audio receiver
install -m 644 -o 0 -g 0 files/scream.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 755 -o 0 -g 0 files/bin/scream "${ROOTFS_DIR}/usr/local/bin/"

# configure bluetooth sink
install -m 644 -o 0 -g 0 files/main.conf "${ROOTFS_DIR}/etc/bluetooth/"
install -m 644 -o 0 -g 0 files/bt-agent@.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 755 -o 0 -g 0 files/bluetooth-udev "${ROOTFS_DIR}/usr/local/bin/"
install -m 644 -o 0 -g 0 files/99-bluetooth-udev.rules "${ROOTFS_DIR}/etc/udev/rules.d/"

# shairport-sync
install -m 644 -o 0 -g 0 files/shairport-sync.conf "${ROOTFS_DIR}/etc/"

#rm "${TMP_FILE}"

