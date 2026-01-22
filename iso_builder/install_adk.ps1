# Windows ADK Installer for Waya-OS ISO Building
# Downloads and installs Windows ADK with ISO creation tools

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Windows ADK Installer                                    ║" -ForegroundColor Cyan
Write-Host "║   Installing tools for ISO creation...                     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

# Download path
$adkPath = "$env:TEMP\adksetup.exe"
$adkUrl = "https://go.microsoft.com/fwlink/?linkid=2196127"

Write-Host "[1/3] Downloading Windows ADK..." -ForegroundColor Yellow
Write-Host "      This may take a few minutes..." -ForegroundColor Cyan

try {
    # Download ADK installer
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $adkUrl -OutFile $adkPath -UseBasicParsing
    
    if (Test-Path $adkPath) {
        $size = (Get-Item $adkPath).Length / 1MB
        Write-Host "      [OK] Downloaded: $([Math]::Round($size, 2)) MB" -ForegroundColor Green
    } else {
        throw "Download failed"
    }
} catch {
    Write-Host "      [!] Download failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "MANUAL INSTALLATION:" -ForegroundColor Yellow
    Write-Host "  1. Go to: https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install" -ForegroundColor White
    Write-Host "  2. Download 'Windows ADK for Windows 11'" -ForegroundColor White
    Write-Host "  3. Run the installer" -ForegroundColor White
    Write-Host "  4. Select 'Deployment Tools' feature" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "[2/3] Installing Windows ADK..." -ForegroundColor Yellow
Write-Host "      This will open the installer window..." -ForegroundColor Cyan
Write-Host "      Please select 'Deployment Tools' when prompted" -ForegroundColor Cyan

try {
    # Run ADK installer with Deployment Tools selected
    & $adkPath /features OptionId.DeploymentTools /norestart /quiet
    
    Write-Host "      [OK] Installer launched" -ForegroundColor Green
    Write-Host ""
    Write-Host "      Waiting for installation to complete..." -ForegroundColor Cyan
    Write-Host "      (This may take 5-15 minutes)" -ForegroundColor Cyan
    
    # Wait for installer to complete
    Start-Sleep -Seconds 5
    
    # Check if oscdimg.exe exists
    $maxWait = 0
    while ($maxWait -lt 900) { # 15 minute timeout
        $oscdimgPath = Get-ChildItem -Path "C:\Program Files (x86)\Windows Kits\*\Assessment and Deployment Kit\Deployment Tools\*\Oscdimg\oscdimg.exe" -ErrorAction SilentlyContinue
        
        if ($oscdimgPath) {
            Write-Host "      [OK] Installation complete!" -ForegroundColor Green
            break
        }
        
        Start-Sleep -Seconds 5
        $maxWait += 5
    }
    
} catch {
    Write-Host "      [!] Installation error: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[3/3] Verifying installation..." -ForegroundColor Yellow

$oscdimgFound = Get-ChildItem -Path "C:\Program Files (x86)\Windows Kits\*\Assessment and Deployment Kit\Deployment Tools\*\Oscdimg\oscdimg.exe" -ErrorAction SilentlyContinue

if ($oscdimgFound) {
    Write-Host "      [OK] Oscdimg tool verified!" -ForegroundColor Green
    Write-Host "      Location: $($oscdimgFound.FullName)" -ForegroundColor Cyan
} else {
    Write-Host "      [!] Tool not found yet..." -ForegroundColor Yellow
    Write-Host "      Installation may still be in progress." -ForegroundColor Yellow
    Write-Host "      Please wait and try the ISO builder again in a few minutes." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   INSTALLATION COMPLETE!                                   ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  Run the ISO builder again:" -ForegroundColor White
Write-Host ""
Write-Host "  cd 'c:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis'" -ForegroundColor White
Write-Host "  powershell.exe -ExecutionPolicy Bypass -File 'iso_builder\simple_iso_builder.ps1'" -ForegroundColor White
Write-Host ""
