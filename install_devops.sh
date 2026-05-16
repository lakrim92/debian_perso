#!/bin/bash
set -euo pipefail

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║
███████║╚██████╗██║  ██║██║██║        ██║       ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝"

DNS_SERVER="1.1.1.1"
USER_NAME="bellinuxien"
RUSTDESK_VERSION="1.2.4"
VSCODIUM_VERSION="1.89.1.24130"

echo "Ajout du serveur DNS $DNS_SERVER"
echo "nameserver $DNS_SERVER" > /etc/resolv.conf

echo "Montage du système de fichiers devpts"
mountpoint -q /dev/pts || mount devpts /dev/pts -t devpts

if id "$USER_NAME" &>/dev/null; then
    echo "L'utilisateur $USER_NAME existe déjà."
else
    echo "Création de l'utilisateur : $USER_NAME"
    adduser "$USER_NAME"
    echo "Ajout de l'utilisateur $USER_NAME au groupe sudo"
    usermod -aG sudo "$USER_NAME"
fi

echo "Installation des paquets"
apt-get update
apt-get install -y wget curl git net-tools iptables rsyslog python3-pip python3-venv zip openssh-server gimp fail2ban vlc nginx

echo "Désactivation des services"
systemctl disable rsyslog nginx || true

echo "Configuration des sources apt"
curl -o /tmp/sources.list https://git.legaragenumerique.fr/GARAGENUM/apt-debian-12-bookworm/raw/branch/main/sources.list
mv /tmp/sources.list /etc/apt/sources.list

echo "Installation de RustDesk $RUSTDESK_VERSION"
curl -L "https://github.com/rustdesk/rustdesk/releases/download/${RUSTDESK_VERSION}/rustdesk-${RUSTDESK_VERSION}-x86_64.deb" -o "/tmp/rustdesk-${RUSTDESK_VERSION}-x86_64.deb"
dpkg -i "/tmp/rustdesk-${RUSTDESK_VERSION}-x86_64.deb" || apt-get install -f -y
rm "/tmp/rustdesk-${RUSTDESK_VERSION}-x86_64.deb"

echo "Installation de VSCodium $VSCODIUM_VERSION"
curl -L "https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VERSION}/codium_${VSCODIUM_VERSION}_amd64.deb" -o "/tmp/codium_${VSCODIUM_VERSION}_amd64.deb"
dpkg -i "/tmp/codium_${VSCODIUM_VERSION}_amd64.deb" || apt-get install -f -y
rm "/tmp/codium_${VSCODIUM_VERSION}_amd64.deb"

echo "Nettoyage"
apt-get clean

echo "Script devops terminé."
