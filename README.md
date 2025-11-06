# GKI Kernel 5.10.245 + KernelSU + SUSFS cho Evolution X

## 🚀 Build Tự Động với GitHub Actions

Repository này hỗ trợ build kernel GKI tự động qua GitHub Actions.

### Các Workflow Có Sẵn:

1. **Build Kernel Hoàn Chỉnh** (`build-kernel.yml`)
   - Build kernel GKI 5.10.245 với KernelSU và SUSFS tích hợp sẵn
   - Thời gian: ~30-45 phút
   - Kết quả: File AnyKernel3 zip có thể flash trực tiếp

2. **Build KernelSU LKM** (`build-lkm.yml`)  
   - Build module KernelSU dạng LKM (không cần build lại kernel)
   - Thời gian: ~10-15 phút
   - Kết quả: Module .ko có thể cài qua Magisk/KernelSU Manager

### Chạy Workflow (GitHub CLI):

```powershell
# Build kernel hoàn chỉnh
gh workflow run build-kernel.yml

# Build KernelSU LKM (nhanh hơn)
gh workflow run build-lkm.yml

# Xem trạng thái build
gh run list

# Tải kết quả build
gh run download
```

### Chạy Workflow (Giao diện Web):

1. Vào tab **Actions** trên GitHub
2. Chọn workflow muốn chạy
3. Click **Run workflow** > **Run workflow**
4. Đợi build hoàn tất (~10-45 phút)
5. Tải artifacts từ workflow run

## 📖 Hướng Dẫn Chi Tiết

Xem file [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) để biết hướng dẫn đầy đủ.

Xem file [QUICK_START_VI.md](QUICK_START_VI.md) để bắt đầu nhanh.

## ⚠️ Lưu Ý Quan Trọng

- **BẮT BUỘC**: Tắt "Global Umount" trong KernelSU Manager trước khi cài kernel
- Backup dữ liệu trước khi flash
- Chỉ dùng cho ROM tương thích GKI (Evolution X, v.v.)
- Kernel version: **5.10.245-gki**
- Hỗ trợ Android 12+

## 🛠️ Tính Năng

- ✅ KernelSU tích hợp
- ✅ SUSFS (SU File System) 
- ✅ Tối ưu cho Evolution X ROM
- ✅ Build tự động với GitHub Actions
- ✅ Hỗ trợ cả kernel full và LKM module

## 📱 Tương Thích

- ROM: Evolution X, LineageOS, và các ROM GKI khác
- Android: 12, 13, 14+
- Kernel: 5.10.245-gki
- Thiết bị: Các thiết bị hỗ trợ GKI

---

## 🇬🇧 English

# GKI Kernel 5.10.245 + KernelSU + SUSFS for Evolution X

## 🚀 Automated Build with GitHub Actions

This repository supports automatic GKI kernel building via GitHub Actions.

### Available Workflows:

1. **Full Kernel Build** (`build-kernel.yml`)
   - Builds GKI 5.10.245 kernel with integrated KernelSU and SUSFS
   - Time: ~30-45 minutes
   - Output: AnyKernel3 zip file ready to flash

2. **KernelSU LKM Build** (`build-lkm.yml`)
   - Builds KernelSU as loadable kernel module
   - Time: ~10-15 minutes  
   - Output: .ko module installable via Magisk/KernelSU Manager

### Run Workflow (GitHub CLI):

```bash
# Build full kernel
gh workflow run build-kernel.yml

# Build KernelSU LKM (faster)
gh workflow run build-lkm.yml

# Check build status
gh run list

# Download build results
gh run download
```

### Run Workflow (Web Interface):

1. Go to **Actions** tab on GitHub
2. Select desired workflow
3. Click **Run workflow** > **Run workflow**
4. Wait for build completion (~10-45 minutes)
5. Download artifacts from workflow run

## 📖 Documentation

See [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) for full instructions.

See [QUICK_START_VI.md](QUICK_START_VI.md) for Vietnamese quick start.

## ⚠️ Important Notes

- **REQUIRED**: Disable "Global Umount" in KernelSU Manager before installing
- Backup your data before flashing
- Only for GKI-compatible ROMs (Evolution X, etc.)
- Kernel version: **5.10.245-gki**
- Android 12+ support

## 🛠️ Features

- ✅ Integrated KernelSU
- ✅ SUSFS (SU File System)
- ✅ Optimized for Evolution X ROM
- ✅ Automated GitHub Actions builds
- ✅ Full kernel and LKM module support

## 📱 Compatibility

- ROMs: Evolution X, LineageOS, and other GKI ROMs
- Android: 12, 13, 14+
- Kernel: 5.10.245-gki
- Devices: GKI-compatible devices