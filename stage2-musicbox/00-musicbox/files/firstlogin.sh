#/bin/bash

echo ">> FIRST RUN"

MUSICBOX_CONFIG="/boot/firmware/musicbox.txt"
. "${MUSICBOX_CONFIG}"

SSH_CONFIG="${HOME}/.ssh/config"

FIRSTLOGIN_FLAG="/home/pi/.musicbox.pi.configured"

connection_fail() {
    echo ">> Connection cannot be established. Configuration aborted"
    rm "${SSH_CONFIG}"
    exit 1
}

create_config_bastion() {
    read -p "Please define hostname of bastion host [${music_server_hostname_bastion}]: " input
    if [ ! -z ${input} ]; then
        music_server_hostname_bastion=${input};
    fi
    read -p "Please define bastion host login [${music_server_user_bastion}]: " input
    if [ ! -z ${input} ]; then
        music_server_user_bastion=${input}
    fi

    while true; do
        read -p "Please define bastion host port [${music_server_port_bastion}]: " input
        if [ -z ${input} ]; then
            echo "Please enter a valid port number or continue with default port ${music_server_port_bastion}: "
            break
        elif [[ ${input} =~ ^[0-9]+$ ]]; then
            music_server_port_bastion=${input}
            break
        fi
    done
    create_config_local
}

create_config_local() {
    read -p "Please define hostname of mpd host [${music_server_hostname_local}]: " input
    if [ ! -z ${input} ]; then
        music_server_hostname_local=${input};
    fi
    read -p "Please define mpd host login [${music_server_user_local}]: " input
    if [ ! -z ${input} ]; then
        music_server_user_local=${input}
    fi

    while true; do
        read -p "Please define mpd host port [${music_server_port_local}]: " input
        if [ -z ${input} ]; then
            echo "Please enter a valid port number or continue with default port ${music_server_port_local}: "
            break
        elif [[ ${input} =~ ^[0-9]+$ ]]; then
            music_server_port_local=${input}
            break
        fi
    done
}

write_ssh_config_bastion() {
    cat <<- EOF > "${SSH_CONFIG}"
Host jump
    HostName    ${music_server_hostname_bastion}
    Port        ${music_server_port_bastion}
    User        ${music_server_user_bastion}
    LocalForward 6660 ${music_server_hostname_local}:6660

Host musicpd
    HostName    ${music_server_hostname_local}
    Port        ${music_server_port_local}
    User        ${music_server_user_local}
    ProxyJump   jump
EOF
}

write_ssh_config_local() {
    cat <<- EOF > "${SSH_CONFIG}"
Host jump
    HostName    ${music_server_hostname_local}
    Port        ${music_server_port_local}
    User        ${music_server_user_local}
    LocalForward 6660 localhost:6660

Host musicpd
    HostName    ${music_server_hostname_local}
    Port        ${music_server_port_local}
    User        ${music_server_user_local}
EOF
}

# change default password of pi user
passwd pi

# exit if mpd is disabled in config
if [ "${mpd_enable}" != 1 ]; then
    touch "${FIRSTLOGIN_FLAG}"
    exit
fi

# main
echo ">> Generate keys and register ssl connection"
ssh-keygen -f ~/.ssh/id_rsa -q -N ''

while true; do

read -p "Is the mpd server reachable via a bastion host (y/N) " yn

case $yn in
	[yY] ) create_config_bastion
        write_ssh_config_bastion
        nc -z ${music_server_hostname_bastion} ${music_server_port_bastion} 2>/dev/null || connection_fail
        ssh-copy-id jump || connection_fail
        ssh-copy-id musicpd || connection_fail
        break;;
    [nN]|'' ) create_config_local
        write_ssh_config_local
        nc -z ${music_server_hostname_local} ${music_server_port_local} 2>/dev/null || connection_fail
        ssh-copy-id musicpd || connection_fail
		break;;
	* ) echo invalid response;;
esac
done

sudo systemctl enable mpd-tunnel
sudo systemctl enable mpd

touch "${FIRSTLOGIN_FLAG}"

sudo raspi-config nonint enable_overlayfs
sudo raspi-config nonint enable_bootro
sudo reboot

