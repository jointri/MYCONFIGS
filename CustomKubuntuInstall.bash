#!/bin/bash

#This script is to be ran AFTER you setup the partitions and debootstrap 'debootstrap --include=locales,apt-transport-https,lsb-release,gnupg,wget,git,curl,vim --arch=amd64 jammy <chroot root>'
#Bad things will happen if you miss a dependency or didn't setup the partitions properly.
#It's also import to have done genfstab -U <mountpoint> >> <mountpoint>/etc/fstab along with arch-chroot <mountpoint> because the script is to be ran inside the chroot

####SETTING UP SOURCES
cat > /etc/apt/sources.list << HEREDOC
deb https://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
deb-src https://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse

deb https://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src https://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse

deb https://archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src https://archive.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse

deb https://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb-src https://archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse

deb http://archive.canonical.com/ubuntu/ jammy partner
deb-src http://archive.canonical.com/ubuntu/ jammy partner
HEREDOC

####################################################################
#Setting up timezone
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

#Setting up locales
sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
#############################################################
apt update
apt upgrade -y




#########################################################
#SETUP ADDITIONAL KERNELS AND ADDITIONAL SOURCES
##################################################
#
#
#
#
#
#
#
#
#
#
#

###################
#HOSTNAME AND STUFF
###################
cat > /etc/hostname << HEREDOC
linux
HEREODC

####

cat > /etc/hosts << HEREDOC
127.0.0.1	    localhost
::1		        localhost
127.0.1.1	    linux.localdomain	linux
HEREDOC




########################################################
#Setup default kernel and other packages
#########################################################
#You can remove packages as necessary
apt install -y linux-generic linux-firmware linux-modules-iwlwifi-generic xserver-xorg-video-all xserver-xorg-input-all fluxbox network-manager-gnome grub2

#################################################################
#password and at minimal one user
#################################################################
ROOTPASSWORD=$(read -p "Enter the root password: " -s)

ADDITIONALUSERNAME=$(read -p "What is the name of the non root user? ")
ADDITIONALUSERNAMEPASSWORD=$(read -p "Enter the password of the non root user: " -s)


passwd $ROOTPASSWORD

useradd -m -g users -s /bin/bash $ADDITIONALUSERNAME
passwd $ADDITIONALUSERNAME >>> $ADDITIONALUSERNAMEPASSWORD




#########################################################################
#GRUB SETUP
###############################################################################
grub-install --target=i386-pc /dev/mmcblk0
grub-mkconfig -o /boot/grub/grub.cfg

echo "COMPLETED! YOU MUST REMEMBER TO UNMOUNT EVERYTHING AFTER EXITING THE CHROOT!"
