#!/bin/bash
cd /install

echo "Configuring time, language, etc."
bash time.sh

echo "Configuring users..."
bash users.sh

echo "Configuring bootloader..."
bash bootloader.sh

echo "Installing drivers..."
bash drivers.sh

echo "Configuring what will happen on the first boot..."
echo "First boot will take longer time than usual due to some extra scripts..."
sleep 10
bash first_boot.sh
