# PC Storage Cleanup Script
# Safely removes temporary and cache files to free up space
# Protects: ISO folder, project files, user documents

param(
    [Parameter(Mandatory=$false)]
    [bool]$SkipConfirmation = $false
)

Write-Host "Windows Storage Cleanup Tool" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check disk space before
$disk = Get-Volume -DriveLetter C
$freeBefore = $disk.SizeRemaining / 1GB
Write-Host "Before Cleanup:" -ForegroundColor Yellow
Write-Host "  Free Space: $([Math]::Round($freeBefore, 2)) GB" -ForegroundColor White
Write-Host ""

# Define cleanup areas (safe to delete)
$cleanupAreas = @(
    @{
        Name = "Windows Temp Files"
        Path = "$env:WINDIR\Temp"
        Description = "Temporary system files (safe to delete)"
    },
    @{
        Name = "User Temp Files"
        Path = "$env:TEMP"
        Description = "User temporary files (safe to delete)"
    },
    @{
        Name = "Windows Update Cache"
        Path = "$env:WINDIR\SoftwareDistribution\Download"
        Description = "Old Windows Update files (safe to delete)"
    },
    @{
        Name = "Temporary Internet Files"
        Path = "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"
        Description = "Browser cache files (safe to delete)"
    },
    @{
        Name = "Recycle Bin"
        Path = "$env:LOCALAPPDATA\..\All Users\Recycle.Bin"
        Description = "Items in Recycle Bin"
    }
)

Write-Host "Cleanup Areas:" -ForegroundColor Yellow
Write-Host ""

$totalToDelete = 0
$cleanupTasks = @()

foreach ($area in $cleanupAreas) {
    if (Test-Path $area.Path) {
        $size = 0
        try {
            $files = Get-ChildItem -Path $area.Path -Recurse -Force -ErrorAction SilentlyContinue
            $size = ($files | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB
        } catch {
            $size = 0
        }
        
        if ($size -gt 0.01) {
            Write-Host "  [$($cleanupTasks.Count + 1)] $($area.Name)" -ForegroundColor Cyan
            Write-Host "      Size: $([Math]::Round($size, 2)) GB" -ForegroundColor White
            Write-Host "      Path: $($area.Path)" -ForegroundColor Gray
            Write-Host "      Note: $($area.Description)" -ForegroundColor Gray
            Write-Host ""
            
            $cleanupTasks += @{
                Name = $area.Name
                Path = $area.Path
                Size = $size
            }
            
            $totalToDelete += $size
        }
    }
}

if ($cleanupTasks.Count -eq 0) {
    Write-Host "No significant cleanup areas found." -ForegroundColor Green
    exit 0
}

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Estimated Total Space to Free: $([Math]::Round($totalToDelete, 2)) GB" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

if (-not $SkipConfirmation) {
    $proceed = Read-Host "Proceed with cleanup? (yes/no)"
    if ($proceed -ne "yes") {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "Starting cleanup..." -ForegroundColor Yellow
Write-Host ""

$deletedSize = 0

foreach ($task in $cleanupTasks) {
    Write-Host "Cleaning: $($task.Name)..." -ForegroundColor Cyan
    
    try {
        # Remove files
        Get-ChildItem -Path $task.Path -Recurse -Force -ErrorAction SilentlyContinue | 
            Where-Object { -not $_.PSIsContainer } | 
            Remove-Item -Force -ErrorAction SilentlyContinue
        
        # Remove empty directories
        Get-ChildItem -Path $task.Path -Recurse -Force -ErrorAction SilentlyContinue | 
            Where-Object { $_.PSIsContainer } | 
            Remove-Item -Force -ErrorAction SilentlyContinue
        
        Write-Host "  [OK] Completed" -ForegroundColor Green
        $deletedSize += $task.Size
    } catch {
        Write-Host "  [!] Some files could not be deleted (may be in use)" -ForegroundColor Yellow
    }
}

# Clear Recycle Bin
Write-Host "Emptying Recycle Bin..." -ForegroundColor Cyan
try {
    $shell = New-Object -ComObject Shell.Application
    $recycleBin = $shell.NameSpace(10)
    $recycleBin.Self.InvokeVerb("Empty")
    Write-Host "  [OK] Recycle Bin emptied" -ForegroundColor Green
} catch {
    Write-Host "  [!] Could not empty Recycle Bin" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Cleanup Complete!" -ForegroundColor Green
Write-Host ""

# Check disk space after
Start-Sleep -Seconds 2
$disk = Get-Volume -DriveLetter C
$freeAfter = $disk.SizeRemaining / 1GB

Write-Host "After Cleanup:" -ForegroundColor Yellow
Write-Host "  Free Space: $([Math]::Round($freeAfter, 2)) GB" -ForegroundColor White
Write-Host "  Space Freed: $([Math]::Round($freeAfter - $freeBefore, 2)) GB" -ForegroundColor Green
Write-Host ""

# Additional cleanup options
Write-Host "Optional Advanced Cleanup:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Disk Cleanup Utility:" -ForegroundColor White
Write-Host "   cleanmgr.exe" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Storage Sense (Settings):" -ForegroundColor White
Write-Host "   Settings > System > Storage > Storage Sense" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Check Large Files:" -ForegroundColor White
Write-Host "   TreeSize Free or WizTree" -ForegroundColor Gray
Write-Host ""
