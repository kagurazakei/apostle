#!/usr/bin/env bash
# Laptop format-only script - assumes partitions already exist
# nvme0n1p1 -> /boot
# nvme0n1p2 -> / (btrfs with subvolumes)
# nvme0n1p3 -> swap

set -e

echo "=== Formatting Laptop Partitions ==="
echo "WARNING: This will DESTROY all data on nvme0n1p1, nvme0n1p2, and nvme0n1p3"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Check if disk exists
if [ ! -e "/dev/nvme0n1" ]; then
    echo "ERROR: /dev/nvme0n1 not found!"
    echo "Available NVMe drives:"
    lsblk | grep nvme
    exit 1
fi

# Format partitions (data will be wiped)
sudo mkfs.vfat -F 32 -n BOOT /dev/nvme0n1p1
sudo mkfs.btrfs -f -L NIXOS /dev/nvme0n1p2
sudo mkswap -L SWAP /dev/nvme0n1p3

echo ""
echo "=== Creating BTRFS subvolumes ==="
sudo mount /dev/nvme0n1p2 /mnt
sudo btrfs subvolume create /mnt/@root
sudo btrfs subvolume create /mnt/@home
sudo btrfs subvolume create /mnt/@nix
sudo btrfs subvolume create /mnt/@persist
sudo btrfs subvolume create /mnt/@log
sudo umount /mnt

echo ""
echo "=== Mounting for installation ==="
sudo mount -o subvol=@root /dev/nvme0n1p2 /mnt
sudo mkdir -p /mnt/{boot,home,nix,persist,var/log}
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo mount -o subvol=@home /dev/nvme0n1p2 /mnt/home
sudo mount -o subvol=@nix /dev/nvme0n1p2 /mnt/nix
sudo mount -o subvol=@persist /dev/nvme0n1p2 /mnt/persist
sudo mount -o subvol=@log /dev/nvme0n1p2 /mnt/var/log
sudo swapon /dev/nvme0n1p3

echo ""
echo "UUIDs for configuration:"
echo "Root UUID: $(sudo blkid -s UUID -o value /dev/nvme0n1p2)"
echo "Boot UUID: $(sudo blkid -s UUID -o value /dev/nvme0n1p1)"
echo "Swap UUID: $(sudo blkid -s UUID -o value /dev/nvme0n1p3)"
