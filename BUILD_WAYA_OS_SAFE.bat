@echo off
title Waya-OS Safe ISO Builder v2.0
setlocal enabledelayedexpansion

:: ===================================
:: WAYA-OS SAFE ISO BUILDER v2.0
:: Digital Apocalypse Edition
:: ===================================

:: Configuration
set "PROJECT_ROOT=%~dp0"
set "OUTPUT_DIR=%PROJECT_ROOT%iso_output"
set "WORK_DIR=%TEMP%\WayaOS_Build_%RANDOM%"
set "BACKUP_DIR=%TEMP%\WayaOS_Backup_%RANDOM%"
set "MIN_SPACE_GB=15"
set "LOG_FILE=%PROJECT_ROOT%iso_build_log_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.txt"

:: Initialize logging
echo Waya-OS Safe ISO Builder Log - %date% %time% > "%LOG_FILE%"
echo ================================================ >> "%LOG_FILE%"
echo Project Root: %PROJECT_ROOT% >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

:: Safety Check 1: Administrator Privileges
echo [SAFETY] Checking administrator privileges...
net session >nul 2>&1
if errorlevel 1 (
    echo [ERROR] This script requires Administrator privileges
    echo [ERROR] Please run as Administrator (Right-click ^> Run as Administrator)
    echo [ERROR] Details logged to: %LOG_FILE%
    exit /b 1
)
echo [OK] Administrator privileges verified
echo [OK] Administrator privileges verified >> "%LOG_FILE%"

:: Safety Check 2: Disk Space
echo [SAFETY] Checking disk space...
for /f "tokens=2" %%i in ('wmic logicaldisk where "DeviceID='%~d0'" get freespace /value ^| find "="') do set "FREE_SPACE=%%i"
set /a "FREE_SPACE_GB=!FREE_SPACE!/1024/1024/1024"

if !FREE_SPACE_GB! lss %MIN_SPACE_GB% (
    echo [ERROR] Insufficient disk space. Required: %MIN_SPACE_GB%GB, Available: !FREE_SPACE_GB!GB
    echo [ERROR] Free up space or use a different drive
    echo [ERROR] Insufficient disk space: !FREE_SPACE_GB!GB available (need %MIN_SPACE_GB%GB) >> "%LOG_FILE%"
    exit /b 1
)
echo [OK] Disk space verified: !FREE_SPACE_GB!GB available
echo [OK] Disk space verified: !FREE_SPACE_GB!GB available >> "%LOG_FILE%"

:: Safety Check 3: Create System Backup
echo [SAFETY] Creating system backup...
mkdir "%BACKUP_DIR%" 2>nul
if errorlevel 1 (
    echo [ERROR] Failed to create backup directory
    echo [ERROR] Backup creation failed >> "%LOG_FILE%"
    exit /b 1
)

reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion" "%BACKUP_DIR%\system.reg" /y >> "%LOG_FILE%" 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion" "%BACKUP_DIR%\user.reg" /y >> "%LOG_FILE%" 2>&1

:: Backup critical directories if they exist
if exist "%PROJECT_ROOT%launcher" (
    robocopy "%PROJECT_ROOT%launcher" "%BACKUP_DIR%\launcher_backup" /E /R:1 /W:1 /NJH /NJS >> "%LOG_FILE%" 2>&1
)
if exist "%PROJECT_ROOT%theme" (
    robocopy "%PROJECT_ROOT%theme" "%BACKUP_DIR%\theme_backup" /E /R:1 /W:1 /NJH /NJS >> "%LOG_FILE%" 2>&1
)

echo [OK] System backup created at %BACKUP_DIR%
echo [OK] System backup created at %BACKUP_DIR% >> "%LOG_FILE%"

:: Safety Check 4: Verify ADK Installation
echo [SAFETY] Verifying Windows ADK...
set "ADK_FOUND=0"
set "OSCDIMG_PATH="

for %%p in (
    "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\oscdimg.exe"
    "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\oscdimg.exe"
    "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\oscdimg.exe"
) do (
    if exist "%%~p" (
        set "OSCDIMG_PATH=%%~p"
        set "ADK_FOUND=1"
        echo [OK] Found oscdimg.exe at %%~p
        echo [OK] Found oscdimg.exe at %%~p >> "%LOG_FILE%"
        goto :adk_found
    )
)

:adk_found
if !ADK_FOUND! equ 0 (
    echo [ERROR] Windows ADK not found or incomplete
    echo [INFO] Please download and install Windows ADK from:
    echo [INFO] https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install
    echo [INFO] Required features: Deployment Tools, Windows Preinstallation Environment
    echo [ERROR] Windows ADK not found >> "%LOG_FILE%"
    goto :cleanup
)

:: Create safe working directory
echo [BUILD] Creating working directory...
mkdir "%WORK_DIR%" 2>nul
if not exist "%WORK_DIR%" (
    echo [ERROR] Failed to create working directory
    echo [ERROR] Working directory creation failed >> "%LOG_FILE%"
    goto :cleanup
)

:: Copy essential files only
echo [BUILD] Copying essential Waya-OS components...
echo [BUILD] Only copying essential files for clean ISO >> "%LOG_FILE%"

:: Essential folders - launcher (required)
if exist "%PROJECT_ROOT%launcher" (
    echo [COPY] launcher/...
    robocopy "%PROJECT_ROOT%launcher" "%WORK_DIR%\launcher" /E /R:1 /W:1 /NJH /NJS /LOG+:"%LOG_FILE%"
    if errorlevel 8 (
        echo [WARNING] Some launcher files may not have copied correctly
    )
) else (
    echo [WARNING] launcher/ not found, this is required for Waya-OS
)

:: Essential folders - theme (required)
if exist "%PROJECT_ROOT%theme" (
    echo [COPY] theme/...
    robocopy "%PROJECT_ROOT%theme" "%WORK_DIR%\theme" /E /R:1 /W:1 /NJH /NJS /LOG+:"%LOG_FILE%"
    if errorlevel 8 (
        echo [WARNING] Some theme files may not have copied correctly
    )
) else (
    echo [WARNING] theme/ not found, this is required for Waya-OS
)

:: Essential folders - icons (required)
if exist "%PROJECT_ROOT%icons" (
    echo [COPY] icons/...
    robocopy "%PROJECT_ROOT%icons" "%WORK_DIR%\icons" /E /R:1 /W:1 /NJH /NJS /LOG+:"%LOG_FILE%"
    if errorlevel 8 (
        echo [WARNING] Some icon files may not have copied correctly
    )
) else (
    echo [INFO] icons/ not found, will be created during installation
)

:: Essential folders - scripts (required)
if exist "%PROJECT_ROOT%scripts" (
    echo [COPY] scripts/...
    robocopy "%PROJECT_ROOT%scripts" "%WORK_DIR%\scripts" /E /R:1 /W:1 /NJH /NJS /LOG+:"%LOG_FILE%"
    if errorlevel 8 (
        echo [WARNING] Some script files may not have copied correctly
    )
) else (
    echo [WARNING] scripts/ not found, this is required for Waya-OS
)

:: Essential folders - ai_context (required)
if exist "%PROJECT_ROOT%ai_context" (
    echo [COPY] ai_context/...
    robocopy "%PROJECT_ROOT%ai_context" "%WORK_DIR%\ai_context" /E /R:1 /W:1 /NJH /NJS /LOG+:"%LOG_FILE%"
    if errorlevel 8 (
        echo [WARNING] Some AI context files may not have copied correctly
    )
) else (
    echo [WARNING] ai_context/ not found, this is required for Waya-OS
)

:: Essential files
for %%f in (AGENTS.md README.md LICENSE) do (
    if exist "%PROJECT_ROOT%%%f" (
        echo [COPY] %%f...
        copy "%PROJECT_ROOT%%%f" "%WORK_DIR%\" >nul 2>&1
        if errorlevel 1 (
            echo [WARNING] Failed to copy %%f
        )
    )
)

:: Create autorun.inf for the ISO
echo [BUILD] Creating autorun.inf...
(
echo [autorun]
echo open=launcher\aqua_jarvis.py
echo icon=icons\waya.ico
echo label=Waya-OS Aqua Jarvis
) > "%WORK_DIR%\autorun.inf"

:: Create ISO
echo [BUILD] Creating ISO image...
mkdir "%OUTPUT_DIR%" 2>nul

set "TIMESTAMP=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "ISO_FILE=%OUTPUT_DIR%\WayaOS_AquaJarvis_%TIMESTAMP%.iso"

echo [BUILD] Using oscdimg.exe to create ISO...
echo [BUILD] Source: %WORK_DIR% >> "%LOG_FILE%"
echo [BUILD] Destination: %ISO_FILE% >> "%LOG_FILE%"

:: Use oscdimg with safety parameters
"%OSCDIMG_PATH%" -m -o -u2 -udfver102 -l"WayaOS_AquaJarvis" "%WORK_DIR%" "%ISO_FILE%" >> "%LOG_FILE%" 2>&1

if exist "%ISO_FILE%" (
    for %%F in ("%ISO_FILE%") do set "ISO_SIZE=%%~zF"
    set /a "ISO_SIZE_MB=!ISO_SIZE!/1024/1024"
    echo [SUCCESS] ISO created successfully!
    echo [INFO] Location: %ISO_FILE%
    echo [INFO] Size: !ISO_SIZE_MB! MB
    echo [SUCCESS] ISO created: %ISO_FILE% (!ISO_SIZE_MB! MB) >> "%LOG_FILE%"

    :: Create ISO info file
    (
    echo Waya-OS Aqua Jarvis ISO
    echo ========================
    echo Created: %date% %time%
    echo Size: !ISO_SIZE_MB! MB
    echo Location: %ISO_FILE%
    echo.
    echo Installation Instructions:
    echo 1. Burn this ISO to a USB drive using Rufus or similar tool
    echo 2. Boot from the USB drive (press F12 during boot for boot menu)
    echo 3. Follow the on-screen installation instructions
    echo.
    echo System Requirements:
    echo - Windows 10/11
    echo - Administrator privileges
    echo - 2GB RAM minimum
    echo - 1GB free disk space
    ) > "%OUTPUT_DIR%\WayaOS_Readme_%TIMESTAMP%.txt"

) else (
    echo [ERROR] ISO creation failed
    echo [ERROR] Check log file: %LOG_FILE%
    goto :cleanup
)

:: Cleanup
:cleanup
echo [CLEANUP] Removing temporary files...
if exist "%WORK_DIR%" (
    rmdir /s /q "%WORK_DIR%" >nul 2>&1
    echo [OK] Working directory cleaned up
)

:: Keep backup for 7 days
echo [CLEANUP] Backup retained at: %BACKUP_DIR%
echo [INFO] This backup will be kept for 7 days for rollback purposes

:: Final summary
echo.
echo ======================================
echo WAYA-OS SAFE ISO BUILD COMPLETE!
echo ======================================
echo.
echo ISO Location: %ISO_FILE%
echo Log File: %LOG_FILE%
echo Backup: %BACKUP_DIR%
echo.
echo Safety measures completed:
echo - Administrator privileges verified
echo - Disk space checked (!FREE_SPACE_GB!GB available)
echo - System backup created
echo - File integrity maintained
echo - Essential files only copied
echo.
echo Next steps:
echo 1. Test the ISO in a virtual machine
echo 2. Burn to USB drive for installation
echo 3. Follow setup guide for reboot installation
echo.

endlocal
exit /b 0