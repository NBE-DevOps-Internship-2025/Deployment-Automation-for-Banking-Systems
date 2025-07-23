# Full Repository Backup Script
param(
    [string]$BackupName = ""
)

# Get repository root
$REPO_ROOT = (git rev-parse --show-toplevel).Trim()
$BACKUP_DIR = Join-Path $REPO_ROOT "backups"
$TIMESTAMP = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

if ($BackupName) {
    $BACKUP_FOLDER = Join-Path $BACKUP_DIR "full_${BackupName}_$TIMESTAMP"
} else {
    $BACKUP_FOLDER = Join-Path $BACKUP_DIR "full_$TIMESTAMP"
}

# Create backup directory
New-Item -ItemType Directory -Force -Path $BACKUP_FOLDER | Out-Null

Write-Host "Creating full backup of repository at: $REPO_ROOT"
Write-Host "Backup destination: $BACKUP_FOLDER"

# Get all files in the repository (including untracked, excluding .gitignore rules)
$ALL_FILES = git ls-files --cached --modified --others --exclude-standard

# Also include files that might be ignored but you want to back up (optional)
$EXTRA_FILES = Get-ChildItem -Path $REPO_ROOT -Recurse -File -Force | 
                Where-Object { $_.FullName -notlike "*\.git\*" -and $_.FullName -notlike "*\backups\*" }

# Combine and get unique paths
$FILES_TO_BACKUP = ($ALL_FILES + ($EXTRA_FILES | Select-Object -ExpandProperty FullName | ForEach-Object { $_.Substring($REPO_ROOT.Length + 1) })) | 
                   Select-Object -Unique

# Copy each file individually with full path resolution
$FILES_TO_BACKUP | ForEach-Object {
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

# Create a snapshot of current repository status
git status > (Join-Path $BACKUP_FOLDER "git_status.txt")
git log -n 10 > (Join-Path $BACKUP_FOLDER "git_recent_logs.txt")
git branch -v > (Join-Path $BACKUP_FOLDER "git_branches.txt")

Write-Host "Full backup completed in: $BACKUP_FOLDER"
Write-Host "Backup contains $($FILES_TO_BACKUP.Count) files"
Get-ChildItem $BACKUP_FOLDER -Recurse | Select-Object FullName