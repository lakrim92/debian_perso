#!/bin/bash
echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ██╗  ██╗ █████╗ ██████╗ ██╗████████╗ █████╗ ███╗   ██╗████████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██║  ██║██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝
███████╗██║     ██████╔╝██║██████╔╝   ██║       ███████║███████║██████╔╝██║   ██║   ███████║██╔██╗ ██║   ██║   
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██╔══██║██╔══██║██╔══██╗██║   ██║   ██╔══██║██║╚██╗██║   ██║   
███████║╚██████╗██║  ██║██║██║        ██║       ██║  ██║██║  ██║██████╔╝██║   ██║   ██║  ██║██║ ╚████║   ██║   
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝"

DNS_SERVER="1.1.1.1"
USER_NAME="nom_utilisateur"

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
sudo apt install flatpak -y

echo "Pour avoir accès aux paquets"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Install paquets flatpak"
flatpak install flathub org.libreoffice.LibreOffice org.mozilla.Thunderbird com.github.IsmaelMartinez.teams_for_linux io.github.flattool.Warehouse io.freetubeapp.FreeTube im.riot.Riot us.zoom.Zoom io.github.mimbrero.WhatsAppDesktop

echo "Nettoyage"
sudo apt-get clean
history -c
exit

echo "Execution du script terminer"