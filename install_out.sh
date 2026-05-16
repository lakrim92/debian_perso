#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗     ██████╗ ██╗   ██╗████████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██╔═══██╗██║   ██║╚══██╔══╝
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██║   ██║██║   ██║   ██║
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║   ██║██║   ██║   ██║
███████║╚██████╗██║  ██║██║██║        ██║       ╚██████╔╝╚██████╔╝   ██║
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝        ╚═════╝  ╚═════╝    ╚═╝"

PROFIL="${1:-}"
if [ -z "$PROFIL" ]; then
    echo "Quel profil ? devops ou habitant"
    read -rp "Profil [devops/habitant] : " PROFIL
fi

case "$PROFIL" in
    devops|habitant) ;;
    *) echo "Profil inconnu : $PROFIL. Valeurs acceptées : devops, habitant"; exit 1 ;;
esac

ISO_LABEL="Debian 12 Custom ${PROFIL^} amd64"
ISO_OUTPUT="debian-12-custom-${PROFIL}-amd64.iso"

echo "==> Injection du preseed ($PROFIL)"
cp "preseed_${PROFIL}.cfg" iso_work/preseed.cfg
cp "post_install_${PROFIL}.sh" iso_work/post_install.sh

echo "==> Modification des paramètres de démarrage (BIOS + UEFI)"
python3 << 'EOF'
import os, re

PRESEED = "auto=true priority=critical preseed/file=/cdrom/preseed.cfg"

# BIOS — isolinux configs
for path in [
    'iso_work/isolinux/txt.cfg',
    'iso_work/isolinux/gtk.cfg',
    'iso_work/isolinux/adtxt.cfg',
    'iso_work/isolinux/adgtk.cfg',
]:
    if not os.path.exists(path):
        continue
    txt = open(path).read()
    # Insert preseed params at the start of each append line value (idempotent)
    new = re.sub(
        r'^(\s*append\s+)(?!auto=true)',
        r'\1' + PRESEED + ' ',
        txt, flags=re.MULTILINE
    )
    if new != txt:
        open(path, 'w').write(new)
        print('Modified:', path)

# UEFI — grub.cfg
path = 'iso_work/boot/grub/grub.cfg'
if os.path.exists(path):
    txt = open(path).read()
    new = re.sub(
        r'(linux\s+/install[^\n]+vmlinuz)(?!\s+auto=true)',
        r'\1 ' + PRESEED,
        txt
    )
    if new != txt:
        open(path, 'w').write(new)
        print('Modified:', path)
EOF

echo "==> Génération de l'ISO : $ISO_OUTPUT"
xorriso -as mkisofs \
    -r -V "$ISO_LABEL" \
    -o "$ISO_OUTPUT" \
    -J -joliet-long \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot \
    -e boot/grub/efi.img \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -isohybrid-mbr mbr.bin \
    iso_work/

echo "Script out terminé. ISO générée : $ISO_OUTPUT"
