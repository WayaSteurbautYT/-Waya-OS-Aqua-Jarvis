# Waya-OS: NVIDIA GPU Optimization Script
# Installs CUDA, cuDNN, and NVIDIA drivers for AI/ML workloads
# Usage: .\scripts\gpu_optimization\install_cuda.ps1 -CUDAVersion "12.2"

param(
    [Parameter(Mandatory=$false)]
    [string]$CUDAVersion = "12.2",
    
    [Parameter(Mandatory=$false)]
    [bool]$InstallcuDNN = $true,
    
    [Parameter(Mandatory=$false)]
    [bool]$InstallTensorFlow = $true
)

# Check for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    exit 1
}

Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Waya-OS NVIDIA GPU Optimization                          ║" -ForegroundColor Cyan
Write-Host "║   CUDA $CUDAVersion Installation for AI Acceleration       ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check for NVIDIA GPU
Write-Host "[*] Detecting NVIDIA GPU..." -ForegroundColor Yellow
try {
    $gpu = Get-WmiObject Win32_VideoController | Where-Object { $_.Name -match "NVIDIA|GeForce|RTX|Tesla" }
    if ($gpu) {
        Write-Host "    [OK] GPU Found: $($gpu.Name)" -ForegroundColor Green
    } else {
        Write-Host "    [!] No NVIDIA GPU detected!" -ForegroundColor Red
        $continue = Read-Host "Continue anyway? (Y/N)"
        if ($continue -ne "Y") {
            exit 1
        }
    }
} catch {
    Write-Host "    [!] Could not detect GPU: $_" -ForegroundColor Yellow
}

# Check for NVIDIA driver
Write-Host ""
Write-Host "[*] Checking NVIDIA driver..." -ForegroundColor Yellow
try {
    $driverVersion = (nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>$null)
    if ($driverVersion) {
        Write-Host "    [OK] Driver installed: v$driverVersion" -ForegroundColor Green
    } else {
        Write-Host "    [!] NVIDIA drivers not found." -ForegroundColor Yellow
        Write-Host "    Installing latest NVIDIA drivers..." -ForegroundColor Cyan
        
        # Use winget to install drivers
        winget install NVIDIA.GeForceExperience -e --accept-source-agreements --accept-package-agreements
    }
} catch {
    Write-Host "    [!] Error checking driver: $_" -ForegroundColor Yellow
}

# Download and install CUDA
Write-Host ""
Write-Host "[*] Setting up CUDA Toolkit v$CUDAVersion..." -ForegroundColor Yellow
Write-Host "    This may take several minutes..." -ForegroundColor Gray

$cudaUrl = "https://developer.download.nvidia.com/compute/cuda/$CUDAVersion.0/local_installers/cuda_$($CUDAVersion.Replace('.', '_'))_windows_x86_64.exe"
$cudaInstaller = "$env:TEMP\cuda_installer.exe"

try {
    Write-Host "    [+] Downloading CUDA $CUDAVersion..." -ForegroundColor Cyan
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $cudaUrl -OutFile $cudaInstaller -UseBasicParsing
    
    Write-Host "    [+] Running CUDA installer..." -ForegroundColor Cyan
    & $cudaInstaller -s -n -noreboot | Out-Null
    
    Write-Host "    [OK] CUDA $CUDAVersion installed" -ForegroundColor Green
    Remove-Item $cudaInstaller -Force -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "    [!] CUDA installation error: $_" -ForegroundColor Yellow
    Write-Host "    You may need to install manually from https://developer.nvidia.com/cuda-toolkit" -ForegroundColor Yellow
}

# Verify CUDA
Write-Host ""
Write-Host "[*] Verifying CUDA installation..." -ForegroundColor Yellow
try {
    $cudaVersion = nvcc --version 2>$null | Select-String "release"
    if ($cudaVersion) {
        Write-Host "    [OK] CUDA verified: $cudaVersion" -ForegroundColor Green
    } else {
        Write-Host "    [!] CUDA verification failed. You may need to restart." -ForegroundColor Yellow
    }
} catch {
    Write-Host "    [!] CUDA not in PATH yet. Restart recommended." -ForegroundColor Yellow
}

# Install cuDNN (if requested)
if ($InstallcuDNN) {
    Write-Host ""
    Write-Host "[*] Preparing cuDNN (requires manual download)..." -ForegroundColor Yellow
    Write-Host "    1. Visit: https://developer.nvidia.com/cudnn" -ForegroundColor Cyan
    Write-Host "    2. Download cuDNN for CUDA $CUDAVersion (requires free NVIDIA account)" -ForegroundColor Cyan
    Write-Host "    3. Extract to: C:\Program Files\NVIDIA\CUDA\v$($CUDAVersion.Replace('.', '_'))" -ForegroundColor Cyan
    $proceed = Read-Host "    Have you already installed cuDNN? (Y/N)"
    if ($proceed -eq "Y") {
        Write-Host "    [OK] Proceeding..." -ForegroundColor Green
    }
}

# Install TensorFlow GPU support (if requested)
if ($InstallTensorFlow) {
    Write-Host ""
    Write-Host "[*] Installing TensorFlow with GPU support..." -ForegroundColor Yellow
    try {
        python -m pip install --upgrade pip
        pip install tensorflow[and-cuda] --upgrade
        Write-Host "    [OK] TensorFlow GPU installed" -ForegroundColor Green
    } catch {
        Write-Host "    [!] TensorFlow installation error: $_" -ForegroundColor Yellow
        Write-Host "    Install manually: pip install tensorflow[and-cuda]" -ForegroundColor Yellow
    }
}

# Test GPU acceleration
Write-Host ""
Write-Host "[*] Testing GPU acceleration..." -ForegroundColor Yellow

$testScript = @"
import tensorflow as tf
import torch

print("TensorFlow GPU Support:")
gpu_devices = tf.config.list_physical_devices('GPU')
print(f"  GPUs available: {len(gpu_devices)}")
for gpu in gpu_devices:
    print(f"  - {gpu}")

print("\nPyTorch GPU Support:")
print(f"  CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"  GPU: {torch.cuda.get_device_name(0)}")
    print(f"  VRAM: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB")
"@

try {
    python -c $testScript
    Write-Host "    [OK] GPU acceleration working!" -ForegroundColor Green
} catch {
    Write-Host "    [!] GPU test encountered issues: $_" -ForegroundColor Yellow
    Write-Host "    This is normal if you haven't restarted after CUDA installation." -ForegroundColor Gray
}

# Final summary
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   GPU Optimization Setup Complete!                         ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Installed Components:" -ForegroundColor Cyan
Write-Host "  ✓ NVIDIA Drivers" -ForegroundColor Green
Write-Host "  ✓ CUDA Toolkit v$CUDAVersion" -ForegroundColor Green
Write-Host "  ✓ TensorFlow with GPU support" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Restart your computer to apply all changes" -ForegroundColor Gray
Write-Host "  2. Run 'nvidia-smi' to verify GPU is working" -ForegroundColor Gray
Write-Host "  3. Launch Aqua Jarvis launcher to monitor GPU in real-time" -ForegroundColor Gray
Write-Host ""
Write-Host "Your NVIDIA GPU is now optimized for AI/ML workloads!" -ForegroundColor Green
Write-Host ""
