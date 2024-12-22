#!/usr/bin/env bash

conn_fail() {
    echo ">> Connection not established, exiting"
    #exit 1
}

echo ">> FIRST RUN"

# check, if server is reachable
echo "Testing network connection"
nc -z "${MUSIC_SERVER_PUBLIC}" "${MUSIC_SERVER_PORT}" 2>/dev/null || conn_fail

echo ">> Generate keys and register ssl connection"
ssh-keygen -f ~/.ssh/id_rsa -q -N ''

#copy ID jumpserver
ssh-copy-id -p "${MUSIC_SERVER_PORT}" "${MUSIC_SERVER_JUSER}@${MUSIC_SERVER_PUBLIC}" || conn_fail

#copy ID to music server
ssh-copy-id -o "ProxyJump=${MUSIC_SERVER_JUSER}@${MUSIC_SERVER_PUBLIC}:${MUSIC_SERVER_PORT}" "${MUSIC_SERVER_USER}@${MUSIC_SERVER_LOCAL}" || conn_fail

## commented for debugging purposes
#rm ~/firstrun.sh

#echo ">> Enabling Read-Only Overlay File System"
#sudo raspi-config nonint enable_overlayfs
#sudo raspi-config nonint enable_bootro

#sudo reboot
