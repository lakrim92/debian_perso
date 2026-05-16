#!/bin/bash
# Runs inside the installed system via in-target (chroot). Internet available.
set -euo pipefail

echo "==> Installation de flatpak"
apt-get update
apt-get install -y flatpak

echo "==> Ajout du dépôt Flathub"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "==> Création du service first-boot pour les applications flatpak"
# Les apps flatpak nécessitent un D-Bus actif — on les installe au premier démarrage

cat > /usr/local/bin/install-flatpak-apps.sh << 'SCRIPT'
#!/bin/bash
set -euo pipefail
flatpak install -y flathub \
    org.libreoffice.LibreOffice \
    org.mozilla.Thunderbird \
    com.github.IsmaelMartinez.teams_for_linux \
    io.github.flattool.Warehouse \
    io.freetubeapp.FreeTube \
    im.riot.Riot \
    us.zoom.Zoom \
    io.github.mimbrero.WhatsAppDesktop
SCRIPT
chmod +x /usr/local/bin/install-flatpak-apps.sh

cat > /etc/systemd/system/flatpak-apps-install.service << 'SERVICE'
[Unit]
Description=Install Flatpak apps on first boot
After=network-online.target
Wants=network-online.target
ConditionPathExists=/var/lib/flatpak-apps-pending

[Service]
Type=oneshot
ExecStart=/usr/local/bin/install-flatpak-apps.sh
ExecStartPost=/bin/rm -f /var/lib/flatpak-apps-pending
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
SERVICE

touch /var/lib/flatpak-apps-pending
systemctl enable flatpak-apps-install.service

echo "==> Nettoyage"
apt-get clean

echo "Post-installation Habitant terminée."
echo "IMPORTANT: Les apps flatpak seront installées au premier démarrage (internet requis)."
