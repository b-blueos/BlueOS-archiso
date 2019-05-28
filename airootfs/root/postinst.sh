#!/bin/bash
echo "Welcome to the chroot-environment! Continuing the installation..."
cd

# Localtime
echo "Temporairly fixing your time... You will need to manually change later... (Gotta fix this script...)"
ls -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc

# Locale
echo "Generating the locale... Can be changed later."
echo "en_US.UTF-8" >> /etc/locale.gen
locale-gen

# Mkinit
echo "Making the init, this may take a while..."
mkinitcpio -p linux

# Users
echo "Fixing the sudoers-file..."
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
read -p "What do you want your username to be? (ONLY LOWERCASE! Ex: user)" USERNAME
useradd -m -G wheel -s /bin/bash $USERNAME
echo "Choose the password for $USERNAME"
passwd $USERNAME

# ROOT passwd
echo "Choose a password for 'ROOT'-user. (System/Admin-user.)"
passwd

# Yay AUR-helper
echo "Installing yay, an AUR-helper."
echo "Used to install packages from the AUR. The installation is dependant on yay, may be removed later..."
cd /tmp/install-essentials/yay
echo "Making and installing the package..."
sleep 2
echo "makepkg -si" | su - $USERNAME
cd
echo "DONE!"

# Pacman many packages
echo "Installing a lot of packages...."
sleep 3
read -p "What video-card do you have intel/amdgpu/nouveau [nouveau is for nvidia.] (Must type in exactly one of those three! Shift Sensitive!)" VIDEO
pacman -S grub efibootmgr os-prober networkmanager network-manager-applet dialog xf86-input-libinput xorg-server xorg-xinit mesa xf86-video-$VIDEO
echo "DONE!"

# GRUB
echo "Installing GRUB..."
sleep 2
grub-install --target=x86_64-efi --efi-directory=boot/efi --bootloader-id=BlueOS
#-
echo "Enabling theme..."
cp /tmp/install-essentials/blueos-grub /boot/grub/themes
echo "GRUB_THEME=\"/boot/grub/themes/blueos-grub/theme.txt\"" >> /etc/default/grub
#-
sed -i 's/quiet/quiet splash/' /etc/default/grub
#-
echo "Adding a boot entry for the Reecovery..."
echo "This entry is experimental - may not work!"
echo "menuentry \"Recovery\" {" >> /etc/grub.d/40_custom
echo "set isofile=\"recovery.iso\"" >> /etc/grub.d/40_custom
echo "loopback loop (hd0,gpt102)$isofile" >> /etc/grub.d/40_custom
echo "linux (loop)/arch/boot/x86_64/vmlinuz archisodevice=/dev/loop0 img_dev=$imgdevpath img_loop=$isofile earlymodules=loop" >> /etc/grub.d/40_custom
echo "initrd (loop)/arch/boot/x86_64/archiso.img" >> /etc/grub.d/40_custom
echo "}" >> /etc/grub.d/40_custom
#-
echo "Making GRUB-configuration..."
grub-mkconfig -o /boot/grub/grub.cfg

# Locale set...
echo "Setting locale..."
localectl set-locale LANG="en_US.UTF-8"

# Systemctls...
systemctl enable NetworkManager

############################
# Customizations: 

# Desktop and Display Manager
echo "Installing GNOME and GDM (Plymouth-edition...)"
pacman -S gnome
#echo "Enabling custom theme... Theme made with Oomox - a tool to customize icons and GTK-themes."
#echo "Theme : Based on Materia."
#echo "Icons : Based on Papirus."
#gsettings set org.gnome.desktop.interface gtk-theme "THEME NAME!!!"
yay -S breeze-obsidian-cursor-theme
yay -S gdm-plymouth
systemctl enable gdm-plymouth

# Plymouth
echo "Installing Plymouth..."
yay -S plymouth
sed -i 's/udev/udev plymouth' /etc/mkinitcpio.conf
mkdir /usr/share/plymouth/themes/blueos
cp /tmp/install-essentials/blueos-plymouth/* /usr/share/plymouth/themes/blueos
sed -i 's/5/1' /etc/plymouth/plymouthd.conf
echo "Setting theme and rebuilding the initrd, may take some time..."
sleep 3
plymouth-set-default-theme blueos -R
#echo "Previewing theme...."
#plymouthd && plymouth --show-splash && sleep 8 && plymouth --hidesplash


# Cleaning up and exiting...
rm -rf /tmp/install-essentials
rm -rf /postinst.sh
echo
exit

