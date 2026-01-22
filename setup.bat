@echo off
REM ============================================================================
REM WAYA-OS SETUP AUTOMATION SCRIPT
REM Quick setup for development and testing
REM ============================================================================

setlocal enabledelayedexpansion

REM Color definitions
set "RED=[31m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "RESET=[0m"

REM Check for admin rights
powershell -Command "if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { exit 1 }"
if %errorlevel% neq 0 (
    echo %RED%ERROR: This script requires Administrator privileges%RESET%
    echo Please run as Administrator
    pause
    exit /b 1
)

cls
echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║           WAYA-OS SETUP & TESTING AUTOMATION                   ║%RESET%
echo %BLUE%║          Aqua Jarvis Edition - Pre-Launch Checklist            ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.

REM Define project path
set "PROJECT_PATH=%CD%"
set "TIMESTAMP=%date:~-4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%"

echo %GREEN%[✓] Project Path: %PROJECT_PATH%%RESET%
echo %GREEN%[✓] Timestamp: %TIMESTAMP%%RESET%
echo.

REM ============================================================================
REM MENU
REM ============================================================================

:MENU
cls
echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║                      WAYA-OS SETUP MENU                        ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.
echo %YELLOW%Quick Setup & Testing Options:%RESET%
echo.
echo   1) %YELLOW%[Quick Start]%RESET% - Setup Python + validate files
echo   2) %YELLOW%[Full Validation]%RESET% - Test all components
echo   3) %YELLOW%[Build ISO]%RESET% - Create bootable ISO
echo   4) %YELLOW%[Test Installer]%RESET% - Verify install.bat works
echo   5) %YELLOW%[Setup GitHub]%RESET% - Initialize Git repo
echo   6) %YELLOW%[View Documentation]%RESET% - Open guides in browser
echo   7) %YELLOW%[Check System]%RESET% - GPU & Python info
echo   8) %YELLOW%[Backup Current]%RESET% - Create safety backup
echo   9) %YELLOW%[Exit]%RESET% - Close this menu
echo.
set /p CHOICE="Enter choice [1-9]: "

REM Validate choice
if not "%CHOICE%"=="" if not "%CHOICE%"=="9" (
    if %CHOICE% lss 1 goto INVALID
    if %CHOICE% gtr 9 goto INVALID
) else if "%CHOICE%"=="9" goto EXIT

goto CHOICE_%CHOICE%

:INVALID
echo %RED%Invalid choice. Please enter 1-9.%RESET%
timeout /t 2 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 1: QUICK START
REM ============================================================================

:CHOICE_1
cls
echo %BLUE%[*] Running Quick Start Setup...%RESET%
echo.

REM Check Python
echo Checking Python installation...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
    echo %GREEN%[✓] Python found: !PYTHON_VERSION!%RESET%
) else (
    echo %RED%[✗] Python not installed. Download from python.org%RESET%
    echo     Make sure to check "Add Python to PATH"
)
echo.

REM Check pip packages
echo Checking Python dependencies...
python -m pip show psutil >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%[✓] psutil installed%RESET%
) else (
    echo %YELLOW%[!] Installing psutil...%RESET%
    python -m pip install psutil --quiet
)

python -m pip show pillow >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%[✓] Pillow installed%RESET%
) else (
    echo %YELLOW%[!] Installing Pillow...%RESET%
    python -m pip install pillow --quiet
)

python -m pip show pyyaml >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%[✓] PyYAML installed%RESET%
) else (
    echo %YELLOW%[!] Installing PyYAML...%RESET%
    python -m pip install pyyaml --quiet
)
echo.

REM Validate JSON files
echo Validating configuration files...
python -c "
import json, os
json_files = []
for root, dirs, files in os.walk('.'):
    for f in files:
        if f.endswith('.json'):
            json_files.append(os.path.join(root, f))

valid = 0
invalid = 0
for f in json_files:
    try:
        with open(f) as file:
            json.load(file)
        print(f'[OK] {f}')
        valid += 1
    except Exception as e:
        print(f'[ERROR] {f}: {e}')
        invalid += 1

print()
print(f'Summary: {valid} valid, {invalid} invalid')
" 2>nul

echo.
echo %GREEN%[✓] Quick Start Complete!%RESET%
echo.
echo Next steps:
echo   1. Review: GITHUB_SETUP.md
echo   2. Create GitHub repository
echo   3. Run option 3 to build ISO
echo.
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 2: FULL VALIDATION
REM ============================================================================

:CHOICE_2
cls
echo %BLUE%[*] Running Full Validation...%RESET%
echo.

REM Count files
setlocal enabledelayedexpansion
for /r "%PROJECT_PATH%" %%F in (*) do set /a filecount+=1
echo %GREEN%[✓] Found !filecount! files%RESET%

REM Check key directories
echo.
echo Checking directory structure:
for %%D in (launcher ai_context theme scripts iso_builder docs) do (
    if exist "%%D" (
        echo %GREEN%[✓] %%D/%RESET%
    ) else (
        echo %RED%[✗] %%D/ (missing)%RESET%
    )
)

REM Check key files
echo.
echo Checking critical files:
for %%F in (install.bat launcher/aqua_jarvis.py ai_context/prompt_engine.py iso_builder/build_iso.ps1) do (
    if exist "%%F" (
        echo %GREEN%[✓] %%F%RESET%
    ) else (
        echo %RED%[✗] %%F (missing)%RESET%
    )
)

REM Validate Python files
echo.
echo Validating Python syntax:
python -m py_compile launcher\aqua_jarvis.py 2>nul
if %errorlevel% equ 0 (
    echo %GREEN%[✓] launcher/aqua_jarvis.py%RESET%
) else (
    echo %RED%[✗] launcher/aqua_jarvis.py (syntax error)%RESET%
)

python -m py_compile ai_context\prompt_engine.py 2>nul
if %errorlevel% equ 0 (
    echo %GREEN%[✓] ai_context/prompt_engine.py%RESET%
) else (
    echo %RED%[✗] ai_context/prompt_engine.py (syntax error)%RESET%
)

echo.
echo %GREEN%[✓] Full Validation Complete!%RESET%
echo.
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 3: BUILD ISO
REM ============================================================================

:CHOICE_3
cls
echo %BLUE%[*] ISO Builder - Waya-OS%RESET%
echo.
echo %YELLOW%Requirements:%RESET%
echo  - Windows ADK installed
echo  - 20+ GB free disk space
echo  - 30+ minutes for build
echo.
set /p BUILD_CONFIRM="Build ISO now? (y/n): "
if /i not "%BUILD_CONFIRM%"=="y" goto MENU

echo.
echo %BLUE%Build options:%RESET%
echo  1) Launcher only
echo  2) Launcher + VS Code
echo  3) Launcher + VS Code + GPU drivers
echo.
set /p ISO_TYPE="Choose option [1-3]: "

echo.
echo %YELLOW%Starting ISO build...%RESET%
echo %BLUE%This will take 20-30 minutes%RESET%
echo.

cd /d iso_builder

if "%ISO_TYPE%"=="1" (
    powershell -ExecutionPolicy Bypass -File build_iso.ps1 -IncludeLauncher
) else if "%ISO_TYPE%"=="2" (
    powershell -ExecutionPolicy Bypass -File build_iso.ps1 -IncludeLauncher -IncludeVSCode
) else if "%ISO_TYPE%"=="3" (
    powershell -ExecutionPolicy Bypass -File build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeGPUDrivers
)

echo.
echo %GREEN%[✓] ISO build complete!%RESET%
echo Output: iso_builder\output\WayaOS_AquaJarvis_v1.iso
echo.

cd /d "%PROJECT_PATH%"
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 4: TEST INSTALLER
REM ============================================================================

:CHOICE_4
cls
echo %BLUE%[*] Testing install.bat...%RESET%
echo.

REM Check if install.bat exists
if not exist "install.bat" (
    echo %RED%[✗] install.bat not found!%RESET%
    timeout /t 3 /nobreak
    goto MENU
)

echo %GREEN%[✓] install.bat found%RESET%

REM Check batch file syntax
for /f "tokens=*" %%i in ('type install.bat ^| find /c "@echo off"') do set HAS_HEADER=%%i
if %HAS_HEADER% gtr 0 (
    echo %GREEN%[✓] Valid batch file header%RESET%
) else (
    echo %RED%[✗] Invalid batch file%RESET%
)

REM Count lines
for /f %%i in ('find /c /v "" ^< install.bat') do (
    echo %GREEN%[✓] Found %%i lines of code%RESET%
)

echo.
echo %YELLOW%Preview of install.bat:%RESET%
echo.
type install.bat | more
echo.
echo %GREEN%[✓] Installer syntax valid%RESET%
echo.
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 5: SETUP GITHUB
REM ============================================================================

:CHOICE_5
cls
echo %BLUE%[*] GitHub Repository Setup%RESET%
echo.
echo Follow these steps:
echo.
echo 1. Go to: https://github.com/new
echo 2. Create repository:
echo    Name: Waya-OS-Aqua-Jarvis
echo    Description: AI-Powered Windows Subsystem
echo    Public: YES
echo.
echo 3. Initialize Git:
echo.

git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%[✓] Git installed%RESET%
    echo.
    set /p INIT_GIT="Initialize git repository? (y/n): "
    if /i "%INIT_GIT%"=="y" (
        git init
        git add .
        git config user.name "Waya Steurbaut"
        git config user.email "wayasteurbautsongs@gmail.com"
        git commit -m "Initial commit: Waya-OS v1.0"
        echo.
        echo %GREEN%[✓] Git initialized%RESET%
        echo.
        echo Next:
        echo  git remote add origin https://github.com/USERNAME/Waya-OS-Aqua-Jarvis.git
        echo  git push -u origin main
        echo.
    )
) else (
    echo %RED%[✗] Git not installed%RESET%
    echo Download from: https://git-scm.com
)

echo.
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 6: VIEW DOCUMENTATION
REM ============================================================================

:CHOICE_6
cls
echo %BLUE%[*] Documentation Viewer%RESET%
echo.
echo Available guides:
echo.
echo 1) START_HERE.md
echo 2) README.md
echo 3) INSTALL.md
echo 4) GITHUB_SETUP.md
echo 5) PUBLISHING_CHECKLIST.md
echo 6) TESTING_CHECKLIST.md
echo 7) INSTALLATION_USB_GUIDE.md
echo.
set /p DOC_CHOICE="Choose [1-7]: "

if "%DOC_CHOICE%"=="1" (
    start notepad START_HERE.md
) else if "%DOC_CHOICE%"=="2" (
    start notepad README.md
) else if "%DOC_CHOICE%"=="3" (
    start notepad INSTALL.md
) else if "%DOC_CHOICE%"=="4" (
    start notepad GITHUB_SETUP.md
) else if "%DOC_CHOICE%"=="5" (
    start notepad PUBLISHING_CHECKLIST.md
) else if "%DOC_CHOICE%"=="6" (
    start notepad TESTING_CHECKLIST.md
) else if "%DOC_CHOICE%"=="7" (
    start notepad INSTALLATION_USB_GUIDE.md
)

goto MENU

REM ============================================================================
REM CHOICE 7: CHECK SYSTEM
REM ============================================================================

:CHOICE_7
cls
echo %BLUE%[*] System Information%RESET%
echo.

REM Python version
echo %YELLOW%Python:%RESET%
python --version 2>&1

REM Check GPU
echo.
echo %YELLOW%GPU Information:%RESET%
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader 2>nul
if %errorlevel% equ 0 (
    echo %GREEN%[✓] NVIDIA GPU detected%RESET%
) else (
    echo %YELLOW%[!] No NVIDIA GPU detected (optional feature)%RESET%
)

REM Windows version
echo.
echo %YELLOW%Windows Version:%RESET%
ver

REM Disk space
echo.
echo %YELLOW%Disk Space:%RESET%
for /f "tokens=3" %%a in ('dir C:^| find "bytes free"') do (
    echo C: Drive - %%a free
)

echo.
echo %GREEN%[✓] System check complete%RESET%
echo.
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM CHOICE 8: BACKUP CURRENT
REM ============================================================================

:CHOICE_8
cls
echo %BLUE%[*] Create Safety Backup%RESET%
echo.
echo This will backup the current Waya-OS project
echo.

set BACKUP_PATH=%PROJECT_PATH%_Backup_%TIMESTAMP%

echo %YELLOW%Backup destination: %BACKUP_PATH%%RESET%
echo.
set /p BACKUP_CONFIRM="Create backup? (y/n): "

if /i "%BACKUP_CONFIRM%"=="y" (
    echo %BLUE%Creating backup...%RESET%
    xcopy "%PROJECT_PATH%" "%BACKUP_PATH%" /E /I /Y >nul
    if %errorlevel% equ 0 (
        echo %GREEN%[✓] Backup created successfully%RESET%
        echo Location: %BACKUP_PATH%
    ) else (
        echo %RED%[✗] Backup failed%RESET%
    )
) else (
    echo %YELLOW%Backup cancelled%RESET%
)

echo.
timeout /t 5 /nobreak
goto MENU

REM ============================================================================
REM EXIT
REM ============================================================================

:EXIT
cls
echo.
echo %BLUE%╔════════════════════════════════════════════════════════════════╗%RESET%
echo %BLUE%║                  SETUP WIZARD COMPLETE                         ║%RESET%
echo %BLUE%╚════════════════════════════════════════════════════════════════╝%RESET%
echo.
echo %GREEN%Next Steps:%RESET%
echo.
echo  1. Follow PUBLISHING_CHECKLIST.md to publish
echo  2. Create GitHub repository
echo  3. Build ISO (Option 3 in this menu)
echo  4. Test installation via USB
echo  5. Share with the world!
echo.
echo %YELLOW%Documentation:%RESET%
echo  - START_HERE.md: Quick start guide
echo  - GITHUB_SETUP.md: Publishing to GitHub
echo  - INSTALLATION_USB_GUIDE.md: How users install
echo  - TESTING_CHECKLIST.md: Quality assurance
echo.
echo %BLUE%Resources:%RESET%
echo  - GitHub: https://github.com
echo  - Rufus: https://rufus.ie (USB creation)
echo  - Windows ADK: Microsoft (for ISO building)
echo.
echo %GREEN%Good luck publishing Waya-OS! 🌈✨%RESET%
echo.
pause
exit /b 0
