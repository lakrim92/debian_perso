#!/bin/bash

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ██╗███╗   ██╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██║████╗  ██║
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██║██╔██╗ ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║██║╚██╗██║
███████║╚██████╗██║  ██║██║██║        ██║       ██║██║ ╚████║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝╚═╝  ╚═══╝"

check_installed_packages() {
    packages=$@
    for package in $packages; do
        if dpkg-query -W -f='${Status}' $package 2>/dev/null | grep -q "install ok installed"; then
            echo "$package est déjà installé."
        else
            echo "Installation de $package"
            sudo apt-get update
            sudo apt-get install -y $package
        fi
    done
}

echo "Installation XORRISO"
check_installed_packages xorriso fakeroot squashfs-tools syslinux syslinux-efi isolinux

echo "Décompression de l'image ISO"
# Recherche des fichiers ISO dans le répertoire courant
fichiers_iso=$(find "$PWD" -maxdepth 1 -type f -iname "*.iso")

if [ -n "$fichiers_iso" ]; then
    for fichier_iso in $fichiers_iso; do
        # Vérifie si le dossier "iso" existe déjà
        if [ ! -d "iso" ]; then
            # Si le dossier n'existe pas, extrait le fichier ISO dans "iso"
            xorriso -osirrox on -indev "$fichier_iso" -extract / iso && chmod -R +w iso
        else
            echo "Un dossier 'iso' existe déjà."
        fi
    done
else
    echo "Aucun fichier ISO trouvé dans le répertoire courant."
fi

echo "Copie du fichier filesystem.squashfs"
if [ ! -f filesystem.squashfs ]; then
    cp iso/live/filesystem.squashfs .
else 
    echo "Ce fichier existe déjà dans le dossier courant"
fi

echo "Décompression filesystem.squashfs"                                                                                                                                         
if [ ! -f squashfs-root ]; then
    sudo unsquashfs filesystem.squashfs
else 
    echo "Ce dossier existe déjà"
fi

echo "Accès chroot"
sudo chroot squashfs-root/

echo "Execution du script terminer"