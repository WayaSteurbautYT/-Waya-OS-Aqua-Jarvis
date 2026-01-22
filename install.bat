@echo off
REM Waya-OS: Aqua Jarvis Edition - One-Click Installer
REM This script orchestrates the complete installation process
REM Run as Administrator

title Waya-OS: Aqua Jarvis Edition Installer
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║   Waya-OS: Aqua Jarvis Edition - Installation Wizard       ║
echo ║   AI-Powered Windows Subsystem for NVIDIA GPUs             ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Check for Admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: You must run this installer as Administrator!
    echo Right-click install.bat and select "Run as administrator"
    pause
    exit /b 1
)

REM Get current directory
setlocal enabledelayedexpansion
set "INSTALL_DIR=%CD%"
set "LOG_FILE=%INSTALL_DIR%\install.log"

echo [%date% %time%] Installation started >> "%LOG_FILE%"

REM Step 1: Backup System
echo.
echo [1/6] Creating system backup...
echo This ensures safe rollback if needed.
set /p BACKUP_DRIVE="Enter backup drive letter (e.g., E:): "

if not exist "%BACKUP_DRIVE%\" (
    echo ERROR: Drive %BACKUP_DRIVE% not found!
    pause
    exit /b 1
)

echo Creating backup directory...
md "%BACKUP_DRIVE%\Waya-OS-Backup" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%INSTALL_DIR%\scripts\backup\backup_system.ps1' -BackupPath '%BACKUP_DRIVE%\Waya-OS-Backup'" >> "%LOG_FILE%"

if %errorLevel% equ 0 (
    echo [OK] System backup created at %BACKUP_DRIVE%\Waya-OS-Backup
) else (
    echo [WARNING] Backup encountered issues. Continuing anyway...
)

REM Step 2: Install Theme
echo.
echo [2/6] Installing Waya-OS theme...
echo Applying wallpapers, colors, icons...

if exist "%INSTALL_DIR%\theme\WayaOS_AquaJarvis.deskthemepack" (
    start "" "%INSTALL_DIR%\theme\WayaOS_AquaJarvis.deskthemepack"
    timeout /t 5 /nobreak
    echo [OK] Theme installer launched. Please confirm in Windows Personalization.
) else (
    echo [WARNING] Theme file not found. Skipping.
)

REM Step 3: Apply Icons (PowerShell)
echo [3/6] Configuring system icons...
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%INSTALL_DIR%\theme\apply_icons.ps1'" >> "%LOG_FILE%"

if %errorLevel% equ 0 (
    echo [OK] Icons applied
) else (
    echo [WARNING] Icon application had issues. You can apply manually later.
)

REM Step 4: Install Launcher
echo.
echo [4/6] Installing Aqua Jarvis launcher...

if exist "%INSTALL_DIR%\launcher\requirements.txt" (
    echo Checking Python installation...
    python --version >nul 2>&1
    
    if %errorLevel% neq 0 (
        echo Python not found. Would you like to install Python 3.11? (Y/N)
        set /p INSTALL_PYTHON="Enter choice: "
        if /i "!INSTALL_PYTHON!"=="Y" (
            echo Installing Python via winget...
            winget install Python.Python.3.11 -e --accept-source-agreements --accept-package-agreements
        )
    )
    
    echo Installing launcher dependencies...
    cd "%INSTALL_DIR%\launcher"
    pip install -r requirements.txt >> "%LOG_FILE%"
    cd "%INSTALL_DIR%"
    
    if %errorLevel% equ 0 (
        echo [OK] Launcher dependencies installed
    ) else (
        echo [WARNING] Launcher installation incomplete. You may need to run manually.
    )
) else (
    echo [WARNING] Launcher files not found.
)

REM Step 5: GPU Optimization (Optional)
echo.
echo [5/6] NVIDIA GPU Optimization (Optional)
echo Do you have an NVIDIA GPU and want to install CUDA drivers? (Y/N)
set /p INSTALL_CUDA="Enter choice: "

if /i "!INSTALL_CUDA!"=="Y" (
    echo Installing NVIDIA drivers and CUDA toolkit...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%INSTALL_DIR%\scripts\gpu_optimization\install_cuda.ps1'" >> "%LOG_FILE%"
    
    if %errorLevel% equ 0 (
        echo [OK] GPU optimization complete
    ) else (
        echo [WARNING] GPU installation had issues. Install manually if needed.
    )
)

REM Step 6: AI Context Setup
echo.
echo [6/6] Configuring AI context for coding assistant...

if exist "%INSTALL_DIR%\ai_context\prompt_engine.py" (
    echo Do you have ChatGPT conversation data to import? (Y/N)
    set /p IMPORT_CHAT="Enter choice: "
    
    if /i "!IMPORT_CHAT!"=="Y" (
        set /p CHAT_FILE="Enter full path to conversations.json: "
        if exist "!CHAT_FILE!" (
            copy "!CHAT_FILE!" "%INSTALL_DIR%\ai_context\conversations.json" >nul
            echo Generating AI prompt context...
            python "%INSTALL_DIR%\ai_context\prompt_engine.py" --init >> "%LOG_FILE%"
            echo [OK] Chat data imported and AI context generated
        ) else (
            echo [WARNING] File not found. Skipping.
        )
    )
) else (
    echo [WARNING] AI context files not found.
)

REM Create Launcher Shortcut
echo.
echo Creating desktop shortcut for Aqua Jarvis...
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%INSTALL_DIR%\scripts\create_launcher_shortcut.ps1'" >> "%LOG_FILE%"

REM Final steps
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║   Installation Complete!                                   ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo Next steps:
echo 1. Restart your computer (recommended) to apply all changes
echo 2. Look for "Aqua Jarvis" shortcut on your desktop
echo 3. Double-click to launch your personalized AI workspace
echo 4. Open VS Code for coding with your personal AI assistant
echo.
echo For detailed configuration, see INSTALL.md
echo Backup location: %BACKUP_DRIVE%\Waya-OS-Backup
echo Installation log: %LOG_FILE%
echo.
echo Welcome to Waya-OS: Aqua Jarvis Edition!
echo.

pause
exit /b 0
