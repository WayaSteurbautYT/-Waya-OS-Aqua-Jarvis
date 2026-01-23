# Waya-OS: Aqua Jarvis ISO Setup Guide

## 🚀 Quick Start

Welcome to Waya-OS: Aqua Jarvis Edition! This guide will help you create and install your personalized Windows customization system.

## 📋 Prerequisites

### System Requirements
- **Windows 10/11** (64-bit)
- **Administrator privileges** (required for installation)
- **15GB free disk space** (for ISO creation)
- **Windows ADK** (Assessment and Deployment Kit)

### Required Software
- **Windows ADK**: Download from [Microsoft](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install)
  - Select: "Deployment Tools" and "Windows Preinstallation Environment"

---

## 🛠️ Step 1: Create Your Waya-OS ISO

### Option A: Automated Safe Builder (Recommended)

1. **Download the project** from GitHub
2. **Right-click** `BUILD_WAYA_OS_SAFE.bat`
3. **Select "Run as administrator"**
4. **Follow the on-screen prompts**

The script will:
- ✅ Verify administrator privileges
- ✅ Check disk space (minimum 15GB)
- ✅ Create system backup for safety
- ✅ Verify Windows ADK installation
- ✅ Copy essential Waya-OS components
- ✅ Create clean ISO file

### Option B: Manual ISO Creation

If the automated script fails:

1. Install Windows ADK with oscdimg.exe
2. Copy these folders to a new directory:
   - `launcher/` (Aqua Jarvis GUI)
   - `theme/` (Visual customization)
   - `icons/` (System icons)
   - `scripts/` (Automation scripts)
   - `ai_context/` (AI integration)
3. Add `autorun.inf`:
   ```
   [autorun]
   open=launcher\aqua_jarvis.py
   icon=icons\waya.ico
   label=Waya-OS Aqua Jarvis
   ```
4. Use oscdimg.exe to create ISO:
   ```
   oscdimg.exe -m -o -u2 -udfver102 -l"WayaOS_AquaJarvis" "source_folder" "WayaOS_AquaJarvis.iso"
   ```

---

## 💿 Step 2: Prepare Installation Media

### Option A: USB Drive (Recommended)

1. **Download Rufus**: [rufus.ie](https://rufus.ie/)
2. **Insert USB drive** (8GB+ recommended)
3. **Open Rufus**
4. **Select your Waya-OS ISO**
5. **Choose "GPT" partition scheme**
6. **Click "Start"**

### Option B: Virtual Machine Testing

1. **Download VirtualBox** or **VMware**
2. **Create new VM** with Windows 10/11 settings
3. **Mount the ISO** as virtual CD/DVD
4. **Boot from ISO** for testing

---

## 🔄 Step 3: Install Waya-OS

### Boot from Installation Media

1. **Restart your computer**
2. **Enter BIOS/UEFI** (usually F2, F10, F12, or Del key)
3. **Change boot order** to prioritize USB/DVD
4. **Save changes and exit**
5. **Boot from your Waya-OS media**

### Installation Process

The installation will automatically:
- ✅ Install Aqua Jarvis launcher
- ✅ Apply Waya-OS visual theme
- ✅ Configure system icons
- ✅ Set up AI context integration
- ✅ Create desktop shortcuts

### Post-Installation Setup

1. **First boot**: Windows will start normally
2. **Look for "Aqua Jarvis"** on your desktop
3. **Double-click to launch** your AI workspace
4. **Optional**: Configure NVIDIA GPU optimization
5. **Optional**: Import ChatGPT conversation data

---

## 🎨 Features Included

### Core Components
- **Aqua Jarvis Launcher**: AI-powered system dashboard
- **Sweet Apocalypse Theme**: Custom colors, wallpapers, icons
- **System Scripts**: Backup, restore, and optimization tools
- **AI Integration**: ChatGPT context and prompt engineering

### Optional Enhancements
- **GPU Optimization**: NVIDIA CUDA drivers and settings
- **Theme Customization**: Additional wallpapers and sounds
- **Backup System**: Automated system state preservation

---

## 🔧 Troubleshooting

### ISO Creation Issues

**"Administrator privileges required"**
- Right-click the batch file → "Run as administrator"

**"Windows ADK not found"**
- Download and install Windows ADK
- Ensure "Deployment Tools" are selected

**"Insufficient disk space"**
- Free up at least 15GB of space
- Use a different drive if needed

### Installation Issues

**"Boot device not found"**
- Check USB drive is properly formatted
- Verify BIOS boot order
- Try a different USB port

**"Theme not applying"**
- Ensure administrator privileges
- Restart after theme installation
- Check Windows Personalization settings

**"Launcher won't start"**
- Install Python 3.11+ if missing
- Run: `pip install -r launcher\requirements.txt`
- Check launcher\config.json file

### Performance Issues

**Slow system after installation**
- Run GPU optimization if you have NVIDIA card
- Disable unnecessary startup programs
- Check system resources in Task Manager

---

## 📞 Support & Resources

### Documentation
- **AGENTS.md**: AI assistant guidelines
- **README.md**: Project overview
- **INSTALL.md**: Detailed installation steps

### Community
- **GitHub Issues**: Report bugs and request features
- **Discussions**: Share experiences and tips

### System Information
- **OS**: Windows 10/11
- **Architecture**: x64
- **Theme**: Sweet Apocalypse (Aqua/Purple/Gold)
- **AI**: Integrated ChatGPT context

---

## 🚨 Safety & Backup

### Before Installation
- **Create system backup** (highly recommended)
- **Save important files** to external drive
- **Note current system settings**

### Rollback Options
- System backup created automatically by installer
- Manual restore: Use Windows System Restore
- Fresh install: Boot from original Windows media

### Data Preservation
- User files are preserved during installation
- Settings can be exported before changes
- Backup location: `%TEMP%\WayaOS_Backup_[timestamp]\`

---

## 🎯 Next Steps

1. **Test in Virtual Machine** (recommended first)
2. **Customize AI prompts** in `ai_context\`
3. **Configure backup schedules** in scripts
4. **Explore launcher features**
5. **Join the community**

---

## 📋 Checklist

- [ ] Windows ADK installed
- [ ] 15GB+ free disk space
- [ ] Administrator account
- [ ] USB drive (8GB+) or blank DVD
- [ ] Rufus downloaded (for USB)
- [ ] System backup created
- [ ] BIOS boot order configured
- [ ] Installation media created
- [ ] Ready for reboot installation

---

*Remember: In the digital apocalypse, well-documented code survives. Welcome to Waya-OS!*

---

## 🔗 Quick Links

- **Project Home**: [GitHub Repository]
- **Download ISO**: `iso_output\WayaOS_AquaJarvis_[timestamp].iso`
- **Documentation**: `AGENTS.md`, `README.md`
- **Support**: Create GitHub issue

---

*Created with ❤️ by Waya-OS development team*