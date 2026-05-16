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

# ÉTAPE 1 — Préparation de l'environnement (extraction ISO, unsquashfs)
echo "==> Étape 1/3 : Préparation"
./install_in.sh
echo "Script in terminé."

# ÉTAPE 2 — Choix du profil et exécution dans le container
echo ""
echo "==> Étape 2/3 : Personnalisation"
echo "Quel profil souhaitez-vous installer ?"
echo "  1) DevOps  — nginx, git, VSCodium, RustDesk, fail2ban..."
echo "  2) Habitant — LibreOffice, Thunderbird, Zoom, WhatsApp, FreeTube..."
read -rp "Votre choix [1/2] : " profil

case "$profil" in
    1) script_profil="install_devops.sh" ;;
    2) script_profil="install_habitant.sh" ;;
    *) echo "Choix invalide. Abandon."; exit 1 ;;
esac

echo "Copie de $script_profil dans le container"
sudo cp "$script_profil" squashfs-root/tmp/
sudo chmod +x "squashfs-root/tmp/$script_profil"
trap 'sudo rm -f "squashfs-root/tmp/$script_profil"' EXIT

echo "Exécution de $script_profil via systemd-nspawn"
if [ "$script_profil" = "install_habitant.sh" ]; then
    # Expose le socket D-Bus de l'hôte — requis par flatpak-system-helper
    sudo systemd-nspawn -D squashfs-root/ --bind /run/dbus:/run/dbus /bin/bash "/tmp/$script_profil"
else
    sudo systemd-nspawn -D squashfs-root/ /bin/bash "/tmp/$script_profil"
fi

echo "Nettoyage du script dans le container"
sudo rm -f "squashfs-root/tmp/$script_profil"
trap - EXIT

echo "Script $script_profil terminé."

# ÉTAPE 3 — Génération de l'ISO finale
echo ""
echo "==> Étape 3/3 : Génération de l'ISO"
./install_out.sh
echo "Script out terminé."

echo ""
echo "ISO personnalisée générée avec succès."
