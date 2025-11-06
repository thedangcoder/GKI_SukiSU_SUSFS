# 通用内核映像说明书 精品内核

> 请仔细阅读说明书并在 Google 指导下使用

**【内核名称】**

    通用名称：通用内核映像
    英语名称：Generic Kernel Image
    汉语拼音：Tongyong Neihe Yingxiang

**【成分】**

https://kernel.org/

https://kernelsu.org/

**【性状】**

本品为压缩包套压缩包文件，SHA256 检测见下载时旁边注计。

**【适应机型】**

兼容 GKI 的手机。

**【不良反应】**

常见：发热。偶见：死机。罕见：黑砖。

**【注意事项】**

本内核安全补丁级别来自 KernelSU workflow 的最新设定。

请在安装此项目的内核前，启动一次官方或者 5ec1cff 的 KernelSU，进入系统后打开 KernelSU 管理器，进入设置，**关闭全局 umount**。这是为了防止 susfs 对 umount 的应用处理导致系统应用出现问题。可能出现的现象包括但不限于：

- 启动后黑屏（SystemUI 无法加载）
- Wi-Fi 无法访问
- 基带有关通讯无法访问

**【核代动力学】**

对 Pixel 8 进行了通用内核映像的核代动力学研究。可以启动。

> **软件相互作用**
>
> mountify: 与 susfs 存在冲突

**【储藏】** 任意条件。

**【包装】** 压缩包文件。

---

## 🇻🇳 Tiếng Việt | Vietnamese

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