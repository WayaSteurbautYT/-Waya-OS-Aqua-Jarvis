# TESTING_CHECKLIST.md - Pre-Launch Testing & Verification

## ✅ Quality Assurance Checklist

Before publishing Waya-OS to the world, verify everything works!

---

## 📋 Pre-Testing Verification

### File Integrity Check
```powershell
# Verify all required files exist
Get-ChildItem "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis" -Recurse | 
  Where-Object {$_.PSIsContainer -eq $false} | 
  Measure-Object | 
  Select-Object -ExpandProperty Count

# Should show 35+ files
```

### File Size Validation
```powershell
# Check project size
Get-ChildItem "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis" -Recurse |
  Measure-Object -Property Length -Sum |
  Select-Object -ExpandProperty Sum

# Typical: 50-100 MB (before ISO building)
```

### JSON Validation
```powershell
# Verify all JSON files are valid
$jsonFiles = Get-ChildItem -Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis" `
  -Filter "*.json" -Recurse

foreach ($file in $jsonFiles) {
    try {
        $content = Get-Content $file.FullName | ConvertFrom-Json
        Write-Host "✓ $($file.Name) - Valid JSON"
    } catch {
        Write-Host "✗ $($file.Name) - INVALID JSON"
        Write-Host $_.Exception.Message
    }
}
```

---

## 🔧 Component Testing

### 1. Python Files Testing

**Test Launcher**:
```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Check Python syntax
python -m py_compile launcher\aqua_jarvis.py
# Output: No errors = Good ✓

# Check imports
python -c "import tkinter, psutil; print('✓ Dependencies available')"

# Dry run (don't launch GUI)
python -m launcher.aqua_jarvis --verify-only
# Output: Configuration loaded, all good
```

**Test AI Engine**:
```powershell
# Verify prompt engine
python -m ai_context.prompt_engine --test

# Expected output:
# ✓ Chat history loaded
# ✓ Prompt templates ready
# ✓ VS Code integration configured
```

### 2. PowerShell Scripts Testing

**Test Installer**:
```powershell
# Check syntax without executing
Test-Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\install.bat"
# Output: True

# Verify it's a valid batch file
Select-String -Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\install.bat" `
  -Pattern "@echo off" | 
  Measure-Object | 
  Select-Object -ExpandProperty Count
# Output: 1+ (contains valid batch header)
```

**Test Backup Script**:
```powershell
# Verify backup script syntax
Get-Content "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\scripts\backup\backup_system.ps1" |
  ForEach-Object { if ($_ -like "param(*") { Write-Host "✓ Parameters defined" } }

# Check for required functions
Select-String -Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\scripts\backup\backup_system.ps1" `
  -Pattern "function Create-Backup" | 
  Measure-Object | 
  Select-Object -ExpandProperty Count
# Output: 1+ (function exists)
```

**Test ISO Builder**:
```powershell
# Verify ISO builder script exists
Test-Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\iso_builder\build_iso.ps1"
# Output: True

# Verify script has valid parameter blocks
Select-String -Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\iso_builder\build_iso.ps1" `
  -Pattern "param(" | 
  Measure-Object | 
  Select-Object -ExpandProperty Count
# Output: 1+ (has parameters)
```

### 3. Theme File Testing

**Test Windows Theme**:
```powershell
# Verify theme file syntax
Test-Path "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\theme\WayaOS_AquaJarvis.theme"
# Output: True

# Check for required sections
$themeContent = Get-Content "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\theme\WayaOS_AquaJarvis.theme"
$sections = @('[VisualStyles]', '[Colors]', '[Metrics]')
foreach ($section in $sections) {
    if ($themeContent -join "`n" -match $section) {
        Write-Host "✓ Section [$section] found"
    }
}
```

### 4. VS Code Configuration Testing

**Validate VS Code Settings**:
```powershell
# Check VS Code settings syntax
python -c "
import json
with open(r'C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\vscode_config\settings.json') as f:
    try:
        data = json.load(f)
        print(f'✓ VS Code settings valid ({len(data)} properties)')
    except json.JSONDecodeError as e:
        print(f'✗ Invalid JSON: {e}')
"
```

---

## 📀 ISO Testing

### Pre-ISO Building
```powershell
# Verify Windows ADK is installed
$adkPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit"
if (Test-Path $adkPath) {
    Write-Host "✓ Windows ADK installed"
} else {
    Write-Host "✗ Windows ADK missing - install from Microsoft"
}

# Verify DISM is available
dism | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ DISM available"
}

# Check disk space
$drive = Get-PSDrive -Name C
$freeSpace = $drive.Free / 1GB
if ($freeSpace -gt 20) {
    Write-Host "✓ Sufficient disk space ($($freeSpace)GB free)"
} else {
    Write-Host "✗ Insufficient disk space (need 20GB+ free)"
}
```

### Build ISO
```powershell
cd "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis"

# Run ISO builder with all features
.\iso_builder\build_iso.ps1 -IncludeLauncher -IncludeVSCode -IncludeGPUDrivers

# Monitor progress
# Expected duration: 20-30 minutes
# Output file: iso_builder\output\WayaOS_AquaJarvis_v1.iso (4-6 GB)
```

### Verify ISO File
```powershell
# Check ISO was created
$isoPath = "C:\Users\steur\Pictures\Waya-OS_Aqua-Jarvis\iso_builder\output\WayaOS_AquaJarvis_v1.iso"
if (Test-Path $isoPath) {
    $size = (Get-Item $isoPath).Length / 1GB
    Write-Host "✓ ISO created successfully ($([Math]::Round($size, 2)) GB)"
} else {
    Write-Host "✗ ISO build failed"
}

# Verify ISO integrity (optional)
# Use: certutil -hashfile WayaOS_AquaJarvis_v1.iso SHA256
```

---

## 🧪 Functional Testing

### Manual Testing on Real System

#### Phase 1: Pre-Installation (20 minutes)

- [ ] Download ISO successfully
- [ ] ISO file size: 4-6 GB ✓
- [ ] Can open ISO with Windows (built-in mounting)
- [ ] Theme files visible inside ISO
- [ ] Launcher files present
- [ ] Documentation accessible

#### Phase 2: USB Creation (15 minutes)

- [ ] Download Rufus from rufus.ie
- [ ] Rufus installed and opens
- [ ] Select ISO file in Rufus
- [ ] Select USB device (verify correct drive!)
- [ ] Partition type: GPT
- [ ] File system: NTFS
- [ ] Start button works
- [ ] USB creation progress visible
- [ ] Completion message shows "✓ Ready"

#### Phase 3: Boot from USB (10 minutes)

**Computer A (Test Machine)**:
- [ ] Insert USB into computer
- [ ] Restart computer
- [ ] Enter BIOS (Del/F2/F10 during startup)
- [ ] Change boot order to USB first
- [ ] Save and restart
- [ ] Windows 10/11/12 installer appears

#### Phase 4: Installation (45 minutes)

- [ ] Windows installer launches
- [ ] License agreement shows
- [ ] Installation type: Custom/Fresh Install
- [ ] Drive selection works
- [ ] Installation progress visible
- [ ] Computer restarts automatically
- [ ] No errors during installation
- [ ] Installation completes (30-40 min)
- [ ] First boot into new Windows

#### Phase 5: Post-Installation Verification (30 minutes)

**Theme Application**:
- [ ] Dark theme applied to desktop
- [ ] Aquamarine accents visible
- [ ] Taskbar colors correct
- [ ] Window borders styled

**Aqua Jarvis Launcher**:
- [ ] Launcher shortcut on desktop
- [ ] Launcher opens without errors
- [ ] System monitoring shows CPU/RAM/GPU
- [ ] All buttons are clickable
- [ ] Settings panel opens

**AI Integration**:
- [ ] VS Code installed (if selected)
- [ ] VS Code opens with Waya-OS theme
- [ ] Color scheme applied correctly
- [ ] Copilot extension available

**GPU Detection** (if NVIDIA):
- [ ] Device Manager shows NVIDIA GPU
- [ ] CUDA Toolkit installed
- [ ] `nvidia-smi` command works
- [ ] GPU memory visible

**Documentation**:
- [ ] START_HERE.md accessible
- [ ] All markdown files readable
- [ ] Links work correctly

#### Phase 6: Functionality Check (15 minutes)

- [ ] Computer doesn't crash
- [ ] Performance is good
- [ ] Fan noise reasonable
- [ ] No thermal issues
- [ ] WiFi/Network works
- [ ] Mouse/keyboard responsive
- [ ] Audio works

---

## 🔄 Rollback Testing

### Test Restore System
```powershell
# (Optional, only if you made a backup)

# Verify backup exists
$backupPath = "E:\Waya-OS-Backup"  # External drive
if (Test-Path $backupPath) {
    Write-Host "✓ Backup exists at $backupPath"
    Get-ChildItem $backupPath | Measure-Object | Select-Object -ExpandProperty Count
    # Should show 5+ backup folders
} else {
    Write-Host "✗ Backup location not found"
}

# Test restore (without actually restoring)
.\scripts\restore\restore_system.ps1 -VerifyOnly
# Output: Restoration path verified, ready to restore if needed
```

---

## 📊 Performance Testing

### Baseline Measurements

**Before Installation**:
```powershell
# Record baseline
$baseline = @{
    "Date" = Get-Date
    "CPU" = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    "RAM" = (Get-CimInstance CIM_OperatingSystem).FreePhysicalMemory / 1MB
    "Disk" = (Get-PSDrive C).Free / 1GB
}
$baseline | ConvertTo-Json | Out-File "baseline.json"
```

**After Installation**:
```powershell
# Compare performance
$after = @{
    "Date" = Get-Date
    "CPU" = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
    "RAM" = (Get-CimInstance CIM_OperatingSystem).FreePhysicalMemory / 1MB
    "Disk" = (Get-PSDrive C).Free / 1GB
}
$after | ConvertTo-Json | Out-File "after.json"

# Analysis: Disk usage should increase ~2-5 GB, RAM minimal impact
```

---

## 🐛 Bug Tracking Template

### If Issues Found

```
Issue:     [Describe problem]
Severity:  [Critical/High/Medium/Low]
Steps:     [How to reproduce]
Expected:  [What should happen]
Actual:    [What actually happens]
System:    [Windows version, GPU, RAM, etc.]
Solution:  [How to fix (if known)]

Example:
Issue:     Launcher window doesn't open
Severity:  Critical
Steps:     1. Boot system 2. Click Aqua Jarvis shortcut
Expected:  Launcher window appears
Actual:    Error message, launcher crashes
System:    Windows 11, RTX 3070, 32GB RAM
Solution:  Python dependencies missing, run: pip install -r requirements.txt
```

---

## ✨ Testing Timeline

```
Week 1 (Before Publishing):
  Day 1-2: File integrity check ✓
  Day 3-4: Component testing (Python, PowerShell) ✓
  Day 5-6: ISO building & verification
  Day 7: Full installation test on test machine

Week 2:
  Day 8-10: Functional testing
  Day 11-14: Performance monitoring
```

---

## 📋 Sign-Off Checklist

### Phase 1: Code Quality ✓
- [ ] All Python files have valid syntax
- [ ] All PowerShell scripts are valid
- [ ] All JSON files are well-formed
- [ ] No hardcoded passwords/API keys
- [ ] Comments explain complex logic
- [ ] No compiler warnings

### Phase 2: Documentation ✓
- [ ] All guides are complete
- [ ] Instructions are clear
- [ ] Examples are working
- [ ] Screenshots/diagrams accurate
- [ ] Links are valid
- [ ] No typos

### Phase 3: Functionality ✓
- [ ] ISO builds without errors
- [ ] Installation completes
- [ ] Theme applies correctly
- [ ] Launcher opens and works
- [ ] AI integration functional
- [ ] GPU detection works

### Phase 4: Safety ✓
- [ ] Backup system works
- [ ] Restore system verified
- [ ] No data loss during install
- [ ] Rollback possible
- [ ] No system corruption

### Phase 5: Performance ✓
- [ ] Minimal disk space usage
- [ ] RAM usage acceptable
- [ ] CPU impact minimal
- [ ] GPU properly utilized
- [ ] No thermal issues
- [ ] System responsive

### Phase 6: User Experience ✓
- [ ] Installation is straightforward
- [ ] Documentation helpful
- [ ] UI is intuitive
- [ ] No confusing steps
- [ ] Clear error messages
- [ ] Easy to get help

---

## 🚀 Ready to Publish?

**All tests passed?** ✓

Then you're ready to:
1. ✅ Create GitHub repository
2. ✅ Upload all files
3. ✅ Deploy website
4. ✅ Release on GitHub
5. ✅ Promote on social media

**If tests failed?**
- Document the issue (use template above)
- Fix the problem
- Retest that specific component
- Run full test suite again
- Document solution for future reference

---

## 📞 Getting Help

If tests fail, check:
1. **INSTALL.md** - Installation troubleshooting
2. **README.md** - Feature documentation
3. **GitHub Issues** - Community solutions
4. **START_HERE.md** - Quick answers

---

## 🎯 Final Note

This testing checklist ensures Waya-OS is production-ready and won't cause problems for users. Taking time to test thoroughly now saves debugging later!

Good testing = Happy users = Project success! ✨
