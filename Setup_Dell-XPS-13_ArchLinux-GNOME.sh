#!/bin/bash
#############################################################################
# This is pseudocode. It doesn't actually run. Bad syntax and all that.     #
# This is just for reference incase I need to re-install Arch on my laptop  #
#############################################################################
timedatectl set-ntp true
mkfs.fat -F32 /dev/sda1 ; mkswap /dev/sda2 ; swapon /dev/sda2 ; mkfs.ext4 /dev/sda3 ; mkfs.ext4 /dev/sda4
mount /dev/sda3 /mnt ; mkdir /mnt/{home,boot} ; mount /dev/sda1 /mnt/boot ; mount /dev/sda4 /mnt/home
pacstrap /mnt base base-devel wifi-menu dialog wpa_supplicant bash bash-completion grub efibootmgr linux-lts linux-lts-headers linux-lts-docs
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

#### IN CHROOT ENVIRONMENT ####
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc
cp /etc/locale.gen /etc/locale.gen.orig ; echo en_US.UTF-8 UTF-8 > /etc/locale.gen ; locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo Dell-XPS-13 > /etc/hostname
## !!!! Add 'resume' hook just before fsck in /etc/mkinitcpio.conf !!!! ###
mkinitcpio -p linux
## Set root password
passwd
## Grub ##
## edit /etc/defaults/grub ##
## set the line as: GRUB_CMDLINE_LINUX_DEFAULT="resume=/dev/sda2" ##
## remove 'splash' and 'quiet'
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux ; grub-mkconfig -o /boot/grub/grub.cfg
exit
### EXIT CHROOT ENVIRONMENT ###
umount -R /mnt
poweroff
### Remove installation media ###
### reboot the computer ###
## login to root ##
read -p 'Enter the username for the primary user: ' USER
useradd -g users -G wheel,video -m -s /bin/bash $USER
passwd $USER
EDITOR=nano visudo #uncomment section to allow wheel group sudo access

### Switch to the new user ###
su $USER
sudo pacman -Syyu --noconfirm
sudo pacman -S xdg-user-dirs xdg-user-dirs-gtk --noconfirm ; xdg-user-dirs-gtk-update ; xdg-user-dirs-update
sudo pacman -S arc-solid-gtk-theme arc-gtk-theme --noconfirm
sudo pacman -S atom mailnag --noconfirm
sudo pacman -S networkmanager networkmanager-openconnect networkmanager-openvpn networkmanager-pptp --noconfirm
sudo systemctl enable NetworkManager.service ; sudo systemctl enable gdm.service ; sudo systemctl enable avahi-daemon.service

### Install Packages from AUR ###
wget https://aur.archlinux.org/cgit/aur.git/snapshot/gnome-gmail.tar.gz
tar xvf gnome-gmail.tar.gz ; rm gnome-gmail.tar.gz
cd gnome-gmail/ ; makepkg -si ; cd ..
rm gnome-gmail/ -rvf

wget https://aur.archlinux.org/cgit/aur.git/snapshot/gnome-terminal-transparency.tar.gz
tar xvf gnome-terminal-transparency.tar.gz ; rm gnome-terminal-transparency.tar.gz
cd gnome-terminal-transparency/ ; makepkg -si ; cd ..
rm gnome-terminal-transparency/ -rvf

wget https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz
tar xvf google-chrome.tar.gz ; rm google-chrome.tar.gz
cd google-chrome/ ; makepkg -si ; cd ..
rm google-chrome/ -rvf

wget https://aur.archlinux.org/cgit/aur.git/snapshot/numix-icon-theme-git.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/numix-circle-icon-theme-git.tar.gz
wget https://aur.archlinux.org/cgit/aur.git/snapshot/numix-circle-arc-icons-git.tar.gz
tar xvf numix-icon-theme-git.tar.gz ; rm numix-icon-theme-git.tar.gz
tar xvf numix-circle-icon-theme-git.tar.gz ; rm numix-circle-icon-theme-git.tar.gz
tar xvf numix-circle-arc-icons-git.tar.gz ; rm numix-circle-arc-icons-git.tar.gz
cd numix-icon-theme-git/ ; makepkg -si
cd ../numix-circle-icon-theme-git/ ; makepkg -si
cd ../numix-circle-arc-icons-git/ ; makepkg -si
cd ..
rm numix-icon-theme-git/ -rvf
rm numix-circle-icon-theme-git/ -rvf
rm numix-circle-arc-icons-git/ -rvf

wget https://aur.archlinux.org/cgit/aur.git/snapshot/python-autobgch.tar.gz
tar xvf python-autobgch.tar.gz ; rm python-autobgch.tar.gz
cd python-autobgch/ ; makepkg -si ; cd ..
rm python-autobgch/ -rvf
cp /etc/autobgch/autostart/bgchd-gnome.desktop  ~/.config/autostart/ -v

wget https://aur.archlinux.org/cgit/aur.git/snapshot/snapd.tar.gz
tar xvf snapd.tar.gz ; rm snapd.tar.gz
cd snapd/ ; makepkg -si ; cd ..
rm snapd/ -rvf
systemctl enable snapd.service ; systemctl start snapd.service
sudo snap install spotify

git clone https://github.com/julio641742/extend-panel-menu.git ; cd extend-panel-menu/
make all ; make install ; cd .. ; rm extend-panel-menu/ -rvf

cp -v /usr/share/applications/{bvnc.desktop,bssh.desktop,avahi-discover.desktop,org.gnome.tweaks.desktop,mpv.desktop,qv4l2.desktop,electron.desktop} ~/.local/share/applications/
echo NoDisplay=true >> ~/.local/share/applications/bvnc.desktop
echo NoDisplay=true >> ~/.local/share/applications/bssh.desktop
echo NoDisplay=true >> ~/.local/share/applications/avahi-discover.desktop
echo NoDisplay=true >> ~/.local/share/applications/org.gnome.tweaks.desktop
echo NoDisplay=true >> ~/.local/share/applications/mpv.desktop
echo NoDisplay=true >> ~/.local/share/applications/qv4l2.desktop
echo NoDisplay=true >> ~/.local/share/applications/electron.desktop

IFS=$'\n'; for x in $(sudo -u $USER gsettings list-recursively org.gnome.settings-daemon.plugins.power); do eval "sudo -u gdm dbus-launch gsettings set $x"; done; unset IFS

if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
echo 'set completion-ignore-case On' >> ~/.inputrc
systemctl --global disable pipewire.socket
