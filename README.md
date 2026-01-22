# Waya-OS: Aqua Jarvis Edition
## AI-Powered Windows Subsystem | NVIDIA GPU Optimized | Sweet Apocalypse Theme

---

## 🎨 Overview

**Waya-OS: Aqua Jarvis Edition** is a personalized, fully-themed Windows subsystem optimized for NVIDIA GPUs. It integrates:

- **Sweet Apocalypse theming** (custom wallpapers, icons, cursors, UI)
- **AI-powered coding assistant** (VS Code + Copilot with chat history context)
- **Custom launcher dashboard** (Aqua Jarvis — your personal AI workspace manager)
- **NVIDIA GPU optimization** (CUDA, cuDNN, TensorFlow/PyTorch ready)
- **Automatic system backup & rollback** (safe installation without losing existing data)
- **Custom ISO builder** (distribute your personalized Windows setup)

**Target Use**: Content creators, AI developers, gamers, and Waya Steurbaut fans.

---

## 📦 Package Contents

```
Waya-OS_Aqua-Jarvis/
├── theme/                          # Windows theme files
│   ├── WayaOS_AquaJarvis.theme
│   ├── WayaOS_AquaJarvis.deskthemepack
│   └── sounds/
├── wallpapers/static/              # 4K Sweet Apocalypse wallpapers
├── icons/
│   ├── folders/                    # Folder icons (candy-themed)
│   ├── apps/                       # App icons (VS Code, Roblox, etc.)
│   └── system/                     # System icons (recycle bin, settings, etc.)
├── launcher/                       # Aqua Jarvis custom launcher GUI
│   ├── aqua_jarvis.py              # Main launcher application
│   └── config.json
├── scripts/
│   ├── backup/                     # System backup scripts
│   │   ├── backup_system.ps1       # PowerShell backup automation
│   │   └── restore_system.ps1
│   └── gpu_optimization/           # NVIDIA GPU setup
│       ├── install_cuda.ps1
│       └── gpu_config.json
├── ai_context/                     # AI prompt integration
│   ├── chat_history.json           # Your ChatGPT conversations
│   ├── prompt_engine.py            # Generates AI prompts from context
│   └── copilot_style_guide.md      # "Waya's voice" for coding
├── vscode_config/                  # Pre-configured VS Code
│   ├── settings.json
│   ├── extensions.json
│   └── keybindings.json
├── iso_builder/                    # Custom ISO creation
│   ├── build_iso.ps1
│   └── iso_config.json
├── README.md
├── INSTALL.md
├── LICENSE
└── install.bat                     # One-click installer
```

---

## 🚀 Quick Start

### **Option 1: Install on Current System (Recommended for Testing)**

1. **Backup your system first**:
   ```powershell
   .\scripts\backup\backup_system.ps1 -BackupPath "D:\Waya-OS-Backup"
   ```

2. **Run the installer**:
   ```powershell
   .\install.bat
   ```

3. **Follow on-screen prompts** to install theme, launcher, and GPU drivers.

4. **Reboot** and enjoy your Aqua Jarvis workspace!

### **Option 2: Create Custom ISO (for Distribution)**

```powershell
.\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeCUDA
```

This creates a bootable ISO with your personalized Windows setup, complete with:
- Pre-configured theme
- VS Code with Copilot
- CUDA & GPU drivers
- Aqua Jarvis launcher
- Your app shortcuts

### **Option 3: Rollback to Previous System**

If anything goes wrong:
```powershell
.\scripts\backup\restore_system.ps1 -BackupPath "D:\Waya-OS-Backup"
```

---

## 🎮 Features

### **1. Aqua Jarvis Launcher**
- Custom GUI dashboard matching Sweet Apocalypse theme
- Quick-launch buttons for VS Code, Roblox Studio, AI tools
- System monitoring (CPU, GPU, RAM, VRAM)
- AI prompt generator (pulls chat history context)
- Desktop organizer with candy-themed icons

### **2. AI-Powered Coding**
- VS Code pre-configured with **Copilot Vibe**
- Chat history integration: coding suggestions in "Waya's voice"
- MCP script templates preloaded
- Auto-complete for your custom functions

### **3. Sweet Apocalypse Theme**
- Neon RGB color palette (#FF0000 → #FF9900 → #FFFF00 → ... → #9900FF)
- Dark purple + aquamarine UI accents
- Animated hover effects on buttons and icons
- Rainbow glowing borders on active windows
- Candy-apocalypse wallpapers (4K)

### **4. NVIDIA GPU Optimization**
- CUDA 12.x + cuDNN auto-installation
- TensorFlow & PyTorch pre-configured
- GPU memory monitoring in launcher
- NVIDIA Control Panel presets for gaming/AI workloads
- Driver auto-update script

### **5. System Backup & Safety**
- One-click backup before installation
- Automatic system restore point
- Rollback functionality (no data loss)
- Version control for launcher/theme updates

---

## 🛠 Installation Requirements

### **Hardware**
- Windows 10/11/12 (64-bit)
- NVIDIA GPU (GeForce GTX 960+, RTX 20 series or newer recommended)
- 500 MB free disk space (theme + launcher)
- 8+ GB RAM (16+ GB for GPU AI workloads)

### **Software**
- Administrator privileges
- PowerShell 5.0+
- .NET Framework 4.7+
- Visual C++ Redistributables (auto-installed)

### **Optional**
- VS Code (auto-downloaded during install)
- Rainmeter (for advanced widget panels)
- Lively Wallpaper (for animated backgrounds)

---

## 📝 Configuration

### **Customize Launcher Theme**

Edit `launcher/config.json`:
```json
{
  "theme": {
    "primary_color": "#7FFFD4",
    "secondary_color": "#3A0CA3",
    "accent_color": "#FFD700",
    "font": "Segoe UI",
    "opacity": 0.95
  },
  "startup_apps": ["VS Code", "Roblox Studio"],
  "ai_style": "dark_comedy_apocalypse"
}
```

### **Enable GPU Acceleration**

Run:
```powershell
.\scripts\gpu_optimization\install_cuda.ps1
```

Then configure in `ai_context/prompt_engine.py`:
```python
USE_GPU = True
GPU_MEMORY_FRACTION = 0.8
```

### **Add Custom Wallpapers**

1. Drop `.jpg`/`.png` files (4K, 3840x2160) into `wallpapers/static/`
2. Restart launcher
3. Right-click desktop → Personalize → Background → select your wallpaper

---

## 🔗 AI Integration

### **Coding with Waya's Voice**

1. Open VS Code
2. Press `Ctrl+Shift+P` → "Aqua Jarvis: Start AI Session"
3. Launcher loads chat history + style guide
4. Copilot suggests code in your preferred style/patterns

### **Update Chat Context**

```powershell
.\ai_context\prompt_engine.py --update-from-chatgpt
```

This syncs your latest ChatGPT conversations into the subsystem.

---

## 🎯 Troubleshooting

| Issue | Solution |
|-------|----------|
| Theme not applying | Right-click theme file → "Apply" or run `install.bat` again |
| GPU not recognized | Run `nvidia-smi` in terminal; if blank, reinstall NVIDIA drivers |
| Launcher crashes | Check `launcher/config.json` syntax; restore default: `launcher/config_default.json` |
| Backup failed | Ensure target drive has 100+ GB free space; run as Administrator |
| ISO creation hangs | Disable antivirus; ensure 15+ GB free disk space |

---

## 📜 License

**MIT License** — Free to use, modify, and distribute with attribution.

For commercial use or custom modifications, contact Waya Steurbaut.

---

## 🌟 Credits

- **Creator**: Waya Steurbaut (@WayaSteurbautYT)
- **Theme**: Sweet Apocalypse Universe
- **AI Integration**: Copilot Vibe + Custom Prompt Engine
- **GPU Optimization**: NVIDIA CUDA toolkit

---

## 🔄 Updates & Support

- **Check for updates**: `launcher/check_updates.py`
- **Report issues**: GitHub Issues (if repo is public)
- **Customize further**: Edit files in `/launcher`, `/ai_context`, `/scripts`

---

## ⚖️ Legal Notice

This subsystem is provided "as-is" without warranty. Always backup your system before installation. Microsoft Windows is a trademark of Microsoft Corporation.

---

**Welcome to Waya-OS: Aqua Jarvis Edition — Your personalized AI workspace is ready.** 🌈🤖
