# Installation Guide — Waya-OS: Aqua Jarvis Edition

---

## 🔒 Pre-Installation Checklist

- [ ] You have **Administrator privileges**
- [ ] Your NVIDIA GPU is **recognized by Windows** (`devmgmt.msc` → Display adapters)
- [ ] You have **backup storage** (external drive with 100+ GB free space)
- [ ] You've **closed all running applications** except this guide
- [ ] **Windows Update** is current (optional but recommended)

---

## ⚙️ Step 1: Backup Your System

**This is non-destructive but critical.**

1. **Open PowerShell as Administrator**:
   - Press `Win + X` → Select "Windows PowerShell (Admin)"

2. **Run backup script**:
   ```powershell
   cd "C:\path\to\Waya-OS_Aqua-Jarvis"
   .\scripts\backup\backup_system.ps1 -BackupPath "E:\Waya-OS-Backup"
   ```
   (Replace `E:` with your backup drive letter)

3. **Wait for completion** (5–15 minutes depending on system size)

4. **Verify backup**:
   ```powershell
   Get-ChildItem "E:\Waya-OS-Backup" | Measure-Object -Property Length -Sum
   ```
   Should show files totaling 50+ GB.

---

## 🎨 Step 2: Install Theme

1. **Double-click** `WayaOS_AquaJarvis.deskthemepack` (in `theme/` folder)
   - Windows will open Personalization → Apply theme

2. **Confirm theme application**:
   - Desktop wallpaper changes to Sweet Apocalypse imagery
   - Colors update to neon rainbow + aquamarine palette
   - Windows borders glow with active color

3. **If custom icons don't appear**:
   ```powershell
   .\theme\apply_icons.ps1
   ```

---

## 🚀 Step 3: Install Launcher (Aqua Jarvis)

1. **Install Python 3.10+** (if not already installed):
   ```powershell
   winget install Python.Python.3.11
   ```

2. **Install launcher dependencies**:
   ```powershell
   cd launcher
   pip install -r requirements.txt
   ```

3. **Create desktop shortcut**:
   ```powershell
   .\scripts\create_launcher_shortcut.ps1
   ```

4. **Launch Aqua Jarvis**:
   - Double-click "Aqua Jarvis" on your desktop
   - First run will auto-configure GPU detection

---

## 🎮 Step 4: GPU Optimization (NVIDIA Only)

1. **Check GPU status**:
   ```powershell
   nvidia-smi
   ```
   Should display your GPU name, memory, driver version.

2. **Install/Update NVIDIA drivers** (if needed):
   ```powershell
   .\scripts\gpu_optimization\install_nvidia_drivers.ps1
   ```

3. **Install CUDA Toolkit** (for AI/ML workloads):
   ```powershell
   .\scripts\gpu_optimization\install_cuda.ps1 -CUDAVersion "12.2"
   ```

4. **Verify installation**:
   ```powershell
   nvcc --version
   ```

---

## 📝 Step 5: Configure AI Context

1. **Copy your ChatGPT conversation data**:
   ```powershell
   Copy-Item "C:\path\to\conversations.json" -Destination ".\ai_context\conversations.json"
   ```

2. **Generate prompt engine context**:
   ```powershell
   python .\ai_context\prompt_engine.py --init
   ```

3. **Test AI prompt generation**:
   ```powershell
   python .\ai_context\prompt_engine.py --test --style "dark_comedy"
   ```

---

## 💻 Step 6: Configure VS Code (Optional)

1. **Download VS Code Portable**:
   ```powershell
   .\vscode_config\download_vscode_portable.ps1
   ```

2. **Apply Waya-OS theme & extensions**:
   ```powershell
   Copy-Item ".\vscode_config\settings.json" -Destination "$env:APPDATA\Code\User\settings.json" -Force
   ```

3. **Install recommended extensions**:
   - Copilot Vibe
   - Python
   - C# Dev Kit
   - GitLens
   - Thunder Client (REST client)

---

## 🌐 Step 7: Create Windows ISO (Optional)

**If you want to share or reinstall on another machine:**

1. **Build custom ISO**:
   ```powershell
   .\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeGPUDrivers
   ```

2. **ISO will be created at**:
   ```
   .\iso_builder\output\WayaOS_AquaJarvis_v1.iso
   ```

3. **To boot from ISO**:
   - Use **Rufus** or **BalenaEtcher** to flash to USB
   - Boot from USB on target machine
   - Follow Windows installation wizard (theme pre-loaded)

---

## ✅ Step 8: Verify Installation

1. **Check theme**:
   - Desktop should display Sweet Apocalypse wallpaper ✓
   - Taskbar should be dark purple with rainbow accents ✓
   - Window borders should glow on active window ✓

2. **Check launcher**:
   - Aqua Jarvis should launch without errors ✓
   - GPU memory should display in dashboard ✓
   - Quick-launch buttons should work ✓

3. **Check AI context**:
   - Open VS Code → press `Ctrl+Shift+P`
   - Search "Aqua Jarvis" → should find AI session command ✓

4. **Check GPU** (if installed):
   ```powershell
   nvidia-smi
   python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
   ```
   Should list your GPU ✓

---

## 🔄 If Anything Goes Wrong

### **Option A: Restore from Backup**

```powershell
.\scripts\backup\restore_system.ps1 -BackupPath "E:\Waya-OS-Backup"
```

Your system will revert to pre-installation state. **No data loss.**

### **Option B: Reset Theme Only**

```powershell
Right-click desktop → Personalize → Colors → Select "Light" or previous theme
```

Then:
```powershell
Remove-Item -Path "HKCU:\Control Panel\Desktop\ConvertedWallpaper" -Force
```

### **Option C: Reinstall Launcher**

```powershell
Remove-Item "C:\Users\[YourUsername]\AppData\Local\AquaJarvis" -Recurse -Force
cd launcher
pip install -r requirements.txt
python aqua_jarvis.py
```

---

## 📞 Support

| Issue | Command | Note |
|-------|---------|------|
| Theme not applying | `.\theme\apply_icons.ps1` | Run as Admin |
| Launcher crashes | Check `launcher\config.json` syntax | Use `config_default.json` as reference |
| GPU not detected | `nvidia-smi` | Update NVIDIA drivers if blank |
| Python/pip missing | `winget install Python.Python.3.11` | Requires Windows 10+ |
| Backup failed | Check target drive space | Need 100+ GB free |

---

## 🎉 Installation Complete!

Once all steps are done:

1. **Restart your computer** (recommended)
2. **Open Aqua Jarvis** from your desktop
3. **Start coding with Waya's voice** — open VS Code, press `Ctrl+Shift+P`, select "Aqua Jarvis: AI Session"
4. **Enjoy your personalized Windows subsystem!**

---

**Questions?** Check `README.md` or create a GitHub issue (if repo is public).

**Ready to create an ISO?** See Step 7 above.

**Welcome to Waya-OS! 🌈🚀**
