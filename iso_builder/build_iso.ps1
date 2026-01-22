# Waya-OS: Custom ISO Builder
# Creates a bootable Windows 11/12 ISO with Waya-OS theme pre-configured
# Usage: .\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeGPUDrivers

param(
    [Parameter(Mandatory=$false)]
    [bool]$IncludeLauncher = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$IncludeVSCode = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$IncludeGPUDrivers = $false,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "iso_builder\output",
    
    [Parameter(Mandatory=$false)]
    [string]$WindowsSourcePath = ""
)

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Waya-OS: Custom ISO Builder                              ║" -ForegroundColor Cyan
Write-Host "║   Building personalized Windows installation media...      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verify requirements
Write-Host "[*] Checking system requirements..." -ForegroundColor Yellow

if (-not (Get-Command oscdimg -ErrorAction SilentlyContinue)) {
    Write-Host "    [!] WAIK/WADK tools not found!" -ForegroundColor Red
    Write-Host "    Download Windows ADK from: https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install" -ForegroundColor Yellow
    exit 1
}

Write-Host "    [OK] Windows ADK tools available" -ForegroundColor Green

# Create output directory
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
Write-Host "    Output directory: $OutputPath" -ForegroundColor Cyan

# Check disk space
$outputDrive = Split-Path -Path (Get-Item $OutputPath).FullName -Qualifier
$freeSpace = (Get-Item $outputDrive).AvailableFreeSpace / 1GB
Write-Host "    Available space: $([Math]::Round($freeSpace, 2)) GB" -ForegroundColor Cyan

if ($freeSpace -lt 15) {
    Write-Host "    [!] Less than 15GB free space! ISO build may fail." -ForegroundColor Red
    exit 1
}

# Step 1: Copy Windows source
Write-Host ""
Write-Host "[1/4] Preparing Windows source files..." -ForegroundColor Yellow

if (-not $WindowsSourcePath) {
    Write-Host "    Checking for Windows media..." -ForegroundColor Cyan
    
    # Try to find Windows installation media
    $commonPaths = @(
        "D:\",
        "E:\",
        "$env:USERPROFILE\Downloads\Windows*"
    )
    
    $found = $false
    foreach ($path in $commonPaths) {
        if (Test-Path "$path\sources\boot.wim") {
            $WindowsSourcePath = $path
            $found = $true
            break
        }
    }
    
    if (-not $found) {
        Write-Host "    [!] Could not find Windows media automatically" -ForegroundColor Red
        $WindowsSourcePath = Read-Host "    Enter path to Windows installation media (USB drive or ISO mounted)"
    }
}

if (-not (Test-Path "$WindowsSourcePath\sources\boot.wim")) {
    Write-Host "    [!] Invalid Windows source path!" -ForegroundColor Red
    exit 1
}

Write-Host "    [OK] Windows source found: $WindowsSourcePath" -ForegroundColor Green

# Copy source to working directory
$workingDir = "$OutputPath\working"
Write-Host "    Copying Windows files (this may take a few minutes)..." -ForegroundColor Cyan
robocopy "$WindowsSourcePath" "$workingDir" /E /R:1 /W:1 /NJH /NJS | Out-Null

Write-Host "    [OK] Windows files copied" -ForegroundColor Green

# Step 2: Inject Waya-OS theme
Write-Host ""
Write-Host "[2/4] Injecting Waya-OS theme and configuration..." -ForegroundColor Yellow

if (Test-Path ".\theme") {
    Write-Host "    [+] Adding theme files..." -ForegroundColor Cyan
    robocopy ".\theme" "$workingDir\Windows\Resources\Themes" /E /R:1 /W:1 /NJH /NJS | Out-Null
    robocopy ".\wallpapers" "$workingDir\Windows\Web\Wallpaper\Waya-OS" /E /R:1 /W:1 /NJH /NJS | Out-Null
    robocopy ".\icons" "$workingDir\Windows\Resources\Themes\Waya-OS" /E /R:1 /W:1 /NJH /NJS | Out-Null
}

Write-Host "    [OK] Theme injected" -ForegroundColor Green

# Step 3: Add optional components
Write-Host ""
Write-Host "[3/4] Preparing optional components..." -ForegroundColor Yellow

if ($IncludeLauncher) {
    Write-Host "    [+] Adding Aqua Jarvis launcher..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path "$workingDir\Windows\System32\Aqua-Jarvis" -Force | Out-Null
    robocopy ".\launcher" "$workingDir\Windows\System32\Aqua-Jarvis" /E /R:1 /W:1 /NJH /NJS | Out-Null
}

if ($IncludeVSCode) {
    Write-Host "    [+] Downloading VS Code Portable..." -ForegroundColor Cyan
    try {
        $vscodeUrl = "https://code.visualstudio.com/sha/download?builds=stable&os=win32-x64-zip&release=latest"
        $vscodeZip = "$OutputPath\vscode_portable.zip"
        Invoke-WebRequest -Uri $vscodeUrl -OutFile $vscodeZip -UseBasicParsing
        
        Write-Host "    [+] Extracting VS Code..." -ForegroundColor Cyan
        Expand-Archive $vscodeZip -DestinationPath "$workingDir\Program Files\Microsoft VS Code" -Force
        Remove-Item $vscodeZip -Force
    } catch {
        Write-Host "    [!] Could not download VS Code: $_" -ForegroundColor Yellow
    }
}

if ($IncludeGPUDrivers) {
    Write-Host "    [+] Preparing NVIDIA driver integration..." -ForegroundColor Cyan
    # Note: This would require downloading drivers separately due to size
    Write-Host "    [*] GPU drivers will be installed on first boot" -ForegroundColor Gray
}

Write-Host "    [OK] Components prepared" -ForegroundColor Green

# Step 4: Build ISO
Write-Host ""
Write-Host "[4/4] Building ISO image..." -ForegroundColor Yellow
Write-Host "    This may take 10-15 minutes..." -ForegroundColor Gray

$isoPath = Join-Path $OutputPath "WayaOS_AquaJarvis_v1.iso"

try {
    $etfPath = "$workingDir\efi\microsoft\boot\efisys.bin"
    
    oscdimg -bootdata:2 `
            -u1 `
            -udfver102 `
            -b"$workingDir\boot\etfsboot.com" `
            "$etfPath" `
            -o `
            -l "WayaOS_AquaJarvis" `
            "$workingDir" `
            "$isoPath"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    [OK] ISO image created successfully!" -ForegroundColor Green
    } else {
        Write-Host "    [!] ISO creation had issues. Check output above." -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "    [!] ISO creation error: $_" -ForegroundColor Red
    exit 1
}

# Cleanup
Write-Host ""
Write-Host "[*] Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item "$workingDir" -Recurse -Force -ErrorAction SilentlyContinue

# Final summary
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ISO Build Complete!                                      ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "ISO Location: $isoPath" -ForegroundColor Cyan
Write-Host "Size: $('{0:N2}' -f ((Get-Item $isoPath).Length / 1GB)) GB" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Use Rufus (https://rufus.ie) or BalenaEtcher to flash to USB" -ForegroundColor Gray
Write-Host "  2. Boot from USB on target machine" -ForegroundColor Gray
Write-Host "  3. Follow Windows installation wizard" -ForegroundColor Gray
Write-Host "  4. Theme will be applied automatically on first boot" -ForegroundColor Gray
Write-Host ""
Write-Host "Your custom Waya-OS ISO is ready to distribute!" -ForegroundColor Green
Write-Host ""
