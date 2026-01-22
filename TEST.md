# Testing Waya-OS Aqua-Jarvis on Virtual Machines

This guide will help you test Waya-OS Aqua-Jarvis on VirtualBox or VMware using a bootable USB drive created with Rufus.

## Prerequisites

- **Host Machine**: Windows 10/11 with at least 8GB RAM
- **Virtual Machine Software**: 
  - VirtualBox (Free) - [Download](https://www.virtualbox.org/wiki/Downloads)
  - VMware Workstation Player (Free) - [Download](https://www.vmware.com/products/workstation/workstation-player/free)
- **Rufus** (USB bootable creator) - [Download](https://rufus.ie/)
- **USB Drive**: Minimum 8GB capacity (data will be erased)
- **Waya-OS ISO File**: Build or obtain the ISO image

## Step 1: Create a Bootable USB Drive with Rufus

### 1.1 Prepare Your USB Drive
1. Connect your USB drive (8GB or larger) to your computer
2. **BACKUP any important data** - the drive will be formatted
3. Note the USB drive letter (e.g., E:, F:)

### 1.2 Download and Launch Rufus
1. Download Rufus from [rufus.ie](https://rufus.ie/)
2. Run `rufus-X.X.exe` (no installation needed)
3. Grant administrator privileges when prompted

### 1.3 Configure Rufus Settings
1. **Device**: Select your USB drive from the dropdown
2. **Boot Selection**: Click SELECT and choose the Waya-OS ISO file
3. **Partition Scheme**: 
   - For UEFI systems: **GPT**
   - For Legacy BIOS: **MBR**
4. **Target System**:
   - For UEFI: **UEFI (non-CSM)**
   - For Legacy: **BIOS or UEFI**
5. **File System**: **FAT32** (or NTFS if ISO is larger than 4GB)
6. **Cluster Size**: Default
7. **Volume Label**: `Waya-OS` (optional)

### 1.4 Create the Bootable USB
1. Click **START**
2. If prompted about additional options, choose appropriate settings
3. Click **OK** to confirm (this will erase the USB drive)
4. Wait for the process to complete (usually 5-15 minutes)
5. You'll see a success message when complete

---

## Step 2: Test on VirtualBox

### 2.1 Create a New Virtual Machine
1. Open VirtualBox
2. Click **New** to create a new VM
3. Configure as follows:
   - **Name**: `Waya-OS-Test`
   - **Type**: Linux (or Windows, depending on base OS)
   - **Version**: Select appropriate version
   - **Memory**: 4GB (4096 MB) minimum
   - **Hard Disk**: Create a new virtual disk (30GB recommended)
   - **Disk Type**: VDI or VMDK
   - **Storage**: Dynamically allocated

### 2.2 Configure VM Settings
1. Right-click the new VM and select **Settings**
2. Go to **System → Motherboard**:
   - Enable **EFI** if using GPT USB
   - Set **Boot Order**: USB first, then Hard Disk
3. Go to **Storage**:
   - Select the **IDE/SATA Controller**
   - Click the empty disk icon
   - Click the disk icon and browse to select your USB drive or ISO
4. Go to **Network**:
   - Enable **Adapter 1** (NAT or Bridged Adapter)

### 2.3 Boot from USB
1. Select the VM and click **Start**
2. Press **Del** or **F2** during boot to enter BIOS (if needed)
3. The VM should boot from your USB drive
4. Follow the Waya-OS installation wizard
5. Complete the installation process

### 2.4 Post-Installation Testing
- Verify all system components load correctly
- Test the AI-Powered Aqua-Jarvis interface
- Check hardware acceleration (GPU support)
- Validate network connectivity
- Test any custom features or integrations

---

## Step 3: Test on VMware Workstation Player

### 3.1 Create a New Virtual Machine
1. Open VMware Workstation Player
2. Click **Create a New Virtual Machine**
3. Select **Custom (Advanced)**
4. Configure as follows:
   - **Guest Operating System**: Linux or Windows (match your ISO)
   - **Virtual Machine Name**: `Waya-OS-Test`
   - **Location**: Choose a folder with enough space
   - **Processors**: 2-4 cores minimum
   - **Memory**: 4GB (4096 MB) minimum
   - **Network Type**: NAT or Bridged
   - **Hard Disk**: Create new virtual disk (30GB recommended)

### 3.2 Configure Boot Settings
1. Go to VM Settings (Player → Manage → Virtual Machine Settings)
2. **Hardware → CD/DVD (IDE)**:
   - Select **Use physical drive** OR **Use ISO image file**
   - If using USB, select **Use physical drive** and choose your USB device
   - If using ISO, browse and select the Waya-OS ISO file
3. **Boot Options**:
   - Set boot order with CD/DVD first
4. **System Settings**:
   - Enable **Accelerate 3D graphics** (if applicable)

### 3.3 Boot the VM
1. Click **Play virtual machine**
2. The VM should boot from your USB drive or ISO
3. Follow the Waya-OS installation wizard
4. Allow sufficient time for installation (20-45 minutes typically)

### 3.4 Post-Installation Configuration
- Install VMware Tools for better performance
- Update all system drivers
- Test all Waya-OS features
- Verify performance and stability

---

## Step 4: Verification Checklist

After installation on either platform, verify the following:

### System Boot
- [ ] System boots successfully
- [ ] Aqua-Jarvis interface loads without errors
- [ ] Desktop renders correctly

### Hardware Detection
- [ ] Storage drives recognized
- [ ] RAM fully detected
- [ ] Graphics accelerated (GPU)
- [ ] Network adapters functional

### Feature Testing
- [ ] AI features responding correctly
- [ ] UI elements interactive and responsive
- [ ] File management working
- [ ] Application launcher functional

### Network & Connectivity
- [ ] Internet connection working
- [ ] DNS resolution successful
- [ ] External services accessible

### Performance
- [ ] System responsive
- [ ] No lag in UI interactions
- [ ] Memory usage reasonable
- [ ] CPU usage normal

---

## Troubleshooting

### VM Won't Boot from USB
- **VirtualBox**: Ensure USB Controller is enabled in Settings → USB
- **VMware**: Make sure the physical USB device is selected, not the ISO
- Check BIOS boot order settings within the VM

### USB Not Detected in Rufus
- Use different USB port
- Try another USB drive
- Run Rufus as Administrator
- Restart your computer

### Installation Freezes
- Increase VM RAM to 6-8GB
- Check for hardware compatibility
- Disable 3D acceleration temporarily
- Try different virtual disk size

### Poor Performance
- Allocate more CPU cores (4+)
- Increase RAM to 6-8GB
- Enable 3D graphics acceleration
- Use SSD for virtual machine storage

### ISO File Too Large
- In Rufus, use **NTFS** file system instead of FAT32
- Ensure USB drive is 16GB or larger

---

## Useful Commands

### From Host Machine (PowerShell)
```powershell
# List connected USB drives
Get-Volume

# Eject USB drive safely
$removalDrive = New-Object System.IO.DriveInfo("E:")
$removalDrive.VolumeLabel

# Check USB drive size
Get-Volume | Where-Object {$_.DriveType -eq 'Removable'}
```

### Inside VM (if Linux-based)
```bash
# Check system info
uname -a

# List hardware
lspci
lsusb

# Monitor resources
top
free -h
df -h
```

---

## After Successful Testing

Once you've verified everything works:

1. **Document any issues** encountered during testing
2. **Note compatibility** with your hardware
3. **Record performance metrics** if applicable
4. **Update project documentation** with findings
5. **Commit changes** to git repository
6. **Prepare for production deployment**

---

## Additional Resources

- [VirtualBox Manual](https://www.virtualbox.org/manual/UserManual.html)
- [VMware Knowledge Base](https://kb.vmware.com/)
- [Rufus Documentation](https://rufus.ie/en/)
- [Waya-OS Documentation](README.md)

---

**Last Updated**: January 2026
**Version**: 1.0
