#!/bin/bash

echo "Installing base-packages, this may take a while...."
sleep 3
pacstrap /mnt base base-devel linux-headers

echo "Generating the fstab."
genfstab -U /mnt >> /mnt/etc/fstab
echo "Your fstab looks like this:"
echo "  "
cat /mnt/etc/fstab
sleep 5