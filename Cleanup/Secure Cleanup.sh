#!/bin/bash

# Safe cleanup script - finds all folders with 'deploy_' in name and cleans them
# Deletes all contents except .zip files in each matching directory

# Enable extended globbing and nullglob
shopt -s extglob nullglob

# Set strict error handling
set -o errexit   # Exit on error
set -o nounset   # Exit on unset variables
set -o pipefail  # Exit on pipe failures

# Configuration
BASE_DIR="/OBDX/OBDXui"  # Parent directory to search from
DIR_PATTERN="deploy_"  # Pattern to match target directories
PROTECTED_EXT="zip"      # File extension to protect

# Safety checks
function die() {
    echo "ERROR: $*" >&2
    exit 1
}

[ -d "$BASE_DIR" ] || die "Base directory $BASE_DIR does not exist"

# Find all matching directories
readarray -t target_dirs < <(find "$BASE_DIR" -type d -name "$DIR_PATTERN" | sort)

if [ ${#target_dirs[@]} -eq 0 ]; then
    echo "No directories matching '$DIR_PATTERN' found in $BASE_DIR"
    exit 0
fi

# Dry run display
echo "=== DRY RUN ==="
echo "Found ${#target_dirs[@]} directories to process:"
printf '  %s\n' "${target_dirs[@]}"
echo "---------------------------------------------"

for dir in "${target_dirs[@]}"; do
    echo "Directory: $dir"
    echo "Would delete:"
    find "$dir" -type f ! -name "*.$PROTECTED_EXT" -printf "  %p\n" || true
    echo "Would keep:"
    find "$dir" -type f -name "*.$PROTECTED_EXT" -printf "  %p\n" || true
    echo "---------------------------------------------"
done

# Confirmation
read -rp "Are you sure you want to delete all non-.$PROTECTED_EXT files in these directories? [y/N] " confirm
if [[ "$confirm" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo "Starting cleanup..."
    for dir in "${target_dirs[@]}"; do
        echo "Processing $dir..."
        # Delete all non-zip files
        find "$dir" -type f ! -name "*.$PROTECTED_EXT" -exec rm -v {} \;
        # Delete empty directories (optional)
        find "$dir" -type d -empty -delete 2>/dev/null || true
    done
    echo "Cleanup complete."
else
    echo "Cleanup aborted by user."
    exit 0
fi

# Final verification
echo "=== Remaining files ==="
for dir in "${target_dirs[@]}"; do
    echo "Directory: $dir"
    ls -ltr "$dir" || true
done