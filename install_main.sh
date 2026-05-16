#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗    ███╗   ███╗ █████╗ ██╗███╗   ██╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ████╗ ████║██╔══██╗██║████╗  ██║
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██╔████╔██║███████║██║██╔██╗ ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║╚██╔╝██║██╔══██║██║██║╚██╗██║
███████║╚██████╗██║  ██║██║██║        ██║       ██║ ╚═╝ ██║██║  ██║██║██║ ╚████║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝"

echo ""
echo "Quel profil souhaitez-vous installer ?"
echo "  1) DevOps  — nginx, git, VSCodium, RustDesk, fail2ban, openssh-server..."
echo "  2) Habitant — LibreOffice, Thunderbird, Zoom, WhatsApp, FreeTube, Teams..."
read -rp "Votre choix [1/2] : " choix

case "$choix" in
    1) PROFIL="devops" ;;
    2) PROFIL="habitant" ;;
    *) echo "Choix invalide. Abandon."; exit 1 ;;
esac

echo ""
echo "==> Étape 1/2 : Préparation de l'ISO source"
./install_in.sh

echo ""
echo "==> Étape 2/2 : Génération de l'ISO personnalisée ($PROFIL)"
./install_out.sh "$PROFIL"

echo ""
echo "ISO prête. Testez-la dans VirtualBox ou installez-la sur une machine physique."
echo "Mot de passe par défaut : debian (à changer dans preseed_${PROFIL}.cfg)"
