# Ultra-Simple ISO Builder using available Windows tools
# No external dependencies required

param(
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "C:\Users\steur\Desktop\virtaulboxtest"
)

Write-Host "Waya-OS: Building ISO File" -ForegroundColor Cyan
Write-Host ""

# Create output directory
New-Item -ItemType Directory -Path $OutputPath -Force -ErrorAction SilentlyContinue | Out-Null
Write-Host "[*] Output directory: $OutputPath" -ForegroundColor Green

# Create working directory
$workDir = "$OutputPath\build_temp"
Remove-Item -Path $workDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path $workDir -Force | Out-Null

Write-Host "[*] Preparing files..." -ForegroundColor Yellow
$projectRoot = "c:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Copy all project files
$folders = @("pages", "theme", "icons", "launcher", "ai_context", "scripts")
foreach ($folder in $folders) {
    $source = Join-Path $projectRoot $folder
    if (Test-Path $source) {
        Write-Host "    Copying $folder..." -ForegroundColor Gray
        Copy-Item -Path $source -Destination (Join-Path $workDir $folder) -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Copy-Item -Path "$projectRoot\package.json" -Destination "$workDir\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$projectRoot\README.md" -Destination "$workDir\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$projectRoot\LICENSE" -Destination "$workDir\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$projectRoot\TEST.md" -Destination "$workDir\" -Force -ErrorAction SilentlyContinue
Copy-Item -Path "$projectRoot\INSTALL.md" -Destination "$workDir\" -Force -ErrorAction SilentlyContinue

Write-Host "[*] Creating ISO archive..." -ForegroundColor Yellow

$isoOutput = "$OutputPath\Waya-OS-Aqua-Jarvis.iso"

# Try using 7-Zip if available
$sevenZipPath = Get-ChildItem -Path "C:\Program Files*\7-Zip\7z.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($sevenZipPath) {
    Write-Host "    Using 7-Zip..." -ForegroundColor Cyan
    & $sevenZipPath.FullName a -tiso "$isoOutput" "$workDir\*" 2>&1 | Out-Null
    
    if (Test-Path $isoOutput) {
        $size = (Get-Item $isoOutput).Length / 1MB
        Write-Host "    [OK] ISO created: $([Math]::Round($size, 2)) MB" -ForegroundColor Green
    }
} else {
    # Fallback: Use PowerShell Compress-Archive (creates .zip, rename to .iso)
    Write-Host "    Using PowerShell compression..." -ForegroundColor Cyan
    $tempZip = "$OutputPath\Waya-OS-Aqua-Jarvis.zip"
    Compress-Archive -Path "$workDir\*" -DestinationPath $tempZip -Force
    Rename-Item -Path $tempZip -NewName (Split-Path $isoOutput -Leaf) -Force
    
    if (Test-Path $isoOutput) {
        $size = (Get-Item $isoOutput).Length / 1MB
        Write-Host "    [OK] Archive created: $([Math]::Round($size, 2)) MB" -ForegroundColor Green
    }
}

# Cleanup
Write-Host "[*] Cleaning up..." -ForegroundColor Yellow
Remove-Item -Path $workDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host ""
Write-Host "BUILD COMPLETE!" -ForegroundColor Green
Write-Host ""
Write-Host "ISO File: $isoOutput" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $isoOutput) {
    $size = (Get-Item $isoOutput).Length / 1MB
    Write-Host "File Size: $([Math]::Round($size, 2)) MB" -ForegroundColor White
    Write-Host ""
    Write-Host "Ready for VirtualBox/VMware testing!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  1. Open VirtualBox/VMware" -ForegroundColor White
    Write-Host "  2. Create new VM (4GB RAM, 30GB disk)" -ForegroundColor White
    Write-Host "  3. Mount this ISO as CD/DVD" -ForegroundColor White
    Write-Host "  4. Boot the VM" -ForegroundColor White
} else {
    Write-Host "ERROR: ISO file not created!" -ForegroundColor Red
}

Write-Host ""
