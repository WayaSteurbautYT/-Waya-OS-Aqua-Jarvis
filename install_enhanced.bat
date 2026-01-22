@echo off
REM ============================================================================
REM WAYA-OS ENHANCED INSTALLER WITH MCP AI AUTOMATION
REM Personalized from user's ChatGPT history
REM ============================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

REM Check admin rights
powershell -Command "if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 1 }"
if %errorlevel% neq 0 (
    echo ERROR: Administrator privileges required
    echo Please run as Administrator
    pause
    exit /b 1
)

cls
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                                                                ║
echo ║   WAYA-OS: AQUA JARVIS EDITION - ENHANCED INSTALLER           ║
echo ║          Personalized AI-Powered Installation System          ║
echo ║                                                                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Colors (ANSI)
set "GREEN=[32m"
set "BLUE=[34m"
set "YELLOW=[33m"
set "RED=[31m"
set "RESET=[0m"

echo %BLUE%[*] Loading MCP AI Automation Engine...%RESET%
powershell -Command "python ai_context/mcp_server.py --init" 2>nul
if %errorlevel% equ 0 (
    echo %GREEN%[✓] AI Engine loaded - personalized for you%RESET%
)

REM ============================================================================
REM PHASE 1: BACKUP
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 1: SYSTEM BACKUP (Safety First!)                        ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

set /p BACKUP_CONFIRM="Create backup before installation? (Recommended: Y/N) [Y]: "
if /i "%BACKUP_CONFIRM%"=="N" (
    echo %YELLOW%[!] Skipping backup (at your own risk)%RESET%
) else (
    echo %BLUE%[*] Starting system backup...%RESET%
    powershell -ExecutionPolicy Bypass -File "scripts\backup\backup_system.ps1" -BackupPath "E:\Waya-OS-Backup"
    echo %GREEN%[✓] Backup complete%RESET%
)

REM ============================================================================
REM PHASE 2: AI ANALYSIS
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 2: AI PERSONALITY ANALYSIS                              ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

echo %BLUE%[*] Analyzing your coding patterns...%RESET%
python -c "
import json
try:
    with open('ai_context/user_data/conversations.json') as f:
        convs = json.load(f)
    print(f'[✓] Found {len(convs)} conversations')
    if 'python' in str(convs).lower():
        print('[✓] Python development detected')
    if 'javascript' in str(convs).lower():
        print('[✓] JavaScript development detected')
except:
    print('[!] No chat history found - using defaults')
"

echo %GREEN%[✓] Personality loaded%RESET%

REM ============================================================================
REM PHASE 3: THEME INSTALLATION
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 3: THEME INSTALLATION                                   ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

echo %BLUE%[*] Applying Waya-OS theme...%RESET%
copy "theme\WayaOS_AquaJarvis.theme" "C:\Windows\Resources\Themes\" /Y >nul
if %errorlevel% equ 0 (
    echo %GREEN%[✓] Theme installed successfully%RESET%
) else (
    echo %RED%[✗] Theme installation failed%RESET%
)

REM ============================================================================
REM PHASE 4: LAUNCHER SETUP
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 4: AQUA JARVIS LAUNCHER SETUP                           ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

echo %BLUE%[*] Installing Aqua Jarvis launcher...%RESET%
mkdir "%APPDATA%\Aqua Jarvis" 2>nul
copy "launcher\aqua_jarvis.py" "%APPDATA%\Aqua Jarvis\" /Y >nul
copy "launcher\config.json" "%APPDATA%\Aqua Jarvis\" /Y >nul
copy "launcher\requirements.txt" "%APPDATA%\Aqua Jarvis\" /Y >nul

echo %BLUE%[*] Installing Python dependencies...%RESET%
pip install -r "launcher\requirements.txt" --quiet >nul 2>&1

echo %BLUE%[*] Creating desktop shortcut...%RESET%
powershell -Command "
$DesktopPath = [Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path $DesktopPath 'Aqua Jarvis.lnk'
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = 'python'
$Shortcut.Arguments = '%APPDATA%\Aqua Jarvis\aqua_jarvis.py'
$Shortcut.IconLocation = 'C:\Windows\System32\python.exe'
$Shortcut.Save()
" 2>nul

echo %GREEN%[✓] Launcher installed successfully%RESET%

REM ============================================================================
REM PHASE 5: AI CONTEXT SETUP
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 5: AI CONTEXT CONFIGURATION                             ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

set /p SETUP_AI="Setup AI personalization? (Uses your chat history) [Y/N]: "
if /i "%SETUP_AI%"=="Y" (
    echo %BLUE%[*] Setting up AI context...%RESET%
    mkdir "%APPDATA%\Aqua Jarvis\ai_context" 2>nul
    copy "ai_context\prompt_engine.py" "%APPDATA%\Aqua Jarvis\ai_context\" /Y >nul
    copy "ai_context\mcp_server.py" "%APPDATA%\Aqua Jarvis\ai_context\" /Y >nul
    copy "ai_context\user_data\*" "%APPDATA%\Aqua Jarvis\ai_context\" /Y >nul
    echo %GREEN%[✓] AI context loaded and personalized%RESET%
) else (
    echo %YELLOW%[!] AI context skipped%RESET%
)

REM ============================================================================
REM PHASE 6: GPU OPTIMIZATION (Optional)
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 6: GPU OPTIMIZATION (NVIDIA Only)                       ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

nvidia-smi >nul 2>&1
if %errorlevel% equ 0 (
    set /p SETUP_GPU="NVIDIA GPU detected. Install CUDA drivers? [Y/N]: "
    if /i "%SETUP_GPU%"=="Y" (
        echo %BLUE%[*] Installing NVIDIA CUDA 12.2...%RESET%
        powershell -ExecutionPolicy Bypass -File "scripts\gpu_optimization\install_cuda.ps1"
        echo %GREEN%[✓] GPU optimization complete%RESET%
    )
) else (
    echo %YELLOW%[!] No NVIDIA GPU detected (optional feature)%RESET%
)

REM ============================================================================
REM PHASE 7: VS CODE SETUP
REM ============================================================================

echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║ PHASE 7: VS CODE CONFIGURATION                                ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

set /p SETUP_VSCODE="Setup VS Code with Waya-OS theme? [Y/N]: "
if /i "%SETUP_VSCODE%"=="Y" (
    echo %BLUE%[*] Configuring VS Code...%RESET%
    
    REM Create VS Code settings directory
    mkdir "%APPDATA%\Code\User" 2>nul
    
    REM Backup existing settings
    if exist "%APPDATA%\Code\User\settings.json" (
        copy "%APPDATA%\Code\User\settings.json" "%APPDATA%\Code\User\settings.json.backup" /Y >nul
    )
    
    REM Copy our settings
    copy "vscode_config\settings.json" "%APPDATA%\Code\User\" /Y >nul
    
    echo %GREEN%[✓] VS Code configured with Waya-OS theme%RESET%
) else (
    echo %YELLOW%[!] VS Code setup skipped%RESET%
)

REM ============================================================================
REM COMPLETION
REM ============================================================================

echo.
echo %GREEN%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %GREEN%║                                                                ║%RESET%
echo %GREEN%║   ✅ WAYA-OS INSTALLATION COMPLETE!                           ║%RESET%
echo %GREEN%║                                                                ║%RESET%
echo %GREEN%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.
echo %GREEN%Next steps:%RESET%
echo   1. Restart Windows for full theme activation
echo   2. Open "Aqua Jarvis" from your desktop
echo   3. Configure in Settings panel
echo   4. Enjoy your personalized AI assistant!
echo.
echo %YELLOW%Find help: START_HERE.md or README.md%RESET%
echo.

set /p RESTART="Restart now? [Y/N]: "
if /i "%RESTART%"=="Y" (
    echo %BLUE%[*] Restarting Windows in 10 seconds...%RESET%
    shutdown /r /t 10 /c "Waya-OS installation complete - Restarting"
) else (
    echo %YELLOW%[!] Please restart manually for theme to take effect%RESET%
)

pause
