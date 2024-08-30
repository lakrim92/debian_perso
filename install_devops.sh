#!/bin/bash

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║
███████║╚██████╗██║  ██║██║██║        ██║       ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝"

DNS_SERVER="1.1.1.1"
USER_NAME="bellinuxien"

echo "Ajout du server DNS $DNS_SERVER"
echo "nameserver $DNS_SERVER" > /etc/resolv.conf

echo "Montage du système de fichiers devpts "
mount devpts /dev/pts -t devpts

if id "$USER_NAME" &>/dev/null; then
    echo "L'utilisateur $USER_NAME existe déjà."
else
    # Création de l'utilisateur
    echo "Création de l'utilisateur : $USER_NAME"
    adduser $USER_NAME
    
    # Ajout de l'utilisateur au groupe sudo
    echo "Ajout de l'utilisateur $USER_NAME au groupe sudo"
    usermod -aG sudo $USER_NAME
fi

echo "Changement de session pour l'utilisateur $USER_NAME"
su - $USER_NAME

echo "Installation des paquets"
sudo apt install rsyslog wget curl git net-tools iptables resolvconf rsyslog python3-pip python3-venv zip openssh-server gimp fail2ban vlc nginx -y

echo "Désactivation des services"
sudo systemctl stop nginx && sudo systemctl disable nginx

echo "Configuration des sources"
sudo curl -o /etc/apt/sources.list https://git.legaragenumerique.fr/GARAGENUM/apt-debian-12-bookworm/raw/branch/main/sources.list

echo "Installation de logiciels supplémentaires"
curl -LO https://github.com/rustdesk/rustdesk/releases/download/1.2.4/rustdesk-1.2.4-x86_64.deb && sudo dpkg -i rustdesk-1.2.4-x86_64.deb
curl -LO https://github.com/VSCodium/vscodium/releases/download/1.89.1.24130/codium_1.89.1.24130_amd64.deb && sudo dpkg -i codium_1.89.1.24130_amd64.deb
rm codium_1.89.1.24130_amd64.deb rustdesk-1.2.4-x86_64.deb

echo "Nettoyage"
sudo apt-get clean
history -c
exit

echo "Execution du script terminer"