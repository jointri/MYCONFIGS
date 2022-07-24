#!/bin/bash

#This script is to be ran AFTER you setup the partitions and debootstrap 'debootstrap --include=lsb_release,gnupg,wget,git,curl,vim --arch=amd64 jammy <chroot root>'
#Bad things will happen if you miss a dependency or didn't setup the partitions properly.
#It's also import to have done genfstab -U <mountpoint> >> <mountpoint>/etc/fstab along with arch-chroot <mountpoint> because the script is to be ran inside the chroot

