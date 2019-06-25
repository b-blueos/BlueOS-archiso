#!/bin/bash
echo "Installing for BIOS..."
#!/bin/bash
echo "o
n
p
1


w
" | fdisk /dev/sda

echo "Formatting partitions..."
mkfs.ext4 /dev/sda1

echo "Mounting 'Root'-Partition ( / )..."
mount /dev/sda1 /mnt

touch /mnt/bios

fallocate -l 8G /mnt/swap
chmod 600 /mnt/swap

echo "Creating and enabling SWAP."
mkswap /mnt/swap && swapon /mnt/swap
