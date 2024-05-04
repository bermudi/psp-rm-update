#!/bin/bash

# Check if fuseiso is installed
if ! command -v fuseiso &> /dev/null; then
    echo "fuseiso is not installed. Please install it first."
    exit 1
fi

# Path to the original ISO image
iso_path="/path/to/your/original/image.iso"

# Mount point for the ISO image
mount_point="$HOME/mnt/iso"

# Path to the directory to be modified
modify_dir="$mount_point/psp_game/sysdir/update"

# Check if the mount point exists, if not, create it
mkdir -p "$mount_point"

# Mount the ISO image using fuseiso
fuseiso "$iso_path" "$mount_point"

# Zero out all files inside the directory
find "$modify_dir" -type f -exec truncate -s 0 {} +

# Create a new ISO image with modifications
new_iso_path="/path/to/new/image.iso"
volume_label="PSP_ISO"

genisoimage -o "$new_iso_path" -J -r -iso-level 3 -V "$volume_label" "$mount_point"

# Unmount the ISO image
fusermount -u "$mount_point"

echo "ISO image modified successfully"

