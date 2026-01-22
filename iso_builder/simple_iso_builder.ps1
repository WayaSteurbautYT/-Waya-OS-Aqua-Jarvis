# Simple ISO Builder for Waya-OS
# Creates a bootable ISO from project files

param(
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "C:\Users\steur\Desktop\virtaulboxtest"
)

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

Write-Host "Waya-OS ISO Builder" -ForegroundColor Cyan
Write-Host "Creating bootable ISO file..." -ForegroundColor Cyan
Write-Host ""

# Create output directory
Write-Host "[*] Creating output directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $OutputPath -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "    [OK] Output: $OutputPath" -ForegroundColor Green

# Check if Oscdimg is available
$oscdimgPath = $null
$searchPaths = @(
    "C:\Program Files (x86)\Windows Kits\11\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe",
    "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe",
    "C:\Program Files (x86)\Windows Kits\8.1\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
)

foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $oscdimgPath = $path
        break
    }
}

if (-not $oscdimgPath) {
    Write-Host ""
    Write-Host "[!] ERROR: Windows ADK Oscdimg tool not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Installing Windows ADK..." -ForegroundColor Yellow
    Write-Host ""
    
    & powershell.exe -ExecutionPolicy Bypass -File "iso_builder\install_adk.ps1"
    exit 1
}

Write-Host "[*] Found Oscdimg tool" -ForegroundColor Green

# Create ISO structure directory
$isoWorkDir = "$OutputPath\iso_work"
Write-Host "[*] Preparing ISO structure..." -ForegroundColor Yellow
Remove-Item -Path $isoWorkDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path $isoWorkDir -Force | Out-Null

# Copy project files to ISO directory
Write-Host "[*] Copying project files..." -ForegroundColor Yellow
$projectRoot = "c:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

$folders = @("pages", "theme", "icons", "launcher", "ai_context", "scripts")
foreach ($folder in $folders) {
    $source = Join-Path $projectRoot $folder
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination (Join-Path $isoWorkDir $folder) -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Copy-Item -Path "$projectRoot\package.json" -Destination "$isoWorkDir\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$projectRoot\README.md" -Destination "$isoWorkDir\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$projectRoot\LICENSE" -Destination "$isoWorkDir\" -Force -ErrorAction SilentlyContinue

Write-Host "    [OK] Files copied" -ForegroundColor Green

# Create the ISO file
Write-Host "[*] Building ISO image..." -ForegroundColor Yellow
$isoOutput = "$OutputPath\Waya-OS-Aqua-Jarvis.iso"

try {
    # Create ISO using Oscdimg
    & $oscdimgPath -m -o "$isoWorkDir" "$isoOutput" 2>&1 | Out-Null
    
    if (Test-Path $isoOutput) {
        $isoSize = (Get-Item $isoOutput).Length / 1MB
        Write-Host "    [OK] ISO created successfully!" -ForegroundColor Green
        Write-Host "    File: $isoOutput" -ForegroundColor Cyan
        Write-Host "    Size: $([Math]::Round($isoSize, 2)) MB" -ForegroundColor Cyan
    } else {
        throw "ISO file not created"
    }
} catch {
    Write-Host "    [!] Error creating ISO: $_" -ForegroundColor Red
    exit 1
}

# Clean up temporary files
Write-Host "[*] Cleaning up..." -ForegroundColor Yellow
Remove-Item -Path $isoWorkDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host ""
Write-Host "ISO BUILD COMPLETE!" -ForegroundColor Green
Write-Host ""
Write-Host "ISO File Location:" -ForegroundColor Cyan
Write-Host "  $isoOutput" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Open VirtualBox or VMware" -ForegroundColor White
Write-Host "  2. Create a new VM (4GB RAM, 30GB disk)" -ForegroundColor White
Write-Host "  3. Attach the ISO file to CD/DVD drive" -ForegroundColor White
Write-Host "  4. Boot the VM" -ForegroundColor White
Write-Host ""
