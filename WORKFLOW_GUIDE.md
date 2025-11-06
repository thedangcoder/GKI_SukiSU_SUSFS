# Hướng Dẫn Sử Dụng GitHub Workflow

## 📋 Mục Lục

1. [Giới Thiệu](#giới-thiệu)
2. [Cài Đặt GitHub CLI](#cài-đặt-github-cli)
3. [Chạy Workflow](#chạy-workflow)
4. [Hai Loại Build](#hai-loại-build)
5. [Tải Kết Quả Build](#tải-kết-quả-build)
6. [Xử Lý Lỗi](#xử-lý-lỗi)

---

## 🎯 Giới Thiệu

Repository này có 2 workflow để build kernel GKI 5.10.245 cho Evolution X ROM:

- **build-kernel.yml**: Build kernel hoàn chỉnh với KernelSU và SUSFS tích hợp
- **build-lkm.yml**: Build KernelSU LKM module (nhanh hơn, không cần build lại kernel)

---

## 💻 Cài Đặt GitHub CLI

Bạn đã cài đặt GitHub CLI rồi. Kiểm tra version:

```powershell
gh --version
```

Đăng nhập GitHub (nếu chưa):

```powershell
gh auth login
```

---

## 🚀 Chạy Workflow

### Cách 1: Build Kernel Hoàn Chỉnh (Khuyên Dùng)

Build kernel GKI hoàn chỉnh với KernelSU và SUSFS:

```powershell
# Build với cấu hình mặc định
gh workflow run build-kernel.yml

# Build với tùy chỉnh version
gh workflow run build-kernel.yml -f kernel_version=5.10.245 -f kernelsu_version=main -f susfs_version=gki-android12-5.10
```

**Thời gian build:** ~30-45 phút

**Kết quả:** File zip AnyKernel3 có thể flash qua recovery hoặc fastboot

### Cách 2: Build KernelSU LKM (Nhanh)

Build module KernelSU dạng LKM (không cần build lại kernel):

```powershell
# Build LKM với cấu hình mặc định
gh workflow run build-lkm.yml

# Build LKM với version cụ thể
gh workflow run build-lkm.yml -f kernel_version=5.10.245

# Build và tạo release với tag
gh workflow run build-lkm.yml -f kernel_version=5.10.245 -f tag=v1.0.0
```

**Thời gian build:** ~10-15 phút

**Kết quả:** Module .ko có thể load vào kernel stock

---

## 📊 Hai Loại Build

### Build Kernel Hoàn Chỉnh (`build-kernel.yml`)

**Ưu điểm:**
- ✅ Tích hợp sẵn KernelSU vào kernel
- ✅ Tích hợp SUSFS vào kernel
- ✅ Tối ưu hóa cho Evolution X
- ✅ Hỗ trợ đầy đủ tính năng
- ✅ Ổn định hơn

**Nhược điểm:**
- ❌ Thời gian build lâu (~30-45 phút)
- ❌ Cần flash kernel mới (có thể bootloop nếu không tương thích)
- ❌ Tốn tài nguyên GitHub Actions

**Cách sử dụng:**
```powershell
# Chạy workflow
gh workflow run build-kernel.yml

# Xem trạng thái
gh run list --workflow=build-kernel.yml

# Tải kết quả khi build xong
gh run download <RUN_ID>
```

**Flash kernel:**
1. Tải file `GKI-5.10.245-KernelSU-SUSFS-EvolutionX-*.zip`
2. Reboot vào recovery mode
3. Flash file zip
4. Reboot system

### Build KernelSU LKM (`build-lkm.yml`)

**Ưu điểm:**
- ✅ Build nhanh (~10-15 phút)
- ✅ Không cần flash kernel mới
- ✅ Dễ cài đặt/gỡ bỏ
- ✅ An toàn hơn (ít rủi ro bootloop)
- ✅ Tiết kiệm tài nguyên

**Nhược điểm:**
- ❌ Cần kernel GKI stock tương thích
- ❌ Một số tính năng có thể bị giới hạn
- ❌ Cần load module mỗi lần boot

**Cách sử dụng:**
```powershell
# Chạy workflow
gh workflow run build-lkm.yml

# Xem trạng thái
gh run list --workflow=build-lkm.yml

# Tải kết quả
gh run download <RUN_ID>
```

**Cài đặt module:**
1. Tải file `KernelSU-LKM-SUSFS-5.10.245-*.zip`
2. Flash qua Magisk/KernelSU Manager
3. Hoặc chạy `install.sh` trong zip qua root shell
4. Reboot

---

## 📥 Tải Kết Quả Build

### Xem danh sách workflow runs

```powershell
# Xem tất cả runs
gh run list

# Xem runs của workflow cụ thể
gh run list --workflow=build-kernel.yml
gh run list --workflow=build-lkm.yml

# Xem chi tiết một run
gh run view <RUN_ID>
```

### Theo dõi tiến trình build

```powershell
# Xem log real-time
gh run watch <RUN_ID>

# Xem log của workflow vừa chạy
gh run watch
```

### Tải artifacts

```powershell
# Tải artifacts của run gần nhất
gh run download

# Tải artifacts của run cụ thể
gh run download <RUN_ID>

# Tải vào thư mục cụ thể
gh run download <RUN_ID> -D ./downloads
```

### Tải từ Releases

Nếu bạn tạo release với tag:

```powershell
# Xem danh sách releases
gh release list

# Tải release mới nhất
gh release download

# Tải release cụ thể
gh release download v1.0.0
```

---

## 🔧 Tùy Chỉnh Build

### Build Kernel với Parameters

```powershell
# Cú pháp: gh workflow run <workflow> -f <field>=<value>

gh workflow run build-kernel.yml \
  -f kernel_version=5.10.245 \
  -f kernelsu_version=main \
  -f susfs_version=gki-android12-5.10 \
  -f build_lkm=true
```

**Parameters:**
- `kernel_version`: Version kernel GKI (mặc định: 5.10.245)
- `kernelsu_version`: Branch/tag của KernelSU (mặc định: main)
- `susfs_version`: Branch của SUSFS (mặc định: gki-android12-5.10)
- `build_lkm`: Build LKM module (true/false)

### Build LKM với Parameters

```powershell
gh workflow run build-lkm.yml \
  -f kernel_version=5.10.245 \
  -f tag=v1.0.0
```

**Parameters:**
- `kernel_version`: Version kernel GKI (mặc định: 5.10.245)
- `tag`: Tag cho release (optional, nếu muốn tạo release)

---

## ⚠️ Xử Lý Lỗi

### Workflow không chạy

```powershell
# Kiểm tra workflow có tồn tại không
gh workflow list

# Kiểm tra quyền repository
gh auth status

# Enable workflow nếu bị disabled
gh workflow enable build-kernel.yml
gh workflow enable build-lkm.yml
```

### Build thất bại

```powershell
# Xem log chi tiết
gh run view <RUN_ID> --log

# Download log để phân tích
gh run view <RUN_ID> --log > build.log
```

**Lỗi thường gặp:**

1. **Out of disk space**
   - Workflow sử dụng ~20GB cho build kernel hoàn chỉnh
   - Giải pháp: Dùng build-lkm.yml thay thế

2. **Kernel source không tải được**
   - Do network issue với Google source
   - Giải pháp: Re-run workflow

3. **Module build failed**
   - Do version không tương thích
   - Giải pháp: Kiểm tra lại kernel_version và susfs_version

### Artifacts không tải được

```powershell
# Kiểm tra artifacts có tồn tại không
gh run view <RUN_ID>

# Artifacts có thể đã hết hạn (90 ngày mặc định)
# Giải pháp: Build lại hoặc dùng releases
```

---

## 📱 Cài Đặt Trên Thiết Bị

### Chuẩn Bị

1. **Backup dữ liệu quan trọng**
2. **Unlock bootloader**
3. **Cài đặt custom recovery (TWRP/OrangeFox)**
4. **Hoặc có fastboot/adb tools**

### Cài Đặt Kernel Hoàn Chỉnh

**Qua Recovery:**
```
1. Tải GKI-5.10.245-KernelSU-SUSFS-EvolutionX-*.zip
2. Copy vào thẻ nhớ/internal storage
3. Reboot vào recovery
4. Install > Chọn file zip
5. Flash
6. Reboot system
```

**Qua Fastboot:**
```powershell
# Extract Image từ zip
unzip GKI-5.10.245-*.zip
cd AnyKernel3

# Flash boot image
adb reboot bootloader
fastboot flash boot Image
fastboot reboot
```

### Cài Đặt KernelSU LKM

**Qua Magisk Manager:**
```
1. Mở Magisk/KernelSU Manager
2. Modules > Install from storage
3. Chọn KernelSU-LKM-SUSFS-*.zip
4. Reboot
```

**Qua ADB:**
```powershell
# Push file lên thiết bị
adb push KernelSU-LKM-SUSFS-*.zip /sdcard/

# Vào shell với root
adb shell
su

# Extract và chạy install script
cd /sdcard
unzip KernelSU-LKM-SUSFS-*.zip -d /data/local/tmp
cd /data/local/tmp
sh install.sh
reboot
```

### Sau Khi Cài Đặt

1. **Tắt Global Umount:**
   ```
   Mở KernelSU Manager > Settings > Global Umount > OFF
   ```

2. **Kiểm tra KernelSU hoạt động:**
   ```powershell
   adb shell
   su
   # Nếu có prompt root => thành công
   ```

3. **Kiểm tra kernel version:**
   ```powershell
   adb shell cat /proc/version
   # Nên thấy 5.10.245-gki
   ```

4. **Kiểm tra module:**
   ```powershell
   adb shell lsmod | grep -E "kernelsu|susfs"
   ```

---

## 🆘 Troubleshooting

### Bootloop sau khi flash kernel

**Nguyên nhân:**
- Kernel không tương thích với ROM/device
- SUSFS conflict với system apps
- Không tắt Global Umount

**Giải pháp:**
```
1. Reboot vào recovery
2. Flash lại stock boot.img
3. Hoặc flash ROM lại (wipe không cần thiết)
```

### WiFi/Cellular không hoạt động

**Nguyên nhân:**
- SUSFS umount system services

**Giải pháp:**
```
1. Reboot vào recovery
2. Mount system
3. Hoặc flash stock boot.img tạm thời
4. Boot vào system
5. Mở KernelSU Manager
6. Settings > Tắt Global Umount
7. Flash lại kernel với SUSFS
```

### KernelSU Manager không nhận kernel

**Nguyên nhân:**
- LKM chưa được load
- Kernel không có KernelSU

**Giải pháp:**
```powershell
# Kiểm tra module
adb shell lsmod | grep kernelsu

# Load module thủ công
adb shell
su
insmod /data/adb/ksu/modules/kernelsu.ko
```

### Build fails trên GitHub Actions

**Nguyên nhân:**
- Out of disk space
- Network timeout
- Source code không tương thích

**Giải pháp:**
```powershell
# Re-run workflow
gh run rerun <RUN_ID>

# Hoặc re-run failed jobs only
gh run rerun <RUN_ID> --failed

# Nếu vẫn fail, thử build LKM
gh workflow run build-lkm.yml
```

---

## 📚 Tài Nguyên Bổ Sung

- **KernelSU:** https://kernelsu.org/
- **SUSFS:** https://gitlab.com/simonpunk/susfs4ksu
- **GKI Documentation:** https://source.android.com/docs/core/architecture/kernel/generic-kernel-image
- **Evolution X:** https://evolution-x.org/

---

## 🤝 Đóng Góp

Nếu gặp vấn đề hoặc muốn cải thiện workflow:

```powershell
# Fork repo này
gh repo fork

# Tạo branch mới
git checkout -b feature/improvement

# Commit changes
git commit -am "Improve workflow"

# Push và tạo PR
git push origin feature/improvement
gh pr create
```

---

## 📝 Changelog

### Version 1.0 (Initial Release)
- ✅ Build workflow cho kernel GKI 5.10.245
- ✅ Build workflow cho KernelSU LKM
- ✅ Tích hợp SUSFS
- ✅ Tối ưu cho Evolution X ROM
- ✅ Support GitHub Actions

---

**Happy Building! 🚀**

