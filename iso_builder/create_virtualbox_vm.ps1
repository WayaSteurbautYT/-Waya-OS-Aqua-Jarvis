# Waya-OS VirtualBox VM Creator
# Fixes VBOX_E_OBJECT_NOT_FOUND error by creating proper VM with attached disk

param(
    [Parameter(Mandatory=$false)]
    [string]$VMName = "Waya-OS-AquaJarvis",
    
    [Parameter(Mandatory=$false)]
    [string]$VMPath = "C:\Users\steur\VirtualBox VMs",
    
    [Parameter(Mandatory=$false)]
    [int]$RAM = 4096,
    
    [Parameter(Mandatory=$false)]
    [int]$DiskSize = 30720,
    
    [Parameter(Mandatory=$false)]
    [string]$ISOPath = ""
)

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Waya-OS VirtualBox VM Creator                            ║" -ForegroundColor Cyan
Write-Host "║   Setting up VM with proper disk configuration...         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verify VirtualBox installation
Write-Host "[*] Checking VirtualBox installation..." -ForegroundColor Yellow
$vboxManagePath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

if (-not (Test-Path $vboxManagePath)) {
    Write-Host "    [!] VirtualBox not found at: $vboxManagePath" -ForegroundColor Red
    Write-Host "    Please install VirtualBox from: https://www.virtualbox.org/wiki/Downloads" -ForegroundColor Yellow
    exit 1
}
Write-Host "    [OK] VirtualBox found" -ForegroundColor Green

# Create VM directory
Write-Host "[*] Creating VM directory..." -ForegroundColor Yellow
$vmDir = Join-Path $VMPath $VMName
New-Item -ItemType Directory -Path $vmDir -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "    [OK] VM directory: $vmDir" -ForegroundColor Green

# Check if VM already exists
Write-Host "[*] Checking for existing VM..." -ForegroundColor Yellow
$existingVM = & $vboxManagePath list vms | Select-String $VMName
if ($existingVM) {
    Write-Host "    [!] VM '$VMName' already exists" -ForegroundColor Yellow
    Write-Host "    Removing old VM..." -ForegroundColor Yellow
    & $vboxManagePath unregistervm $VMName --delete 2>&1 | Out-Null
    Start-Sleep -Seconds 2
}

# Create new VM
Write-Host "[*] Creating new VM: $VMName" -ForegroundColor Yellow
& $vboxManagePath createvm --name $VMName --ostype "Windows11_64" --register --basefolder $VMPath 2>&1 | Out-Null
Write-Host "    [OK] VM created" -ForegroundColor Green

# Configure VM settings
Write-Host "[*] Configuring VM settings..." -ForegroundColor Yellow

# Set memory
& $vboxManagePath modifyvm $VMName --memory $RAM --vram 128 2>&1 | Out-Null
Write-Host "    [OK] Memory: $RAM MB" -ForegroundColor Green

# Set CPU
& $vboxManagePath modifyvm $VMName --cpus 4 --cpu-profile host 2>&1 | Out-Null
Write-Host "    [OK] CPU: 4 cores" -ForegroundColor Green

# Set boot order
& $vboxManagePath modifyvm $VMName --boot1 dvd --boot2 disk 2>&1 | Out-Null
Write-Host "    [OK] Boot order: DVD first" -ForegroundColor Green

# Create disk
Write-Host "[*] Creating virtual disk..." -ForegroundColor Yellow
$diskPath = "$vmDir\$VMName.vdi"

& $vboxManagePath createhd --filename $diskPath --size $DiskSize --format VDI 2>&1 | Out-Null

if (Test-Path $diskPath) {
    $diskSizeGB = $DiskSize / 1024
    Write-Host "    [OK] Disk created: $diskPath" -ForegroundColor Green
    Write-Host "    Size: ${diskSizeGB}GB" -ForegroundColor Green
} else {
    Write-Host "    [!] Failed to create disk!" -ForegroundColor Red
    exit 1
}

# Create storage controller
Write-Host "[*] Setting up storage controller..." -ForegroundColor Yellow
& $vboxManagePath storagectl $VMName --name SATA --add sata --controller IntelAHCI 2>&1 | Out-Null
Write-Host "    [OK] SATA controller added" -ForegroundColor Green

# Attach disk
Write-Host "[*] Attaching disk..." -ForegroundColor Yellow
& $vboxManagePath storageattach $VMName --storagectl SATA --port 0 --device 0 --type hdd --medium $diskPath 2>&1 | Out-Null
Write-Host "    [OK] Disk attached" -ForegroundColor Green

# Add IDE controller for DVD
Write-Host "[*] Setting up IDE controller for ISO..." -ForegroundColor Yellow
& $vboxManagectl $VMName --name IDE --add ide 2>&1 | Out-Null
Write-Host "    [OK] IDE controller added" -ForegroundColor Green

# Attach ISO if provided
if ($ISOPath -and (Test-Path $ISOPath)) {
    Write-Host "[*] Attaching ISO..." -ForegroundColor Yellow
    & $vboxManagePath storageattach $VMName --storagectl IDE --port 0 --device 0 --type dvddrive --medium $ISOPath 2>&1 | Out-Null
    Write-Host "    [OK] ISO attached: $ISOPath" -ForegroundColor Green
}

# Enable 3D acceleration if possible
& $vboxManagePath modifyvm $VMName --accelerate3d on 2>&1 | Out-Null

# Network settings
& $vboxManagepath modifyvm $VMName --nic1 nat 2>&1 | Out-Null

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   VM CREATED SUCCESSFULLY!                                 ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "VM Details:" -ForegroundColor Cyan
Write-Host "  Name: $VMName" -ForegroundColor White
Write-Host "  Location: $vmDir" -ForegroundColor White
Write-Host "  RAM: $RAM MB" -ForegroundColor White
Write-Host "  Disk: ${diskSizeGB}GB at $diskPath" -ForegroundColor White

Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Open VirtualBox" -ForegroundColor White
Write-Host "  2. Find VM: $VMName" -ForegroundColor White
Write-Host "  3. Attach ISO: right-click → Settings → Storage" -ForegroundColor White
Write-Host "  4. Click 'Start' to boot" -ForegroundColor White

Write-Host ""
Write-Host "To start the VM from PowerShell:" -ForegroundColor Yellow
Write-Host "  & '$vboxManagePath' startvm $VMName --type gui" -ForegroundColor Gray
Write-Host ""
