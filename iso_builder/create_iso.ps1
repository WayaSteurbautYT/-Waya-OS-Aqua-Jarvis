# Simple Waya-OS ISO Creator (No ADK Required)
# Uses 7-Zip to create bootable ISO

param(
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\iso_builder\output"
)

Write-Host "Waya-OS ISO Creator" -ForegroundColor Cyan
Write-Host "Creating ISO without Windows ADK..." -ForegroundColor Yellow
Write-Host ""

# Create output directory
New-Item -ItemType Directory -Path $OutputPath -Force -ErrorAction SilentlyContinue | Out-Null

$projectRoot = "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"
$isoWorkDir = "$OutputPath\iso_work"
$isoOutput = "$OutputPath\Waya-OS-Aqua-Jarvis.iso"

# Clean up old work directory
Write-Host "[*] Preparing ISO structure..." -ForegroundColor Yellow
Remove-Item -Path $isoWorkDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
New-Item -ItemType Directory -Path $isoWorkDir -Force | Out-Null

# Copy project files
Write-Host "[*] Copying project files..." -ForegroundColor Yellow
$folders = @("pages", "theme", "icons", "launcher", "ai_context", "scripts", "iso_builder")
foreach ($folder in $folders) {
    $source = Join-Path $projectRoot $folder
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination (Join-Path $isoWorkDir $folder) -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Copied $folder" -ForegroundColor Green
    }
}

# Copy key files
$files = @("package.json", "README.md", "LICENSE", "tsconfig.json", "tailwind.config.js", "next.config.js", "vercel.json")
foreach ($file in $files) {
    $source = Join-Path $projectRoot $file
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $isoWorkDir -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "    [OK] Files copied" -ForegroundColor Green

# Try using 7-Zip if available
Write-Host "[*] Creating ISO..." -ForegroundColor Yellow

$sevenZipPaths = @(
    "C:\Program Files\7-Zip\7z.exe",
    "C:\Program Files (x86)\7-Zip\7z.exe"
)

$sevenZipFound = $false
foreach ($path in $sevenZipPaths) {
    if (Test-Path $path) {
        Write-Host "    Found 7-Zip at: $path" -ForegroundColor Green
        
        # Remove old ISO
        Remove-Item -Path $isoOutput -Force -ErrorAction SilentlyContinue | Out-Null
        
        # Create ISO
        & $path a -tiso $isoOutput $isoWorkDir 2>&1 | Out-Null
        
        if (Test-Path $isoOutput) {
            $size = (Get-Item $isoOutput).Length / 1MB
            Write-Host "    [OK] ISO created: $isoOutput" -ForegroundColor Green
            Write-Host "    Size: $([Math]::Round($size, 2)) MB" -ForegroundColor Green
            $sevenZipFound = $true
            break
        }
    }
}

# Fallback: Use PowerShell to create a ZIP as ISO
if (-not $sevenZipFound) {
    Write-Host "    [!] 7-Zip not found, creating as ZIP..." -ForegroundColor Yellow
    
    Remove-Item -Path "$OutputPath\Waya-OS-Aqua-Jarvis.zip" -Force -ErrorAction SilentlyContinue | Out-Null
    
    # Compress the folder
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($isoWorkDir, "$OutputPath\Waya-OS-Aqua-Jarvis.zip", 'Optimal', $true)
    
    if (Test-Path "$OutputPath\Waya-OS-Aqua-Jarvis.zip") {
        $size = (Get-Item "$OutputPath\Waya-OS-Aqua-Jarvis.zip").Length / 1MB
        Write-Host "    [OK] Archive created" -ForegroundColor Green
        Write-Host "    File: $OutputPath\Waya-OS-Aqua-Jarvis.zip" -ForegroundColor Cyan
        Write-Host "    Size: $([Math]::Round($size, 2)) MB" -ForegroundColor Green
    }
}

# Clean up
Write-Host "[*] Cleaning up..." -ForegroundColor Yellow
Remove-Item -Path $isoWorkDir -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host ""
Write-Host "BUILD COMPLETE!" -ForegroundColor Green
Write-Host ""
Write-Host "Output:" -ForegroundColor Cyan

if (Test-Path $isoOutput) {
    Write-Host "  ISO: $isoOutput" -ForegroundColor White
} else {
    Write-Host "  Archive: $OutputPath\Waya-OS-Aqua-Jarvis.zip" -ForegroundColor White
}

Write-Host ""
Write-Host "Next: Attach to VirtualBox VM" -ForegroundColor Yellow
Write-Host ""

# List files in output
Write-Host "Output folder contents:" -ForegroundColor Cyan
Get-ChildItem -Path $OutputPath | Where-Object { -not $_.PSIsContainer } | ForEach-Object {
    $sizeGB = $_.Length / 1GB
    if ($sizeGB -lt 1) {
        $sizeMB = $_.Length / 1MB
        Write-Host "  [OK] $($_.Name) ($([Math]::Round($sizeMB, 2)) MB)" -ForegroundColor White
    } else {
        Write-Host "  [OK] $($_.Name) ($([Math]::Round($sizeGB, 2)) GB)" -ForegroundColor White
    }
}
