#!/bin/bash
echo "Welcome to BlueOS!"
echo "Based on Arch Linux"

read -p "Are you sure you want to install BlueOS? [Y/n] " SURE_CHECK
if [ $SURE_CHECK == "n" ] || [ $SURE_CHECK == "N" ]
then 
     exit
fi

echo "Installing..."

read -p "Would you like to clear your whole drive, removing all partitions? (PERMANENT ACTION!) [y/N]" PURGE
if [ $PURGE == "y" ] || [ $PURGE == "Y" ]
then
				echo "Purging your drive..."
     bash purge.sh
fi

echo "Making partitions, this will use unallocated space on your harddrive. (Min: 32GB, Rec: 64GB)"
echo "This script uses /dev/sda{100, 101 and 102}, make sure they aren't used. (GPT required!)"
sleep 10
bash partitions.sh

echo "Configuring the partitions..."
bash filesystems.sh

echo "Installing the base OS..."
bash os.sh

echo "Preparing a chroot-environment..."
bash chroot.sh