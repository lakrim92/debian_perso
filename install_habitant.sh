#!/bin/bash
set -euo pipefail

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ██╗  ██╗ █████╗ ██████╗ ██╗████████╗ █████╗ ███╗   ██╗████████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██║  ██║██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝
███████╗██║     ██████╔╝██║██████╔╝   ██║       ███████║███████║██████╔╝██║   ██║   ███████║██╔██╗ ██║   ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██╔══██║██╔══██║██╔══██╗██║   ██║   ██╔══██║██║╚██╗██║   ██║
███████║╚██████╗██║  ██║██║██║        ██║       ██║  ██║██║  ██║██████╔╝██║   ██║   ██║  ██║██║ ╚████║   ██║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝"

DNS_SERVER="1.1.1.1"
USER_NAME="habitant"

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

echo "Installation de flatpak"
apt-get update
apt-get install -y flatpak

echo "Ajout du dépôt Flathub"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installation des applications flatpak"
flatpak install -y flathub \
    org.libreoffice.LibreOffice \
    org.mozilla.Thunderbird \
    com.github.IsmaelMartinez.teams_for_linux \
    io.github.flattool.Warehouse \
    io.freetubeapp.FreeTube \
    im.riot.Riot \
    us.zoom.Zoom \
    io.github.mimbrero.WhatsAppDesktop

echo "Nettoyage"
apt-get clean

echo "Script habitant terminé."
