#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ██╗███╗   ██╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██║████╗  ██║
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██║██╔██╗ ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║██║╚██╗██║
███████║╚██████╗██║  ██║██║██║        ██║       ██║██║ ╚████║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝╚═╝  ╚═══╝"

check_installed_packages() {
    local to_install=()

    for package in "$@"; do
        if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
            echo "$package est déjà installé."
        else
            to_install+=("$package")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        sudo apt-get update
        sudo apt-get install -y "${to_install[@]}"
    fi
}

echo "Installation des outils requis"
check_installed_packages xorriso fakeroot squashfs-tools syslinux syslinux-efi isolinux systemd-container

echo "Décompression de l'image ISO"
mapfile -t fichiers_iso < <(find "$PWD" -maxdepth 1 -type f -iname "*.iso")

if [ ${#fichiers_iso[@]} -gt 0 ]; then
    for fichier_iso in "${fichiers_iso[@]}"; do
        if [ ! -d "iso" ]; then
            xorriso -osirrox on -indev "$fichier_iso" -extract / iso && chmod -R +w iso
        else
            echo "Un dossier 'iso' existe déjà."
        fi
    done
else
    echo "Aucun fichier ISO trouvé dans le répertoire courant."
    exit 1
fi

echo "Copie du fichier filesystem.squashfs"
if [ ! -f filesystem.squashfs ]; then
    cp iso/live/filesystem.squashfs .
else
    echo "Ce fichier existe déjà dans le dossier courant"
fi

echo "Décompression filesystem.squashfs"
if [ ! -d squashfs-root ]; then
    sudo unsquashfs filesystem.squashfs
else
    echo "Ce dossier existe déjà"
fi

echo "Préparation terminée."
