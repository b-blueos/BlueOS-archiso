#!/bin/bash
echo "Creating a LVM..."
pvcreate /dav/sda100
echo "Creating Volume Group..."
vgcreate blueos /dev/sda100
echo "Creating Logical Volumes / Partitions..."
lvcreate -L 8G -n swap blueos
lvcreate -L 2G -n tmp blueos
lvcreate -L 8G -n var blueos
lvcreate -L 4G -n blue blueos
lvcreate -l 100%FREE -n root blueos


echo "Formatting partitions..."
mkfs.ext4 /dev/blueos/blue
mkfs.ext4 /dev/blueos/root
mkfs.ext4 /dev/blueos/var
mkfs.btrfs /dev/blueos/tmp
mkfs.vfat -F32 /dev/sda101
mkfs.ext4 /dev/sda102


echo "Mounting 'Root'-Partition ( / )..."
mount /dev/blueos/root /mnt

echo "Making neccessary directories..."
mkdir -v /mnt/{boot,blue,tmp,var}
mkdir -v /mnt/boot/{efi,recovery}

echo "Mounting partitions..."
mount /dev/blueos/home /mnt/home
mount /dev/blueos/var /mnt/var
mount /dev/blueos/tmp /mnt/tmp
mount /dev/sda102 /mnt/boot/recovery
mount /dev/sda101 /mnt/boot/efi

echo "Creating and enabling SWAP."
mkswap /dev/blueos/swap && swapon /dev/blueos/swap