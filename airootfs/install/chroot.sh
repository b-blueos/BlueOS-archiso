#!/bin/bash
echo "Copying over necessary files..."
mkdir /mnt/install
cp -av postinst/* /mnt/install
cp -av postinst.sh /mnt/

mkdir /mnt/blue/install-essentials
cp -av /etc/install-essentials/* /mnt/blue/install-essentials/

echo "Entering chroot-environment..."
bash postinst.sh | arch-chroot /mnt
