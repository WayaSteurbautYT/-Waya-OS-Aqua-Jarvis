# DEPLOYMENT.md - Waya-OS Installation & Distribution Guide

## 🚀 Deployment Roadmap

This guide walks you through deploying Waya-OS: Aqua Jarvis Edition on your system and optionally creating a shareable ISO for others.

---

## Phase 1: Safe Installation (No Data Loss)

### Step 1A: Initial Assessment
```powershell
# Check system specs
Write-Host "System Info:"
Get-WmiObject Win32_ComputerSystem | Select-Object Name, Manufacturer, Model
Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | ForEach-Object { "RAM: $([Math]::Round($_.Sum / 1GB)) GB" }
Get-WmiObject Win32_LogicalDisk -Filter "Name='C:'" | ForEach-Object { "Disk Space: $([Math]::Round($_.FreeSpace / 1GB)) GB free" }

# Check for NVIDIA GPU
Get-WmiObject Win32_VideoController | Where-Object { $_.Name -match "NVIDIA|GeForce|RTX" }
```

**Requirements Met?**
- ✅ Windows 10/11/12 (64-bit)
- ✅ 500 MB free for theme + launcher
- ✅ 100+ GB backup space (external drive recommended)
- ✅ Administrator access

### Step 1B: Backup Critical Data
```powershell
# Option 1: Automatic backup (Recommended)
cd C:\Users\{YourUsername}\Pictures\Waya-OS_Aqua-Jarvis
.\install.bat

# This will:
# - Create system restore point
# - Back up Desktop, Documents, Pictures, Downloads
# - Export registry settings
# - Save everything to external drive

# Option 2: Manual backup (if you prefer)
.\scripts\backup\backup_system.ps1 -BackupPath "E:\Waya-OS-Backup"
```

**Verify Backup Success:**
```powershell
Get-Item "E:\Waya-OS-Backup" -Recurse | Measure-Object -Property Length -Sum
# Should show 50+ GB backed up
```

### Step 1C: Run Installation
```powershell
# Navigate to Waya-OS folder
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Run installer (choose your preference)
.\install.bat        # Interactive wizard (recommended for first-time)
```

**What install.bat does:**
1. ✅ Creates system backup
2. ✅ Installs theme & wallpapers
3. ✅ Applies custom icons
4. ✅ Sets up launcher (Aqua Jarvis)
5. ✅ Creates desktop shortcut
6. ✅ Optional: GPU driver setup
7. ✅ Optional: Imports chat history for AI
8. ✅ Creates rollback point

**Expected Time: 10-30 minutes** (depending on GPU driver installation)

### Step 1D: Verify Installation
```powershell
# Check theme applied
Get-ItemProperty "HKCU:\Control Panel\Appearance\NewScheme"

# Verify launcher works
python "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\launcher\aqua_jarvis.py"

# Test GPU detection (if applicable)
nvidia-smi
```

### Step 1E: Reboot & Enjoy
```powershell
Restart-Computer -Force
```

**First Boot After Reboot:**
- Theme will be fully applied
- Aqua Jarvis launcher will appear on desktop
- Windows will have created restore point
- Your data is fully backed up

---

## Phase 2: GPU Optimization (Optional but Recommended)

If you have NVIDIA GPU:

```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Install CUDA & cuDNN
.\scripts\gpu_optimization\install_cuda.ps1 -CUDAVersion "12.2"

# Verify GPU
nvidia-smi

# Test in launcher - should show VRAM usage
python launcher\aqua_jarvis.py
```

---

## Phase 3: AI Coding Setup (Optional)

```powershell
# Import your ChatGPT conversation data
python ai_context\prompt_engine.py --init

# Launch VS Code with AI context
python ai_context\prompt_engine.py --launch-vscode
```

**Result**: VS Code will load with your personal AI coding style from chat history.

---

## Phase 4: Create Custom ISO (For Distribution)

### Prerequisites
- Windows ADK installed (download from Microsoft)
- 15+ GB free disk space
- Windows source media (or ISO file)

### Build ISO
```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Option 1: With all features
.\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeGPUDrivers

# Option 2: Minimal (theme only)
.\iso_builder\build_iso.ps1

# Output: iso_builder\output\WayaOS_AquaJarvis_v1.iso (4-6 GB)
```

### Create Bootable USB
1. **Download Rufus** or BalenaEtcher
2. **Select** `WayaOS_AquaJarvis_v1.iso`
3. **Target** USB drive (8+ GB)
4. **Flash** and wait for completion

### Share ISO
```powershell
# Upload to cloud storage or create release on GitHub
# File: iso_builder\output\WayaOS_AquaJarvis_v1.iso
# Size: ~4-6 GB
# Distribution: Git releases or cloud drive
```

---

## Emergency: System Rollback

If something goes wrong:

```powershell
# Option 1: Full restore from backup
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"
.\scripts\backup\restore_system.ps1 -BackupPath "E:\Waya-OS-Backup"

# Option 2: Reset theme only
Right-click desktop → Personalize → Colors → Select previous theme

# Option 3: Use Windows restore point
Control Panel → System → System Protection → System Restore
# Select "Waya-OS Pre-Installation Backup"
```

---

## Post-Installation Configuration

### Customize Launcher
Edit `launcher\config.json`:
```json
{
  "quick_launch": {
    "apps": [
      { "name": "VS Code", "command": "code" },
      { "name": "Roblox Studio", "command": "..." }
    ]
  }
}
```

### Change Theme Colors
Edit `launcher\config.json`:
```json
{
  "theme": {
    "colors": {
      "primary": "#7FFFD4",
      "secondary": "#3A0CA3"
    }
  }
}
```

### Add Custom Wallpapers
```powershell
# Copy 4K images (3840x2160) to:
wallpapers\static\your_wallpaper.jpg

# Or animated:
wallpapers\animated\your_animation.mp4
```

---

## Troubleshooting Deployment

### Theme Won't Apply
```powershell
# Re-run installer
.\install.bat

# Or manually:
Right-click theme\WayaOS_AquaJarvis.deskthemepack → Apply
```

### Launcher Crashes
```powershell
# Check config syntax
python -m json.tool launcher\config.json

# Reinstall dependencies
cd launcher
pip install -r requirements.txt --force-reinstall
```

### GPU Not Detected
```powershell
# Update NVIDIA drivers first
# Then install CUDA
.\scripts\gpu_optimization\install_cuda.ps1

# Restart computer
Restart-Computer -Force

# Verify
nvidia-smi
```

### Can't Restore from Backup
```powershell
# Check backup exists
Get-Item "E:\Waya-OS-Backup\backup_metadata.json"

# Try manual file copy
robocopy "E:\Waya-OS-Backup\Desktop" "$env:USERPROFILE\Desktop" /E
robocopy "E:\Waya-OS-Backup\Documents" "$env:USERPROFILE\Documents" /E
```

---

## Deployment Checklist

### Before Installation
- [ ] Backup external drive connected (100+ GB free)
- [ ] All applications closed
- [ ] Administrator access verified
- [ ] Read INSTALL.md completely
- [ ] System meets minimum specs

### During Installation
- [ ] Confirmed backup creation
- [ ] Confirmed theme installation
- [ ] Confirmed launcher setup
- [ ] Approved GPU driver installation (if applicable)

### After Installation
- [ ] Theme applied & visible
- [ ] Desktop wallpaper changed
- [ ] Aqua Jarvis launcher works
- [ ] System performance normal
- [ ] All data intact & accessible

### Optional (After Stabilization)
- [ ] GPU drivers installed
- [ ] AI context imported
- [ ] VS Code customized
- [ ] ISO created for backup/distribution

---

## Success Indicators

✅ **Installation Successful When:**
- Desktop displays Sweet Apocalypse wallpaper
- Taskbar is dark purple with rainbow accents
- Aqua Jarvis launcher opens without errors
- All your files are accessible and unchanged
- System boots normally

✅ **GPU Optimization Successful When:**
- `nvidia-smi` shows GPU memory usage
- Launcher displays GPU/VRAM stats
- Python can access GPU (if tested)

✅ **ISO Creation Successful When:**
- `iso_builder\output\WayaOS_AquaJarvis_v1.iso` exists
- ISO size is 4-6 GB
- ISO can be written to USB successfully

---

## Next Steps

1. ✅ **Install on main system** (Phase 1)
2. ✅ **Set up GPU** if you have NVIDIA (Phase 2)
3. ✅ **Configure AI coding** (Phase 3)
4. ✅ **Create ISO** to share with friends/community (Phase 4)

---

## Support

**Issues?** Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md) or contact:
- Email: wayasteurbautsongs@gmail.com
- GitHub Issues: [repo]/issues (if public)

**Everything working?** Share your setup! Post screenshots/videos of your Waya-OS desktop.

---

**Welcome to Waya-OS: Aqua Jarvis Edition!** 🌈🚀

Your personalized, AI-powered Windows workspace is now live.
