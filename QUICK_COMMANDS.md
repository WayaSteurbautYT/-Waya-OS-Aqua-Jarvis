# QUICK_COMMANDS.md - Fast Reference for All Commands

## 🚀 Everything You Need in One File

Quick copy-paste commands for common tasks.

---

## 📦 SETUP & PREPARATION

### Verify Project Structure
```powershell
# Check all files exist
Get-ChildItem "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis" -Recurse | 
  Measure-Object | 
  Select-Object -ExpandProperty Count

# Should show: 38+ files
```

### Install Python Dependencies
```powershell
# Quick install
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"
python -m pip install psutil pillow pyyaml --upgrade

# Verify installed
pip list | findstr "psutil pillow pyyaml"
```

### Check GPU (NVIDIA)
```powershell
# Check GPU present
nvidia-smi

# Expected output: GPU info with VRAM
# If error: GPU not installed or drivers missing
```

---

## 🧪 TESTING COMMANDS

### Validate Python Syntax
```powershell
# Test launcher
python -m py_compile launcher\aqua_jarvis.py

# Test AI engine
python -m py_compile ai_context\prompt_engine.py

# If no output: Syntax OK ✓
```

### Test JSON Files
```powershell
# Validate config.json
python -c "
import json
with open('launcher\config.json') as f:
    json.load(f)
print('Config JSON valid!')
"
```

### Preview Launcher
```powershell
# (Won't open GUI in terminal, just loads)
cd launcher
python -m aqua_jarvis --verify-only
cd ..
```

---

## 📀 ISO BUILDING

### Build ISO (All Features)
```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Full build with everything
.\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeGPUDrivers

# Duration: ~30 minutes
# Output: iso_builder\output\WayaOS_AquaJarvis_v1.iso
```

### Build ISO (Minimal)
```powershell
# Just launcher, faster
.\iso_builder\build_iso.ps1 -IncludeLauncher

# Duration: ~15 minutes
# Output: iso_builder\output\WayaOS_AquaJarvis_v1.iso (3-4 GB)
```

### Verify ISO Created
```powershell
# Check file exists and size
Get-Item "iso_builder\output\WayaOS_AquaJarvis_v1.iso" | 
  Select-Object Name, @{N="Size(GB)";E={[math]::Round($_.Length/1GB,2)}}

# Expected size: 4-6 GB
```

### Create Hash for Distribution
```powershell
# Generate SHA256 hash for verification
certutil -hashfile "iso_builder\output\WayaOS_AquaJarvis_v1.iso" SHA256

# Users can verify downloaded ISO matches
```

---

## 🐙 GIT & GITHUB COMMANDS

### Initialize Repository
```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

git init
git config user.name "Waya Steurbaut"
git config user.email "wayasteurbautsongs@gmail.com"
git add .
git commit -m "Initial commit: Waya-OS v1.0 - Aqua Jarvis Edition"
```

### Add Remote & Push
```powershell
# Replace USERNAME with your GitHub username
git remote add origin https://github.com/USERNAME/Waya-OS-Aqua-Jarvis.git
git branch -M main
git push -u origin main

# All files uploaded to GitHub!
```

### Tag Release
```powershell
# Create version tag
git tag -a v1.0.0 -m "Initial release: Waya-OS v1.0"
git push origin v1.0.0

# Now create release on GitHub website
```

### Check Git Status
```powershell
git status
git log --oneline -5

# Verify all changes committed
```

---

## 🌐 GITHUB PAGES (Website)

### Enable GitHub Pages
```
1. Go to: https://github.com/USERNAME/Waya-OS-Aqua-Jarvis/settings
2. Scroll down to "GitHub Pages"
3. Source: Deploy from a branch
4. Branch: main
5. Folder: / (root)
6. Save

Website URL: https://USERNAME.github.io/Waya-OS-Aqua-Jarvis/
```

### Test Website Locally
```powershell
# Serve index.html locally
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Python 3+
python -m http.server 8000

# Then visit: http://localhost:8000/index.html
```

---

## 💾 BACKUP COMMANDS

### Create System Backup
```powershell
# Full backup before testing
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

.\scripts\backup\backup_system.ps1 -BackupPath "E:\Backups\Waya-OS"

# (Replace E: with your backup drive)
# Creates 100GB+ backup with full restore capability
```

### Restore from Backup
```powershell
# If something goes wrong
.\scripts\restore\restore_system.ps1 -BackupPath "E:\Backups\Waya-OS"

# Restores entire system to pre-Waya-OS state
```

---

## 🎯 USB INSTALLATION

### Create Bootable USB (Windows)
```
1. Download Rufus: https://rufus.ie
2. Open Rufus
3. Device: Select your USB (8GB+)
4. Boot selection: Select ISO file
   Path: C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\iso_builder\output\WayaOS_AquaJarvis_v1.iso
5. Partition type: GPT
6. File system: NTFS
7. Volume label: WAYAOS
8. Start
9. Wait for completion (5-10 min)
```

### Create Bootable USB (Linux/Mac)
```bash
# Linux
sudo dd if=WayaOS_AquaJarvis_v1.iso of=/dev/sdX bs=4M status=progress

# Mac
sudo dd if=WayaOS_AquaJarvis_v1.iso of=/dev/diskX bs=4m
diskutil eject /dev/diskX

# (Replace X with your USB device letter)
```

### Boot from USB
```
1. Insert USB into computer
2. Restart computer
3. Press: Del, F2, F10, or F12 (depends on brand)
4. Select Boot tab
5. Change boot order to USB first
6. Save & Exit
7. Windows installer appears from USB
```

---

## 📱 INSTALLER EXECUTION

### Run Installer (Standard)
```cmd
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"
install.bat

# Interactive prompts will guide you through:
# 1. Backup creation
# 2. Theme installation
# 3. Launcher setup
# 4. GPU drivers (optional)
```

### Run Installer (No GPU)
```cmd
# If you don't have NVIDIA GPU
install.bat
# Choose "N" when asked about GPU drivers
```

### Run Installer (Quiet Mode - Advanced)
```cmd
# Minimal output, headless installation
install.bat --quiet

# Not recommended for first run
```

---

## 🔍 VERIFICATION COMMANDS

### Verify Theme Installed
```powershell
# Check theme file in Windows directory
Test-Path "C:\Windows\Resources\Themes\WayaOS_AquaJarvis.theme"

# Should return: True
```

### Verify Launcher Installed
```powershell
# Check launcher location
Test-Path "C:\Users\$env:USERNAME\AppData\Local\Aqua Jarvis\launcher.py"

# Should return: True

# Test launch
python "C:\Users\$env:USERNAME\AppData\Local\Aqua Jarvis\launcher.py"
```

### Verify AI Engine
```powershell
# Check AI context folder
Test-Path "C:\Users\$env:USERNAME\AppData\Local\Aqua Jarvis\prompt_engine.py"

# Test import
python -c "from prompt_engine import generate_prompt; print('AI ready!')"
```

### Check System Monitoring
```powershell
# Verify GPU detection (if NVIDIA)
nvidia-smi

# Verify CPU/RAM monitoring
Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 1

# Verify disk space
Get-PSDrive C | Select-Object Name, Used, Free
```

---

## 📊 DIAGNOSTICS

### Get Full System Info
```powershell
# CPU
Get-WmiObject Win32_Processor | Select-Object Name, Cores, Threads

# RAM
Get-WmiObject Win32_ComputerSystem | Select-Object TotalPhysicalMemory

# GPU
Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM

# Windows Version
[System.Environment]::OSVersion.VersionString
```

### Check Error Logs
```powershell
# View setup logs
Get-Content "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\install.log"

# View recent errors
Get-WinEvent -LogName System -MaxEvents 50 | Where-Object {$_.LevelDisplayName -eq "Error"}

# View Python errors
python -m pdb launcher\aqua_jarvis.py
```

### Monitor System During Install
```powershell
# Real-time CPU/RAM
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10

# Real-time GPU (if NVIDIA)
nvidia-smi --query-gpu=timestamp,name,utilization.gpu,utilization.memory,memory.used,memory.free --format=csv -l 1

# Real-time disk activity
diskperf -y
```

---

## 🌐 PUBLISHING SHORTCUTS

### Upload to GitHub via Web
```
1. Go: github.com/USERNAME/Waya-OS-Aqua-Jarvis
2. Click: Add file → Upload files
3. Drag & drop all files
4. Commit with message
5. Done!
```

### Create Release on GitHub
```powershell
# Via command line (requires GitHub CLI)
gh release create v1.0.0 \
  --title "Waya-OS v1.0.0 - Initial Release" \
  --notes "First public release of Waya-OS" \
  --draft false

# Then upload ISO file manually on GitHub website
```

### Share Download Link
```
Direct ISO:
https://github.com/USERNAME/Waya-OS-Aqua-Jarvis/releases/download/v1.0.0/WayaOS_AquaJarvis_v1.iso

Releases page:
https://github.com/USERNAME/Waya-OS-Aqua-Jarvis/releases

Repository:
https://github.com/USERNAME/Waya-OS-Aqua-Jarvis

Website:
https://USERNAME.github.io/Waya-OS-Aqua-Jarvis/
```

---

## 🎮 QUICK LAUNCHER COMMANDS

### Start Launcher
```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\launcher"
python aqua_jarvis.py

# GUI window opens - see live system monitoring
```

### Check Launcher Configuration
```powershell
# View config
type launcher\config.json

# Edit config
notepad launcher\config.json

# Restart launcher to apply changes
```

### Add Custom App to Launcher
```json
// Edit launcher/config.json, add to "apps" array:
{
  "name": "My Custom App",
  "path": "C:\\Path\\To\\App.exe",
  "icon": "app_icon.png",
  "category": "Productivity"
}

// Save and restart launcher
```

---

## 🎯 TROUBLESHOOTING QUICK FIXES

### Python Not Found
```powershell
# Reinstall Python
# Download from: python.org
# IMPORTANT: Check "Add Python to PATH"

# Verify
python --version
```

### GPU Not Detected
```powershell
# Update NVIDIA drivers
# Download from: nvidia.com

# Verify installation
nvidia-smi

# If still not working, it may not be supported
```

### Installer Crashes
```powershell
# Check logs
type install.log

# Run as Administrator
powershell -ExecutionPolicy Bypass -File install.bat

# If still crashes, restore backup
.\scripts\restore\restore_system.ps1
```

### Theme Not Applying
```powershell
# Reapply theme
# Settings → Personalization → Themes → Browse themes
# Select: WayaOS_AquaJarvis.theme
# Restart Windows

# Or via command line
Control.exe /name Microsoft.Personalization /page pageColorization
```

---

## 📞 GETTING HELP

### Check Documentation
```
START_HERE.md - Quick answers
README.md - Full features
GITHUB_SETUP.md - Publishing
INSTALLATION_USB_GUIDE.md - User installation
TESTING_CHECKLIST.md - QA checks
```

### Report Issues
```
1. Go: GitHub Issues
2. Click: New Issue
3. Describe: What happened
4. Include: System info (Windows version, GPU, RAM)
5. Submit!
```

### Contact Support
```
Email: wayasteurbautsongs@gmail.com
GitHub: https://github.com/USERNAME/Waya-OS-Aqua-Jarvis/issues
Website: https://USERNAME.github.io/Waya-OS-Aqua-Jarvis/
```

---

## 🚀 FINAL CHECKLIST

- [ ] All files in place (38+ files)
- [ ] Python dependencies installed
- [ ] ISO built and verified (4-6 GB)
- [ ] GitHub repo created
- [ ] Files pushed to GitHub
- [ ] Website deployed
- [ ] USB bootable (tested with Rufus)
- [ ] Installation tested on test machine
- [ ] Theme applied correctly
- [ ] Launcher works
- [ ] AI integration functional
- [ ] Documentation complete
- [ ] Release published on GitHub
- [ ] Download links working
- [ ] Ready to share! ✨

---

**Ready to publish? Run:**
```cmd
setup.bat
```

Or follow **PUBLISHING_CHECKLIST.md** for step-by-step guide.

Good luck! 🌈✨
