# Waya-OS Project - Contribution & Development Guide

## Project Overview

**Waya-OS: Aqua Jarvis Edition** is an open-source, personalized Windows subsystem featuring:
- Sweet Apocalypse aesthetic theme
- AI-integrated coding workspace
- NVIDIA GPU optimization
- Custom launcher & dashboard

---

## Getting Started as Developer/Contributor

### Prerequisites
- Windows 10/11/12 (64-bit)
- Administrator privileges
- Python 3.10+
- PowerShell 5.0+
- Git (optional, for version control)

### Development Setup

1. **Clone or download** the project
   ```powershell
   git clone https://github.com/WayaSteurbautYT/Waya-OS.git
   cd Waya-OS
   ```

2. **Install dependencies**
   ```powershell
   cd launcher
   pip install -r requirements.txt
   cd ..
   ```

3. **Test launcher locally**
   ```powershell
   python launcher/aqua_jarvis.py
   ```

4. **Review documentation**
   - `README.md` — Full overview
   - `INSTALL.md` — Installation steps
   - `QUICK_REFERENCE.md` — Common tasks

---

## Project Structure & Responsibilities

### `/theme`
**Responsible**: Visual design
- Windows theme configuration (`.theme`, `.deskthemepack`)
- Color palette definitions
- Icon sets (folders, apps, system)
- Wallpapers (static & animated)
- Cursor designs

**To Contribute**: 
- Create new wallpapers (4K, 3840x2160)
- Design custom icons (PNG or ICO format)
- Modify color scheme in `WayaOS_AquaJarvis.theme`

### `/launcher` (Aqua Jarvis)
**Responsible**: GUI dashboard application
- Main launcher interface
- System monitoring (CPU, GPU, RAM)
- Quick-launch buttons
- Configuration UI

**Technology**: Python + Tkinter
**To Contribute**:
- Enhance GUI with new panels
- Add more system metrics
- Improve responsiveness

### `/ai_context`
**Responsible**: AI prompt generation & integration
- Chat history processing
- Prompt engine for Copilot
- Style guide generation
- Context templates

**To Contribute**:
- Improve prompt generation algorithm
- Add support for other AI providers
- Create new style templates

### `/scripts`
**Responsible**: System automation
- Backup/restore functionality
- GPU driver installation
- System setup & configuration

**To Contribute**:
- Optimize backup speed
- Add new driver support
- Create additional utility scripts

### `/vscode_config`
**Responsible**: VS Code integration
- Theme & color customization
- Extension recommendations
- Keyboard shortcuts
- Debugging configs

**To Contribute**:
- Add new VS Code extensions
- Improve color scheme
- Create custom snippets

### `/iso_builder`
**Responsible**: Custom ISO creation
- Windows ISO packaging
- Component integration
- Distribution media creation

**To Contribute**:
- Optimize ISO size
- Add pre-loaded apps
- Improve build speed

---

## Code Style & Standards

### Python
```python
# Follow PEP 8
# - Use snake_case for variables/functions
# - Use CamelCase for classes
# - Comment complex logic
# - Type hints encouraged (Python 3.10+)

def launch_application(app_name: str) -> bool:
    """Launch application with error handling."""
    try:
        subprocess.Popen(app_name)
        return True
    except Exception as e:
        logging.error(f"Failed to launch {app_name}: {e}")
        return False
```

### PowerShell
```powershell
# Use proper cmdlet names, not aliases
# Add -ErrorAction and error checking
# Use Write-Host for colored output
# Comments for complex operations

function Backup-UserData {
    param([string]$TargetPath)
    
    if (-not (Test-Path $TargetPath)) {
        Write-Host "ERROR: Target path not found" -ForegroundColor Red
        return $false
    }
    
    # Backup logic here
    return $true
}
```

### Documentation
- **Markdown** for all docs
- **Clear headers** (H1, H2, H3)
- **Code blocks** with language tags
- **Examples** for complex features
- **Table of contents** for long docs

---

## Testing

### Manual Testing
1. **Theme Installation**
   - Apply theme and verify colors
   - Check wallpaper loads correctly
   - Test icon visibility in File Explorer

2. **Launcher Testing**
   - Launch without errors
   - Test each quick-launch button
   - Monitor system metrics update
   - Verify GPU detection (if applicable)

3. **Script Testing**
   - Backup/restore cycle
   - GPU driver installation
   - ISO building (requires ADK)

### Automated Testing (Future)
- Unit tests for Python modules
- Integration tests for scripts
- Theme validation tests

---

## Releasing Updates

### Version Numbering
Format: `MAJOR.MINOR.PATCH`
- **MAJOR**: Breaking changes, major theme overhaul
- **MINOR**: New features, launcher additions
- **PATCH**: Bug fixes, optimization

### Release Checklist
- [ ] Update version in all relevant files
- [ ] Update `CHANGELOG.md`
- [ ] Test installation from scratch
- [ ] Test backup/restore cycle
- [ ] Verify theme applies correctly
- [ ] Test AI prompt generation
- [ ] Build & test ISO creation
- [ ] Create release notes on GitHub

---

## Future Enhancements (Roadmap)

- [ ] **Mobile Integration**: Sync settings to phone
- [ ] **Cloud Backup**: Automatic cloud backup integration
- [ ] **More AI Providers**: Support Claude, Gemini, etc.
- [ ] **Rainmeter Skins**: Advanced system widgets
- [ ] **Animated Wallpapers**: Lively Wallpaper integration
- [ ] **Custom Sounds**: Sweet Apocalypse audio theme
- [ ] **Community Themes**: Allow user theme sharing
- [ ] **Update Manager**: In-app update system

---

## Community Guidelines

- **Be Respectful**: All contributions welcomed
- **Clear Commits**: Write descriptive commit messages
- **Documentation**: Include docs for new features
- **Testing**: Test before submitting changes
- **Attribution**: Credit original creators/sources

---

## Contact & Questions

- **Main Contact**: Waya Steurbaut (wayasteurbautsongs@gmail.com)
- **GitHub Issues**: For bug reports & feature requests
- **Discussions**: For general questions & ideas

---

## License

All contributions must comply with **MIT License** (see LICENSE file).

By contributing, you agree your work will be licensed under the same terms.

---

**Thank you for contributing to Waya-OS: Aqua Jarvis Edition!** 🌈✨
