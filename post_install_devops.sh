#!/bin/bash
# Runs inside the installed system via in-target (chroot). Internet available.
set -euo pipefail

RUSTDESK_VERSION="1.2.4"
VSCODIUM_VERSION="1.89.1.24130"

echo "==> Configuration des sources apt (Garage Numérique)"
curl -o /etc/apt/sources.list \
    https://git.legaragenumerique.fr/GARAGENUM/apt-debian-12-bookworm/raw/branch/main/sources.list
apt-get update

echo "==> Installation des paquets"
apt-get install -y \
    wget curl git net-tools iptables rsyslog \
    python3-pip python3-venv zip \
    openssh-server gimp fail2ban vlc nginx

echo "==> Désactivation des services au démarrage"
systemctl disable rsyslog nginx || true

echo "==> Installation de RustDesk $RUSTDESK_VERSION"
curl -L "https://github.com/rustdesk/rustdesk/releases/download/${RUSTDESK_VERSION}/rustdesk-${RUSTDESK_VERSION}-x86_64.deb" \
    -o /tmp/rustdesk.deb
dpkg -i /tmp/rustdesk.deb || apt-get install -f -y
rm /tmp/rustdesk.deb

echo "==> Installation de VSCodium $VSCODIUM_VERSION"
curl -L "https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VERSION}/codium_${VSCODIUM_VERSION}_amd64.deb" \
    -o /tmp/codium.deb
dpkg -i /tmp/codium.deb || apt-get install -f -y
rm /tmp/codium.deb

echo "==> Nettoyage"
apt-get clean

echo "Post-installation DevOps terminée."
echo "Consultez /var/log/post-install.log pour le détail."
