#!/bin/bash

echo "
███████╗ ██████╗██████╗ ██╗██████╗ ████████╗     ██████╗ ██╗   ██╗████████╗
██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝    ██╔═══██╗██║   ██║╚══██╔══╝
███████╗██║     ██████╔╝██║██████╔╝   ██║       ██║   ██║██║   ██║   ██║   
╚════██║██║     ██╔══██╗██║██╔═══╝    ██║       ██║   ██║██║   ██║   ██║   
███████║╚██████╗██║  ██║██║██║        ██║       ╚██████╔╝╚██████╔╝   ██║   
╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝        ╚═════╝  ╚═════╝    ╚═╝"

echo "Compression filesystem.squashfe"
sudo mksquashfs  squashfs-root/ filesystem.squashfs -comp xz -b 1M -noappend

echo "Copie a nouveau le fichier filesystem.squashfs dans le dossier iso/live/"
cp filesystem.squashfs ./iso/live/

echo "Calcul et sauvegarde du checksum"
md5sum iso/.disk/info > iso/md5sum.txt

echo "Remplacement des occurrences"
sed -i 's|iso/|./|g' iso/md5sum.txt

echo "Compression de l'image ISO"
xorriso -as mkisofs -r -V "Debian Live 12.5.0 amd64" -o debian-live-12.5.0-custom-amd64.iso -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -isohybrid-mbr /usr/lib/ISOLINUX/isohdppx.bin iso/boot iso

echo "Execution du script terminer"