#!/bin/bash

echo "Fixing the sudoers-file..."
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
read -p "What do you want your username to be? (ONLY LOWERCASE! Ex: user)" USERNAME
useradd -m -G wheel -s /bin/bash $USERNAME
echo "Choose the password for $USERNAME"
passwd $USERNAME
echo "Choose a password for 'ROOT'-user. (System/Admin-user.)"
passwd