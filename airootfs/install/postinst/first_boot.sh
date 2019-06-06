#!/bin/bash
cp -av first_boot/blue.service /etc/systemd/system/
cp -av first_boot/blue /usr/bin/
chmod 755 /usr/bin/blue
systemctl enable blue.service

useradd -m -d /blue -G wheel -s /bin/bash blue
