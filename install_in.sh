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
check_installed_packages xorriso python3

echo "Recherche de l'ISO Debian netinstall"
mapfile -t fichiers_iso < <(find "$PWD" -maxdepth 1 -type f -iname "*.iso")

if [ ${#fichiers_iso[@]} -eq 0 ]; then
    echo ""
    echo "Aucun fichier ISO trouvé. Placez l'ISO Debian 12 netinstall dans ce dossier."
    echo "Téléchargement : https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
    echo "Exemple : debian-12.x.x-amd64-netinst.iso"
    exit 1
fi

ISO_SOURCE="${fichiers_iso[0]}"
echo "ISO source : $ISO_SOURCE"

echo "Sauvegarde du secteur de démarrage (MBR)"
dd if="$ISO_SOURCE" bs=432 count=1 of=mbr.bin status=none

if [ ! -d "iso_work" ]; then
    echo "Extraction de l'ISO dans iso_work/"
    xorriso -osirrox on -indev "$ISO_SOURCE" -extract / iso_work
    chmod -R +w iso_work
else
    echo "Dossier iso_work/ déjà existant, extraction ignorée."
fi

# Sauvegarde du chemin source pour install_out.sh
echo "$ISO_SOURCE" > .iso_source

echo "Préparation terminée."
