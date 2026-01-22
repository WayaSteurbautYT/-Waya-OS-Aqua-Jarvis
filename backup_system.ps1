# Waya-OS Pre-Install Backup Script
# Backs up: Logins, Syncing, Apps, Settings, Personal Files

$BackupPath = "$env:USERPROFILE\Desktop\Waya-OS-Backup-$(Get-Date -Format 'yyyy-MM-dd-HHmm')"
$Files = @()

Write-Host "Waya-OS Pre-Install Backup Starting..." -ForegroundColor Cyan
Write-Host "Creating backup folder: $BackupPath`n" -ForegroundColor Yellow

New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null

# Backup Browser Data
Write-Host "Backing up Browser Data..." -ForegroundColor Green

$ChromePaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Preferences"
)

foreach ($Path in $ChromePaths) {
    if (Test-Path $Path) {
        Copy-Item $Path -Destination $BackupPath -Force -ErrorAction SilentlyContinue
        $Files += (Split-Path -Leaf $Path)
    }
}

# Backup Edge
$EdgePaths = @(
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Bookmarks",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Preferences"
)

foreach ($Path in $EdgePaths) {
    if (Test-Path $Path) {
        Copy-Item $Path -Destination $BackupPath -Force -ErrorAction SilentlyContinue
        $Files += (Split-Path -Leaf $Path)
    }
}

# Backup Personal Files
Write-Host "Backing up Personal Files..." -ForegroundColor Green

$PersonalFolders = @(
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Pictures"
)

foreach ($Folder in $PersonalFolders) {
    if (Test-Path $Folder) {
        $FolderName = Split-Path -Leaf $Folder
        Copy-Item $Folder -Destination "$BackupPath\$FolderName" -Recurse -Force -ErrorAction SilentlyContinue
        $Files += $FolderName
    }
}

# Backup Installed Apps List
Write-Host "Backing up Installed Apps List..." -ForegroundColor Green

$AppsFile = "$BackupPath\InstalledApps.txt"
Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Out-File $AppsFile
$Files += "InstalledApps.txt"

# Backup Microsoft Store apps
Get-AppxPackage | Select-Object Name, Version | Export-Csv "$BackupPath\StoreApps.csv" -NoTypeInformation
$Files += "StoreApps.csv"

# Backup User Accounts
Write-Host "Backing up User Accounts..." -ForegroundColor Green

$AccountFile = "$BackupPath\UserAccounts.txt"
Get-LocalUser | Select-Object Name, Enabled, LastLogon | Out-File $AccountFile
$Files += "UserAccounts.txt"

# Backup WiFi Profiles
Write-Host "Backing up WiFi Profiles..." -ForegroundColor Green

$WifiPath = "$BackupPath\WiFi"
New-Item -ItemType Directory -Path $WifiPath -Force | Out-Null

netsh wlan export profile key=clear folder="$WifiPath" | Out-Null
if ((Get-ChildItem $WifiPath -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
    $Files += "WiFi"
    Write-Host "  WiFi profiles exported" -ForegroundColor Gray
}

# Backup System Settings
Write-Host "Backing up System Settings..." -ForegroundColor Green

$SettingsFile = "$BackupPath\SystemSettings.reg"
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows" $SettingsFile /y 2>$null
$Files += "SystemSettings.reg"

# Backup VS Code Settings
if (Test-Path "$env:APPDATA\Code") {
    Write-Host "Backing up VS Code Settings..." -ForegroundColor Green
    Copy-Item "$env:APPDATA\Code\User" -Destination "$BackupPath\VSCode-Settings" -Recurse -Force -ErrorAction SilentlyContinue
    $Files += "VSCode-Settings"
}

# Backup Email Signatures
if (Test-Path "$env:APPDATA\Microsoft\Signatures") {
    Write-Host "Backing up Email Signatures..." -ForegroundColor Green
    Copy-Item "$env:APPDATA\Microsoft\Signatures" -Destination "$BackupPath\Signatures" -Recurse -Force -ErrorAction SilentlyContinue
    $Files += "Signatures"
}

# Create Summary File
Write-Host "Creating Backup Summary..." -ForegroundColor Green

$SummaryFile = "$BackupPath\BACKUP_SUMMARY.txt"
@"
WAYA-OS PRE-INSTALL BACKUP
===============================================
Backup Date: $(Get-Date)
Backup Location: $BackupPath

BACKED UP:
- Browser bookmarks and settings
- Personal files (Documents, Pictures, Desktop)
- Installed apps list
- Store apps list
- User accounts
- WiFi profiles
- System settings
- VS Code configuration
- Email signatures

WHAT TO DO NEXT:
===============================================
1. Right-click backup folder on Desktop
2. Select "Send to" then "Compressed (zipped) folder"
3. Upload ZIP to cloud:
   - OneDrive (built-in Windows)
   - Google Drive (drive.google.com)
   - Mega (mega.io) - 50GB free

4. After Waya-OS installs:
   - Download backup from cloud
   - Extract the ZIP
   - Copy files back to your folders
   - Run InstalledApps.txt to reinstall programs

IMPORTANT NOTES:
- Passwords are NOT backed up (you will need to re-enter)
- Email accounts will need to re-login
- Browser bookmarks ARE saved
- WiFi profiles ARE saved
- Personal files ARE saved

Backup Complete!
"@ | Out-File $SummaryFile

# Create ZIP for Cloud Upload
Write-Host "`nCreating ZIP for Cloud Upload..." -ForegroundColor Cyan

$ZipPath = "$env:USERPROFILE\Desktop\Waya-OS-Backup.zip"
Compress-Archive -Path $BackupPath -DestinationPath $ZipPath -Force

$ZipSize = [math]::Round((Get-Item $ZipPath).Length / 1MB, 2)
Write-Host "OK - Backup ZIP Created!" -ForegroundColor Green
Write-Host "Size: $ZipSize MB" -ForegroundColor Yellow
Write-Host "Location: $ZipPath`n" -ForegroundColor Green

# Open the folder
Start-Process explorer.exe -ArgumentList "/select,$ZipPath"

Write-Host "BACKUP COMPLETE!" -ForegroundColor Green
Write-Host "Next: Upload Waya-OS-Backup.zip to cloud storage" -ForegroundColor Cyan
