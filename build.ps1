# Build Script cho GKI Kernel
# Tac gia: GKI_SukiSU_SUSFS
# Muc dich: Chay GitHub Actions workflow de dang hon

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("a12-510", "a13-510", "a13-515", "a14-515", "a14-61", "a15-66", "all", "status", "download", "help")]
    [string]$Action = "help",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("SukiSU")]
    [string]$KernelSU = "SukiSU",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Stable", "Dev", "Other")]
    [string]$Branch = "Dev",
    
    [Parameter(Mandatory=$false)]
    [string]$CustomBranch = "",
    
    [Parameter(Mandatory=$false)]
    [bool]$MakeRelease = $true
)

function Show-Help {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "       GKI Kernel Builder - GitHub Actions Workflow            " -ForegroundColor Cyan
    Write-Host "       Kernel 5.10.245 + SukiSU + SUSFS for Evolution X        " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Cach su dung:" -ForegroundColor Yellow
    Write-Host "  .\build.ps1 -Action <action> [-KernelSU <variant>] [-Branch <branch>]"
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Yellow
    Write-Host "  a12-510     - Build Android 12 5.10.245 (Evolution X) [KHUYEN DUNG]"
    Write-Host "  a13-510     - Build Android 13 5.10"
    Write-Host "  a13-515     - Build Android 13 5.15"
    Write-Host "  a14-515     - Build Android 14 5.15"
    Write-Host "  a14-61      - Build Android 14 6.1"
    Write-Host "  a15-66      - Build Android 15 6.6"
    Write-Host "  all         - Build tat ca versions"
    Write-Host "  status      - Xem trang thai builds"
    Write-Host "  download    - Tai ket qua build gan nhat"
    Write-Host "  help        - Hien thi huong dan nay"
    Write-Host ""
    Write-Host "Tham so:" -ForegroundColor Yellow
    Write-Host "  -KernelSU        KernelSU variant (mac dinh: SukiSU)"
    Write-Host "  -Branch          Branch: Stable, Dev, Other (mac dinh: Dev)"
    Write-Host "  -CustomBranch    Custom branch neu chon Other"
    Write-Host "  -MakeRelease     Tao release tu dong (mac dinh: true)"
    Write-Host ""
    Write-Host "Vi du:" -ForegroundColor Yellow
    Write-Host "  # Build Android 12 5.10.245 cho Evolution X" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action a12-510"
    Write-Host ""
    Write-Host "  # Build voi branch Stable" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action a12-510 -Branch Stable"
    Write-Host ""
    Write-Host "  # Build tat ca versions" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action all"
    Write-Host ""
    Write-Host "  # Xem trang thai builds" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action status"
    Write-Host ""
    Write-Host "  # Tai releases" -ForegroundColor Green
    Write-Host "  .\build.ps1 -Action download"
    Write-Host ""
    Write-Host "Thong tin kernel:" -ForegroundColor Yellow
    Write-Host "  - Android 12 5.10: Version 5.10.245 (Evolution X optimized)"
    Write-Host "  - SukiSU: KernelSU variant toi uu"
    Write-Host "  - SUSFS: SU File System hiding"
    Write-Host "  - Auto release: Tao release tu dong tren GitHub"
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
    param(
        [string]$BuildType
    )
    
    $buildFlags = @{
        "a12-510" = @{ name = "Android 12 5.10.245 (Evolution X)"; flag = "build_a12_510"; time = "35-45 phut" }
        "a13-510" = @{ name = "Android 13 5.10"; flag = "build_a13_510"; time = "35-45 phut" }
        "a13-515" = @{ name = "Android 13 5.15"; flag = "build_a13_515"; time = "35-45 phut" }
        "a14-515" = @{ name = "Android 14 5.15"; flag = "build_a14_515"; time = "35-45 phut" }
        "a14-61"  = @{ name = "Android 14 6.1"; flag = "build_a14_61"; time = "35-45 phut" }
        "a15-66"  = @{ name = "Android 15 6.6"; flag = "build_a15_66"; time = "35-45 phut" }
    }
    
    if ($BuildType -eq "all") {
        Write-Host ""
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "  Dang khoi dong build TAT CA kernels...                       " -ForegroundColor Cyan
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "[WARNING] Build tat ca se mat rat nhieu thoi gian!" -ForegroundColor Yellow
        Write-Host ""
        
        gh workflow run build-kernel-release.yml `
            -f build_a12_510=true `
            -f build_a13_510=true `
            -f build_a13_515=true `
            -f build_a14_515=true `
            -f build_a14_61=true `
            -f build_a15_66=true `
            -f make_release=$MakeRelease `
            -f kernelsu_variant=$KernelSU `
            -f kernelsu_branch=$Branch `
            -f kernelsu_branch_other=$CustomBranch
    }
    else {
        $info = $buildFlags[$BuildType]
        
        Write-Host ""
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host "  Dang khoi dong build $($info.name)..." -ForegroundColor Cyan
        Write-Host "================================================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "[INFO] Thoi gian du kien: $($info.time)" -ForegroundColor Yellow
        Write-Host "[INFO] KernelSU: $KernelSU (Branch: $Branch)" -ForegroundColor Yellow
        Write-Host "[INFO] SUSFS: Enabled" -ForegroundColor Yellow
        Write-Host "[INFO] Auto Release: $MakeRelease" -ForegroundColor Yellow
        Write-Host ""
        
        # Build only selected version
        $params = @{}
        foreach ($key in $buildFlags.Keys) {
            $params[$buildFlags[$key].flag] = ($key -eq $BuildType)
        }
        
        gh workflow run build-kernel-release.yml `
            -f build_a12_510=$($params["build_a12_510"]) `
            -f build_a13_510=$($params["build_a13_510"]) `
            -f build_a13_515=$($params["build_a13_515"]) `
            -f build_a14_515=$($params["build_a14_515"]) `
            -f build_a14_61=$($params["build_a14_61"]) `
            -f build_a15_66=$($params["build_a15_66"]) `
            -f make_release=$MakeRelease `
            -f kernelsu_variant=$KernelSU `
            -f kernelsu_branch=$Branch `
            -f kernelsu_branch_other=$CustomBranch
    }
    
    Write-Host "[OK] Workflow da duoc khoi dong" -ForegroundColor Green
    Write-Host ""
    Write-Host "Theo doi tien trinh:" -ForegroundColor Cyan
    Write-Host "  .\build.ps1 -Action status"
    Write-Host "  hoac: gh run watch"
    Write-Host ""
    Write-Host "Xem tren web:" -ForegroundColor Cyan
    Write-Host "  gh workflow view build-kernel-release.yml --web"
}

function Show-BuildStatus {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Trang thai Builds                                            " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "[*] GKI Kernel Builds:" -ForegroundColor Yellow
    gh run list --workflow=build-kernel-release.yml --limit 10
    
    Write-Host ""
    Write-Host "Xem chi tiet build:" -ForegroundColor Cyan
    Write-Host "  gh run view <RUN_ID>"
    Write-Host ""
    Write-Host "Theo doi real-time:" -ForegroundColor Cyan
    Write-Host "  gh run watch <RUN_ID>"
    Write-Host ""
    Write-Host "Xem releases:" -ForegroundColor Cyan
    Write-Host "  gh release list"
}

function Download-BuildArtifacts {
    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Tai Releases...                                              " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "[INFO] Danh sach releases:" -ForegroundColor Yellow
    gh release list --limit 10
    
    Write-Host ""
    Write-Host "Tai release gan nhat:" -ForegroundColor Cyan
    Write-Host "  gh release download"
    Write-Host ""
    Write-Host "Tai release cu the:" -ForegroundColor Cyan
    Write-Host "  gh release download <tag>"
    Write-Host ""
    
    $choice = Read-Host "Ban co muon tai release gan nhat khong? (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        $downloadDir = ".\kernel_releases"
        
        if (-not (Test-Path $downloadDir)) {
            New-Item -ItemType Directory -Path $downloadDir | Out-Null
            Write-Host "[OK] Da tao thu muc: $downloadDir" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "[INFO] Dang tai release gan nhat..." -ForegroundColor Yellow
        
        try {
            gh release download -D $downloadDir
            Write-Host ""
            Write-Host "[OK] Tai thanh cong!" -ForegroundColor Green
            Write-Host "[INFO] Files duoc luu tai: $downloadDir" -ForegroundColor Cyan
            Write-Host ""
            
            # Show downloaded files
            Write-Host "Files da tai:" -ForegroundColor Yellow
            Get-ChildItem -Path $downloadDir -Recurse -File | ForEach-Object {
                Write-Host "  - $($_.Name) ($([math]::Round($_.Length/1MB, 2)) MB)" -ForegroundColor White
            }
        }
        catch {
            Write-Host "[ERROR] Loi khi tai release!" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
}

# Main script
Clear-Host

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                                                                " -ForegroundColor Cyan
Write-Host "     GKI KERNEL BUILDER FOR EVOLUTION X                        " -ForegroundColor Cyan
Write-Host "     Kernel 5.10.245 + SukiSU + SUSFS                          " -ForegroundColor Cyan
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
    "a12-510" { Start-KernelBuild -BuildType "a12-510" }
    "a13-510" { Start-KernelBuild -BuildType "a13-510" }
    "a13-515" { Start-KernelBuild -BuildType "a13-515" }
    "a14-515" { Start-KernelBuild -BuildType "a14-515" }
    "a14-61"  { Start-KernelBuild -BuildType "a14-61" }
    "a15-66"  { Start-KernelBuild -BuildType "a15-66" }
    "all"     { Start-KernelBuild -BuildType "all" }
    "status"  { Show-BuildStatus }
    "download" { Download-BuildArtifacts }
    "help"    { Show-Help }
    default   { Show-Help }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""
