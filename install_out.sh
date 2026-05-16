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

ISO_LABEL="Debian Live 12.5.0 amd64"
ISO_OUTPUT="debian-live-12.5.0-custom-amd64.iso"

echo "Compression filesystem.squashfs"
sudo mksquashfs squashfs-root/ filesystem.squashfs -comp xz -b 1M -noappend

echo "Copie du filesystem.squashfs dans iso/live/"
cp filesystem.squashfs ./iso/live/

echo "Calcul et sauvegarde des checksums"
find iso -type f -print0 | sort -z | xargs -0 md5sum > iso/md5sum.txt
sed -i 's|iso/|./|g' iso/md5sum.txt

echo "Compression de l'image ISO"
xorriso -as mkisofs -r -V "$ISO_LABEL" -o "$ISO_OUTPUT" \
    -J -l \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
    -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
    -isohybrid-mbr /usr/lib/ISOLINUX/isohdppx.bin \
    iso/boot iso

echo "Script out terminé. ISO générée : $ISO_OUTPUT"
