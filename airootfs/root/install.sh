#!/bin/bash
echo "Welcome To BlueOS - Based on Arch Linux"

# WiFi
echo "Sign in to WiFi"
sleep 3
wifi-menu

# Variables
#echo "Setting up some variables...."
#set LVM="/dev/sda100"
#set VG="blue-os"
#set EFI="/dev/sda101"

# Partitions
echo "This shouldn't remove any partitions or data on your drive..."
echo "The script will utilize /dev/sda100, 101 and 102"
echo "/dev/sda100 : LVM-partition. (LVM inludes : ROOT (/) , SWAP, /VAR, /TMP, /HOME)"
echo "/dev/sda101 : EFI System Partition (ESP)"
echo "/dev/sda102 : Recovery partition. (Literally holds an .iso-file of Arch Linux that can be booted from GRUB...)"
echo "Important! This script needs atleast around 32 GB of UNALLOCATED space on the /dev/sda hard drive."
read -p "Are you sure? typ 'yes' to continue.  " ARE_YOU_SURE
if [ $ARE_YOU_SURE == "yes" ]
then 
echo "
"
read -p "Do you want to remove ALL partitions - Cleaning your drive. (PERMANENT ACTION: CAN'T BE UNDONE!!!) [Type 'yes' if you want to do this. If unsure just hit enter.]  " CLEAR_DRIVE
if [ $CLEAR_DRIVE == "yes" ]
then
	echo "Purging drive..."
	bash /etc/install-essentials/purge.sh
fi
bash /etc/install-essentials/partitions.sh

# Create LVM
echo "Creating LVM-Partition..."
pvcreate /dav/sda100
echo "Creating Volume Group..."
vgcreate blue-os /dev/sda100
echo "Creating Logical Volumes / Partitions..."
lvcreate -L 8G -n swap blue-os
lvcreate -L 2G -n tmp blue-os
lvcreate -L 8G -n var blue-os
lvcreate -L 4G -n var blue-os
lvcreate -l 50%FREE -n home blue-os
lvcreate -l 100%FREE -n root blue-os

# Format Partitions
echo "Formatting partitions..."
mkfs.ext4 /dev/blue-os/home
mkfs.ext4 /dev/blue-os/root
mkfs.ext4 /dev/blue-os/recovery
mkfs.ext4 /dev/blue-os/var
mkfs.btrfs /dev/blue-os/tmp
mkfs.vfat -F32 /dev/sda101

# Mount Partitions
echo "Mounting 'Root'-Partition ( / )..."
mount /dev/blue-os/root /mnt
#-------------
echo "Making neccessary directories..."
mkdir -v /mnt/home
mkdir -v /mnt/var
mkdir -v /mnt/tmp
mkdir -v /mnt/boot
mkdir -v /mnt/boot/recovery
mkdir -v /mnt/boot/efi
#-------------
echo "Mounting partitions..."
mount /dev/blue-os/home /mnt/home
mount /dev/blue-os/var /mnt/var
mount /dev/blue-os/tmp /mnt/tmp
mount /dev/sda102 /mnt/boot/recovery
mount /dev/sda101 /mnt/boot/efi

#SWAP
echo "Creating and enabling SWAP."
mkswap /dev/blue-os/swap && swapon /dev/blue-os/swap

# Pacstrap
echo "Installing base-packages, this may take a while...."
sleep 3
pacstrap /mnt base base-devel linux-headers

# FSTAB-Generation
echo "Generating the fstab."
genfstab -U /mnt >> /mnt/etc/fstab
echo "Your fstab looks like this:"
sleep 5
echo "  "
cat /mnt/etc/fstab

# Post Tasks
echo "Copying over neccessary files to your new system..."
mkdir /mnt/tmp/install-essentials
cp -a /etc/install-essentials/* /mnt/tmp/install-essentials
#--
echo "Preparing the recovery partition..."
# cp -a /etc/recovery/recovery.iso /mnt/boot/recovery
pacstrap /mnt/boot/recovery base
#--
cp /root/postinst.sh /mnt/postinst.sh
chmod +x /mnt/root/postinst.sh
#--
echo "Adding commands..."
cp /etc/install-essentials/bin/* /bin/

# Enter  Chroot
echo "Soon entering a chroot-environment."
echo "To continue the installation please type './postinst.sh' as soon as the chroot has commenced."
sleep 3
arch-chroot /mnt

#-----------------------#
# CHRROT-INSTALL-SCRIPT #
#-----------------------#

# True Post Install
### Commented out due to not working....
umount -a
#echo "Rebooting in:"
#echo "3"
#sleep 1
#echo "2"
#sleep 1
#echo "1"
#sleep 1
#reboot
echo "Done! You may now reboot and remove the installation-media (Ex: USB, CD)."
fi
