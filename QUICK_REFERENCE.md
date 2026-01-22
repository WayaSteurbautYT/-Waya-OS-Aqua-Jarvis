# Waya-OS: Aqua Jarvis Edition - Quick Reference Guide

## Essential Commands

### Installation
```powershell
# Full installation with backup
.\install.bat

# Just backup your system
.\scripts\backup\backup_system.ps1 -BackupPath "E:\Backup"
```

### Launcher
```powershell
# Launch Aqua Jarvis (look for desktop shortcut)
python launcher\aqua_jarvis.py

# Or run from terminal
cd launcher
python aqua_jarvis.py
```

### GPU Setup (NVIDIA)
```powershell
# Install CUDA and optimize GPU
.\scripts\gpu_optimization\install_cuda.ps1 -CUDAVersion "12.2"

# Test GPU
nvidia-smi
```

### AI & Coding
```powershell
# Generate AI prompt context
python ai_context\prompt_engine.py --init

# Launch VS Code with AI session
python ai_context\prompt_engine.py --launch-vscode

# View chat summary
python ai_context\prompt_engine.py --summary
```

### System Recovery
```powershell
# Restore from backup if needed
.\scripts\backup\restore_system.ps1 -BackupPath "E:\Backup"
```

### Create ISO (Advanced)
```powershell
# Build custom Windows ISO with Waya-OS theme
.\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode
```

---

## File Structure Quick Reference

```
Waya-OS_Aqua-Jarvis/
├── install.bat                     ← RUN THIS FIRST
├── README.md                       ← Full documentation
├── INSTALL.md                      ← Step-by-step guide
│
├── launcher/                       ← Aqua Jarvis GUI
│   └── aqua_jarvis.py             ← Main launcher app
│
├── theme/                          ← Windows theme files
│   └── WayaOS_AquaJarvis.theme
│
├── ai_context/                     ← AI prompt engine
│   └── prompt_engine.py            ← Generate AI prompts
│
├── scripts/
│   ├── backup/                     ← System backup scripts
│   └── gpu_optimization/           ← NVIDIA GPU setup
│
├── vscode_config/                  ← VS Code settings
│   └── settings.json               ← Color scheme, etc.
│
└── iso_builder/                    ← Create custom ISO
    └── build_iso.ps1
```

---

## Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Can't run .ps1 scripts | Right-click PowerShell → Run as Admin |
| Theme not applying | Double-click `.deskthemepack` file |
| GPU not detected | Run `nvidia-smi` in terminal; update drivers if blank |
| Python not found | Install: `winget install Python.Python.3.11` |
| Backup failed | Ensure 100+ GB free space on backup drive |
| Permission denied | Run terminal/PowerShell as Administrator |

---

## Default Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| VS Code with AI | `Ctrl+Shift+P` → "Aqua Jarvis: AI Session" |
| Terminal | `Ctrl+\`` (in VS Code) |
| Quick launch | Press `Win+Space` then type app name |

---

## Contact & Support

- **Creator**: Waya Steurbaut
- **Email**: wayasteurbautsongs@gmail.com  
- **GitHub**: (if public repo established)

---

## What's Next?

1. ✅ Run `install.bat`
2. ✅ Backup your system automatically
3. ✅ Apply theme
4. ✅ Install Aqua Jarvis launcher
5. ✅ Optional: Set up NVIDIA GPU acceleration
6. ✅ Start coding with AI in VS Code
7. ✅ Share your ISO with others (optional)

**Welcome to Waya-OS: Aqua Jarvis Edition!** 🌈🤖
