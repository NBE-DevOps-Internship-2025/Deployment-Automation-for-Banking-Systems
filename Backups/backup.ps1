# Get repository root
$REPO_ROOT = (git rev-parse --show-toplevel).Trim()
$BACKUP_DIR = Join-Path $REPO_ROOT "backups"
$TIMESTAMP = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$BACKUP_FOLDER = Join-Path $BACKUP_DIR "incoming_$TIMESTAMP"

# Get incoming changed files
$BRANCH = git rev-parse --abbrev-ref HEAD
$INCOMING_FILES = git diff --name-only HEAD..origin/$BRANCH

if (-not $INCOMING_FILES) {
    Write-Host "No incoming file changes detected."
    exit 0
}

Write-Host "Backing up these files before pull:"
$INCOMING_FILES | ForEach-Object { Write-Host " - $_" }

# Create backup directory structure
New-Item -ItemType Directory -Force -Path $BACKUP_FOLDER | Out-Null

# Copy each file individually with full path resolution
$INCOMING_FILES | ForEach-Object {
    $sourceFile = Join-Path $REPO_ROOT $_
    $destFile = Join-Path $BACKUP_FOLDER $_
    
    if (Test-Path $sourceFile -PathType Leaf) {
        $destDir = [System.IO.Path]::GetDirectoryName($destFile)
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Force -Path $destDir | Out-Null
        }
        Copy-Item $sourceFile $destFile -Force
        Write-Host "Copied: $sourceFile to $destFile"
    }
    else {
        Write-Host "Warning: File not found - $sourceFile"
    }
}

Write-Host "Backup completed in: $BACKUP_FOLDER"
Get-ChildItem $BACKUP_FOLDER -Recurse | Select-Object FullName