#!/bin/bash

# Improved version of disk space check script

# Configuration
path="/OBDX/OBDXui/deploy"
mount_point="/OBDX"
required_zip="deploy.zip"

# Error handling
set -o errexit   # Exit on most errors
set -o pipefail  # Exit on pipe failures
set -o nounset   # Exit on unset variables

# Functions
function die() {
    echo "ERROR: $*" >&2
    exit 1
}

function human_readable() {
    numfmt --to=iec --suffix=B "$1"
}

# Main script
echo "Checking disk space for deployment..."

# Check if directory exists
[ -d "$path" ] || die "Directory $path does not exist"

cd "$path" || die "Failed to change directory to $path"

# Check if zip file exists
[ -f "$required_zip" ] || die "File $required_zip not found in $path"

# Get zip file size
zip_info=$(unzip -l "$required_zip" | awk '/^---------/{getline; print $4}')
[ -z "$zip_info" ] && die "Failed to get size information from $required_zip"

Size_deploy_bytes=$zip_info
Final_size_M=$((Size_deploy_bytes / (1024 * 1024)))

echo "The size of $required_zip: $Final_size_M MB ($(human_readable "$Size_deploy_bytes"))"

# Get available space
fs_info=$(df -BM --output=avail "$mount_point" | awk 'NR==2 {print $1}')
[ -z "$fs_info" ] && die "Failed to get filesystem information for $mount_point"

available_space_M=${fs_info%M}  # Remove the 'M' suffix
echo "Free space in $mount_point: $available_space_M MB"

# Calculate difference
diff=$((available_space_M - Final_size_M))
echo "Remaining space after extraction: $diff MB"

# Check if there's enough space
if (( diff > 0 )); then
    echo "Success: There is sufficient free space to proceed"
    exit 0
else
    die "There is not enough free space in the filesystem"
fi