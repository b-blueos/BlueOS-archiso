#!/bin/bash

echo "Setting the time... (Currently the no choice here: GMT 0/UTC 0O)"  
ls -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

echo "Generating the locale... Can be changed later. (Currently: en_US)"
echo "en_US.UTF-8" >> /etc/locale.gen
locale-gen

