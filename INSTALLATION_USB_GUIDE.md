# INSTALLATION_USB_GUIDE.md - Complete USB Installation Guide

## 🎯 Complete Installation Process (USB Method)

This guide covers how YOU and others can install Waya-OS from USB.

---

## 📋 What You Need

- **USB Drive**: 8+ GB (preferably USB 3.0 for speed)
- **ISO File**: WayaOS_AquaJarvis_v1.iso (~4.6 GB)
- **Tool**: Rufus (free, Windows)
- **Time**: ~30-45 minutes total
- **Backup**: External drive (100+ GB recommended)

---

## 🚀 Step-by-Step Installation

### Step 1: Download Tools

#### A. Download Rufus (USB Creator)
```
Website: https://rufus.ie/
Version: Latest (Portable recommended)
Size: ~1 MB
No installation needed!
```

#### B. Download Waya-OS ISO
```
From GitHub Releases:
https://github.com/YOUR-USERNAME/Waya-OS-Aqua-Jarvis/releases/
File: WayaOS_AquaJarvis_v1.iso
Size: 4-6 GB
Download time: 30-60 min (depends on speed)
```

---

### Step 2: Create Bootable USB

#### A. Insert USB Drive
```
1. Plug USB into computer
2. Wait for Windows to recognize it
3. Check: Device Manager to see drive letter
   (Usually D:, E:, or F:)
```

#### B. Open Rufus
```
1. Extract Rufus ZIP
2. Double-click: rufus.exe
3. Select language if prompted
4. Click: START
```

#### C. Configure Rufus
```
Setting                 Value
─────────────────────   ─────────────────────
Device                  [Your USB drive]
Boot selection          ISO Image
ISO Image               [Select ISO file]
Image option            Write in ISO 9660 mode
Partition scheme        MBR or GPT (auto)
File system             NTFS
Cluster size            Default
Volume label            WAYAOS
Target system           UEFI
```

**Visual Steps:**
1. Click device dropdown → select your USB
2. Click "SELECT" → browse to ISO file
3. Everything else auto-filled
4. Click "START"
5. Confirm: "Yes, I want to write..."

#### D. Wait for Flashing
```
Rufus will:
1. Format USB drive
2. Copy ISO contents
3. Make bootable
4. Verify files

⏱️ Time: 5-15 minutes
📊 Progress bar shown
```

#### E. Completion
```
When done:
✓ Green "READY" message
✓ Close Rufus
✓ Safe to eject USB
```

---

### Step 3: Install on Your Computer

#### A. Backup Your System (IMPORTANT!)
```powershell
# From your current Windows installation
# RUN BEFORE BOOTING USB!

cd "C:\Users\[YourUsername]\Pictures\Waya-OS_Aqua-Jarvis"
.\scripts\backup\backup_system.ps1 -BackupPath "E:\Waya-OS-Backup"

# Wait for backup to complete (30-60 min)
# Then proceed
```

#### B. Restart Computer with USB
```
1. Insert USB into computer
2. Restart computer: Start → Power → Restart
3. During startup, press one of these keys:
   - F2
   - F12
   - DEL
   - ESC
   - (Check your motherboard docs)
   
4. Enter BIOS/Boot Menu
5. Select: USB Drive
6. Press: ENTER
```

**Which Key for Your Computer?**
```
Manufacturer    Boot Key    BIOS Key
─────────────   ──────────  ────────
Dell            F12         F2
HP              F9          F10
Lenovo          F12         F1
ASUS            F8          DEL
Acer            F12         DEL
MSI             F11         DEL
```

#### C. Windows Installation Begins
```
After booting from USB:

Screen 1: Windows Setup
  └─ Click: Next

Screen 2: Install Now
  └─ Click: Install Now

Screen 3: License Terms
  └─ Check: I Accept
  └─ Click: Next

Screen 4: Installation Type
  └─ Select: Custom (Advanced)
  └─ Click: Next
```

#### D. Partition Selection
```
⚠️ IMPORTANT:

You'll see your drives:
- C: (Your main drive - Windows location)
- D: (Backup drive if present)
- Other partitions

Options:
A) Keep current Windows (Upgrade)
   └─ Select C: drive
   └─ Click: Next
   └─ Theme will apply to existing Windows

B) Fresh Install (Nuclear option)
   └─ WARNING: Erases C: drive!
   └─ Select C: drive
   └─ Click: Format
   └─ Continue
   └─ Clean slate install
```

**RECOMMENDATION**: Use Option A (Upgrade) to keep files

#### E. Installation Continues
```
Windows will:
1. Copy files (~5-10 min)
2. Install components (~10-15 min)
3. Configure settings (~5 min)
4. Restart (automatic)

Your computer may restart several times
This is NORMAL - let it complete!
```

#### F. First Boot Complete
```
After installation:

✓ Waya-OS theme automatically applied!
✓ Colors: Dark purple + aquamarine
✓ Wallpaper: Sweet Apocalypse cinematic
✓ Launcher: Aqua Jarvis on desktop
✓ All customizations active

🎉 Installation complete!
```

---

### Step 4: Post-Installation Setup

#### A. First Login
```
1. Windows log in with your credentials
2. Desktop shows Waya-OS theme
3. Aqua Jarvis launcher visible
4. All files intact (if upgraded)
```

#### B. Verify Everything
```
Checklist:
☐ Desktop wallpaper changed
☐ Taskbar is dark purple
☐ Aqua Jarvis shortcut on desktop
☐ File Explorer shows custom icons
☐ All your files present (if upgraded)
☐ System feels responsive
```

#### C. Optional: Configure Further
```
Set up AI:
  python ai_context/prompt_engine.py --init

Set up GPU (if you have NVIDIA):
  .\scripts\gpu_optimization\install_cuda.ps1

Configure launcher:
  Edit: launcher/config.json
  Restart: Aqua Jarvis application
```

#### D. Eject USB
```
1. Right-click USB → Eject
2. Remove from computer
3. Safe for future use
```

---

## ⚠️ Troubleshooting

### USB Won't Boot
```
Solution:
1. Try different USB port
2. Different USB drive
3. Check BIOS settings
4. Disable Secure Boot (if available)
5. Try "Legacy" mode in BIOS
```

### Windows Installer Won't Start
```
Solution:
1. Re-create USB with Rufus
2. Check ISO file integrity (MD5)
3. Use BalenaEtcher instead of Rufus
4. Try on different computer
```

### Installation Freezes
```
Solution:
1. Wait 15+ minutes (slow USB possible)
2. Remove external USB devices
3. Check BIOS temperature
4. Try with USB 2.0 port instead
```

### Lost My Files
```
BACKUP EXISTS - Restore from backup:

cd "C:\Users\[YourUsername]\Pictures\Waya-OS_Aqua-Jarvis"
.\scripts\backup\restore_system.ps1 -BackupPath "E:\Waya-OS-Backup"

System returns to before USB installation
```

### Theme Not Applied
```
Solution:
1. Restart computer
2. Run: .\install.bat (from extracted folder)
3. Manually apply theme from Settings
```

---

## 🔄 Upgrade vs Fresh Install

### UPGRADE (Recommended)
```
Keeps:
✓ All your files
✓ All your programs
✓ All settings
✓ User accounts

Changes:
⚠ Wallpaper (to Waya-OS)
⚠ Theme colors
⚠ Taskbar appearance
⚠ Some system sounds

Risk: LOW
Time: ~30 min
Best for: Existing Windows users
```

### FRESH INSTALL (Nuclear)
```
Deletes:
✗ Everything on C: drive
✗ All files (if not backed up!)
✗ All programs
✗ All settings

Provides:
✓ Clean Windows
✓ Optimized settings
✓ All Waya-OS features
✓ No bloatware

Risk: HIGH (data loss if no backup!)
Time: ~60 min
Best for: New systems or cleanup
```

**ALWAYS BACKUP FIRST EITHER WAY!**

---

## 📊 Installation Checklist

### Before USB Creation
- [ ] Downloaded Rufus tool
- [ ] Downloaded ISO file
- [ ] Have USB drive (8+ GB)
- [ ] USB formatted/empty
- [ ] Backup external drive ready

### During Installation
- [ ] Created bootable USB
- [ ] Tested USB boots
- [ ] Backed up system
- [ ] Booted from USB
- [ ] Selected correct drive
- [ ] Installation completed
- [ ] Computer restarted

### After Installation
- [ ] Theme applied
- [ ] Desktop shows new wallpaper
- [ ] Aqua Jarvis launcher works
- [ ] All files intact
- [ ] System stable
- [ ] Backed up USB for future use

---

## 🎯 Timeline

```
Activity                    Time
─────────────────────────   ──────
Download ISO                30-60 min
Create USB with Rufus       10-15 min
Back up your system         30-60 min
Install from USB            30-45 min
Post-install setup          10-15 min
──────────────────────────────────
TOTAL                       2-3 hours
```

---

## ✅ Success Indicators

Installation was successful when:
1. ✓ Windows boots normally
2. ✓ Sweet Apocalypse theme visible
3. ✓ All your files present (if upgraded)
4. ✓ Aqua Jarvis launcher launches
5. ✓ System feels stable & fast
6. ✓ GPU recognized (if NVIDIA)

---

## 📞 Help & Support

**Issues?**
- Read: START_HERE.md
- Read: INSTALL.md
- Check: QUICK_REFERENCE.md
- Contact: wayasteurbautsongs@gmail.com

**Need to restore?**
```powershell
.\scripts\backup\restore_system.ps1 -BackupPath "E:\Waya-OS-Backup"
```

---

## 🎉 You're Done!

Enjoy your Waya-OS: Aqua Jarvis Edition! 🌈✨🚀

Your personalized AI-powered Windows workspace is ready.
