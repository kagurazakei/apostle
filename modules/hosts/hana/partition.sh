#!/usr/bin/env bash
# Desktop format-only script - assumes partitions already exist
# sda1 -> /home
# sdb1 -> /boot
# sdb2 -> / (btrfs)
# sdb3 -> swap

set -e

echo "=== Formatting Desktop Partitions ==="
echo "WARNING: This will DESTROY all data on /dev/sdb1, /dev/sdb2, /dev/sdb3, and /dev/sda1"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Format partitions (data will be wiped)
sudo mkfs.vfat -F 32 -n BOOT /dev/sdb1
sudo mkfs.btrfs -f -L NIXOS /dev/sdb2
sudo mkswap -L SWAP /dev/sdb3
sudo mkfs.btrfs -f -L HOME /dev/sda1

echo ""
echo "=== Creating BTRFS subvolumes ==="
sudo mount /dev/sdb2 /mnt
sudo btrfs subvolume create /mnt/@
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@log
sudo umount /mnt

sudo mount /dev/sda1 /mnt/home
sudo btrfs subvolume create /mnt/home/@home
sudo umount /mnt

echo ""
echo "=== Mounting for installation ==="
sudo mount -o subvol=@ /dev/sdb2 /mnt
sudo mkdir -p /mnt/{boot,nix,home,var/log}
sudo mount /dev/sdb1 /mnt/boot
sudo mount -o subvol=@nix /dev/sdb2 /mnt/nix
sudo mount -o subvol=@log /dev/sdb2 /mnt/var/log
sudo mount -o subvol=@home /dev/sda1 /mnt/home
sudo swapon /dev/sdb3

echo ""
echo "UUIDs for configuration:"
echo "Root UUID: $(sudo blkid -s UUID -o value /dev/sdb2)"
echo "Boot UUID: $(sudo blkid -s UUID -o value /dev/sdb1)"
echo "Home UUID: $(sudo blkid -s UUID -o value /dev/sda1)"
echo "Swap UUID: $(sudo blkid -s UUID -o value /dev/sdb3)"
