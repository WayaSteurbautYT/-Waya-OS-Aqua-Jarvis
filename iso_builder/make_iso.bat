@echo off
REM Create a bootable ISO structure

set "OUTPUT=C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\iso_builder\output"
set "WORK=%OUTPUT%\iso_content"

echo Creating ISO content structure...
if exist "%WORK%" rmdir /s /q "%WORK%"
mkdir "%WORK%"

REM Copy project files
echo Copying files...
xcopy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\pages" "%WORK%\pages" /E /Y >nul 2>&1
xcopy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\theme" "%WORK%\theme" /E /Y >nul 2>&1
xcopy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\icons" "%WORK%\icons" /E /Y >nul 2>&1
xcopy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\launcher" "%WORK%\launcher" /E /Y >nul 2>&1
xcopy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\ai_context" "%WORK%\ai_context" /E /Y >nul 2>&1
xcopy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\scripts" "%WORK%\scripts" /E /Y >nul 2>&1

copy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\package.json" "%WORK%\" >nul 2>&1
copy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\README.md" "%WORK%\" >nul 2>&1
copy "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\LICENSE" "%WORK%\" >nul 2>&1

REM Create a simple autorun
echo [autorun] > "%WORK%\autorun.inf"
echo label=Waya-OS >> "%WORK%\autorun.inf"
echo icon=launcher\aqua_jarvis.ico >> "%WORK%\autorun.inf"

echo Files prepared in: %WORK%

REM Now we need PowerShell to create the actual ISO
powershell -NoProfile -Command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory('%WORK%', '%OUTPUT%\Waya-OS-temp.zip', 'Optimal', $true)}"

echo.
echo ISO content ready for VirtualBox
echo Location: %OUTPUT%
dir "%OUTPUT%"
