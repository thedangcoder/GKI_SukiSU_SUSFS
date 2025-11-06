# Build Script cho GKI Kernel
# Tac gia: GKI_SukiSU_SUSFS
# Muc dich: Chay GitHub Actions workflow de dang hon

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("kernel", "lkm", "both", "status", "download", "help")]
    [string]$Action = "help",
    
    [Parameter(Mandatory=$false)]
    [string]$KernelVersion = "5.10.245",
    
    [Parameter(Mandatory=$false)]
    [string]$Tag = ""
)

function Show-Help {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "       GKI Kernel Builder - GitHub Actions Workflow            " -ForegroundColor Cyan
    Write-Host "              Evolution X ROM - Kernel 5.10.245                 " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Cach su dung:" -ForegroundColor Yellow
    Write-Host "  .\build.ps1 -Action <action> [-KernelVersion <version>] [-Tag <tag>]"
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Yellow
    Write-Host "  kernel      - Build kernel hoan chinh (30-45 phut)"
    Write-Host "  lkm         - Build KernelSU LKM module (10-15 phut) [KHUYEN DUNG]"
    Write-Host "  both        - Build ca kernel va LKM"
    Write-Host "  status      - Xem trang thai builds"
    Write-Host "  download    - Tai ket qua build gan nhat"
    Write-Host "  help        - Hien thi huong dan nay"
    Write-Host ""
    Write-Host "Tham so:" -ForegroundColor Yellow
    Write-Host "  -KernelVersion   Kernel version (mac dinh: 5.10.245)"
    Write-Host "  -Tag             Tag cho release (optional)"
    Write-Host ""
    Write-Host "Vi du:" -ForegroundColor Yellow
    Write-Host "  # Build LKM (nhanh, khuyen dung)" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action lkm"
    Write-Host ""
    Write-Host "  # Build kernel hoan chinh" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action kernel"
    Write-Host ""
    Write-Host "  # Build voi version cu the" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action lkm -KernelVersion 5.10.245"
    Write-Host ""
    Write-Host "  # Build va tao release" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action kernel -Tag v1.0.0"
    Write-Host ""
    Write-Host "  # Xem trang thai builds" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action status"
    Write-Host ""
    Write-Host "  # Tai build gan nhat" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action download"
    Write-Host ""
}

function Test-GitHubCLI {
    try {
        $null = gh --version 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "GitHub CLI not found"
        }
        Write-Host "[OK] GitHub CLI da cai dat" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[ERROR] GitHub CLI chua duoc cai dat!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Cai dat GitHub CLI:" -ForegroundColor Yellow
        Write-Host "  winget install --id GitHub.cli"
        Write-Host "  hoac tai tu: https://cli.github.com/"
        return $false
    }
}

function Test-GitHubAuth {
    try {
        $null = gh auth status 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "Not authenticated"
        }
        Write-Host "[OK] Da dang nhap GitHub" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[ERROR] Chua dang nhap GitHub!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Dang nhap GitHub:" -ForegroundColor Yellow
        Write-Host "  gh auth login"
        return $false
    }
}

function Start-KernelBuild {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Dang khoi dong build KERNEL HOAN CHINH...                    " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[INFO] Thoi gian du kien: 30-45 phut" -ForegroundColor Yellow
    Write-Host "[INFO] Ket qua: GKI-5.10.245-KernelSU-SUSFS-EvolutionX.zip" -ForegroundColor Yellow
    Write-Host ""
    
    if ($Tag -ne "") {
        gh workflow run build-kernel.yml -f kernel_version=$KernelVersion -f tag=$Tag
        Write-Host "[OK] Workflow da duoc khoi dong voi tag: $Tag" -ForegroundColor Green
    }
    else {
        gh workflow run build-kernel.yml -f kernel_version=$KernelVersion
        Write-Host "[OK] Workflow da duoc khoi dong" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Theo doi tien trinh:" -ForegroundColor Cyan
    Write-Host "  .\build.ps1 -Action status"
    Write-Host "  hoac: gh run watch"
}

function Start-LKMBuild {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Dang khoi dong build KERNELSU LKM...                         " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "[INFO] Thoi gian du kien: 10-15 phut" -ForegroundColor Yellow
    Write-Host "[INFO] Ket qua: KernelSU-LKM-SUSFS-5.10.245.zip" -ForegroundColor Yellow
    Write-Host ""
    
    if ($Tag -ne "") {
        gh workflow run build-lkm.yml -f kernel_version=$KernelVersion -f tag=$Tag
        Write-Host "[OK] Workflow da duoc khoi dong voi tag: $Tag" -ForegroundColor Green
    }
    else {
        gh workflow run build-lkm.yml -f kernel_version=$KernelVersion
        Write-Host "[OK] Workflow da duoc khoi dong" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Theo doi tien trinh:" -ForegroundColor Cyan
    Write-Host "  .\build.ps1 -Action status"
    Write-Host "  hoac: gh run watch"
}

function Show-BuildStatus {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Trang thai Builds                                            " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "[*] Kernel Hoan Chinh:" -ForegroundColor Yellow
    gh run list --workflow=build-kernel.yml --limit 5
    
    Write-Host ""
    Write-Host "[*] KernelSU LKM:" -ForegroundColor Yellow
    gh run list --workflow=build-lkm.yml --limit 5
    
    Write-Host ""
    Write-Host "Xem chi tiet build:" -ForegroundColor Cyan
    Write-Host "  gh run view <RUN_ID>"
    Write-Host ""
    Write-Host "Theo doi real-time:" -ForegroundColor Cyan
    Write-Host "  gh run watch <RUN_ID>"
}

function Download-BuildArtifacts {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Dang tai Artifacts...                                        " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    $downloadDir = ".\build_output"
    
    if (-not (Test-Path $downloadDir)) {
        New-Item -ItemType Directory -Path $downloadDir | Out-Null
        Write-Host "[OK] Da tao thu muc: $downloadDir" -ForegroundColor Green
    }
    
    Write-Host "[INFO] Dang tai build gan nhat..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        gh run download -D $downloadDir
        Write-Host ""
        Write-Host "[OK] Tai thanh cong!" -ForegroundColor Green
        Write-Host "[INFO] File duoc luu tai: $downloadDir" -ForegroundColor Cyan
        Write-Host ""
        
        # Show downloaded files
        Write-Host "Files da tai:" -ForegroundColor Yellow
        Get-ChildItem -Path $downloadDir -Recurse -File | ForEach-Object {
            Write-Host "  - $($_.Name)"
        }
    }
    catch {
        Write-Host "[ERROR] Loi khi tai artifacts!" -ForegroundColor Red
        Write-Host "Co the build chua hoan tat hoac khong co artifacts." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Kiem tra trang thai:" -ForegroundColor Cyan
        Write-Host "  .\build.ps1 -Action status"
    }
}

# Main script
Clear-Host

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                                                                " -ForegroundColor Cyan
Write-Host "     GKI KERNEL BUILDER FOR EVOLUTION X                        " -ForegroundColor Cyan
Write-Host "     Kernel 5.10.245 + KernelSU + SUSFS                        " -ForegroundColor Cyan
Write-Host "                                                                " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# Check requirements
if (-not (Test-GitHubCLI)) {
    exit 1
}

if (-not (Test-GitHubAuth)) {
    exit 1
}

Write-Host ""

# Execute action
switch ($Action.ToLower()) {
    "kernel" {
        Start-KernelBuild
    }
    "lkm" {
        Start-LKMBuild
    }
    "both" {
        Write-Host "[*] Khoi dong ca 2 builds..." -ForegroundColor Cyan
        Write-Host ""
        Start-LKMBuild
        Start-Sleep -Seconds 2
        Start-KernelBuild
    }
    "status" {
        Show-BuildStatus
    }
    "download" {
        Download-BuildArtifacts
    }
    "help" {
        Show-Help
    }
    default {
        Show-Help
    }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
