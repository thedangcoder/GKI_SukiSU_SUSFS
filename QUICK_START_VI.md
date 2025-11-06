# 🚀 Hướng Dẫn Nhanh - Build Kernel GKI cho Evolution X

## Bước 1: Chạy Workflow

### Cách 1: Dùng GitHub CLI (Nhanh nhất)

```powershell
# Mở PowerShell trong thư mục project
cd D:\Github\GKI_SukiSU_SUSFS

# Chạy build kernel hoàn chỉnh (khuyên dùng)
gh workflow run build-kernel.yml

# HOẶC chạy build LKM (nhanh hơn, 10-15 phút)
gh workflow run build-lkm.yml
```

### Cách 2: Dùng Giao Diện Web

1. Vào: https://github.com/[username]/GKI_SukiSU_SUSFS/actions
2. Chọn workflow: **"Build GKI Kernel 5.10.245 for Evolution X"** hoặc **"Build KernelSU LKM"**
3. Click nút **"Run workflow"** màu xanh
4. Click **"Run workflow"** lần nữa để xác nhận

---

## Bước 2: Theo Dõi Tiến Trình

```powershell
# Xem danh sách build
gh run list

# Theo dõi build real-time (lấy RUN_ID từ lệnh trên)
gh run watch <RUN_ID>
```

**Thời gian chờ:**
- Build kernel hoàn chỉnh: **30-45 phút** ☕
- Build KernelSU LKM: **10-15 phút** 🚀

---

## Bước 3: Tải Kết Quả

### Sau khi build xong:

```powershell
# Tải file build về
gh run download

# Hoặc tải run cụ thể
gh run download <RUN_ID>

# Hoặc tải vào thư mục cụ thể
gh run download <RUN_ID> -D ./build_output
```

### File nhận được:

**Kernel hoàn chỉnh:**
- `GKI-5.10.245-KernelSU-SUSFS-EvolutionX-[date].zip`

**KernelSU LKM:**
- `KernelSU-LKM-SUSFS-5.10.245-[date].zip`

---

## Bước 4: Cài Đặt Lên Điện Thoại

### A. Cài Kernel Hoàn Chỉnh

**Qua Custom Recovery (TWRP/OrangeFox):**

1. Copy file `GKI-5.10.245-*.zip` vào điện thoại
2. Reboot vào Recovery
3. Chọn **Install** → chọn file zip
4. **Swipe to Flash**
5. Reboot System

**Qua Fastboot:**

```powershell
# Giải nén file Image từ zip
unzip GKI-5.10.245-*.zip

# Flash kernel
adb reboot bootloader
fastboot flash boot Image
fastboot reboot
```

### B. Cài KernelSU LKM Module

**Qua Magisk/KernelSU Manager:**

1. Mở app Magisk hoặc KernelSU Manager
2. Vào tab **Modules**
3. Click **Install from storage**
4. Chọn file `KernelSU-LKM-SUSFS-*.zip`
5. Reboot

**Qua ADB:**

```powershell
# Push file lên điện thoại
adb push KernelSU-LKM-SUSFS-*.zip /sdcard/

# Cài qua shell
adb shell
su
cd /sdcard
unzip KernelSU-LKM-SUSFS-*.zip -d /data/local/tmp
cd /data/local/tmp
sh install.sh
reboot
```

---

## Bước 5: Cấu Hình Sau Cài Đặt

### ⚠️ QUAN TRỌNG - Phải làm bước này!

1. Khởi động điện thoại
2. Mở **KernelSU Manager**
3. Vào **Settings** (Cài đặt)
4. **TẮT "Global Umount"** ❌

> Nếu không tắt, có thể gặp lỗi:
> - Màn hình đen sau boot
> - WiFi không hoạt động
> - Mạng di động không hoạt động

---

## Kiểm Tra Cài Đặt Thành Công

```powershell
# Kiểm tra kernel version
adb shell cat /proc/version
# Nên thấy: 5.10.245-gki

# Kiểm tra KernelSU hoạt động
adb shell
su
# Nếu có dấu # => thành công!

# Kiểm tra module đã load (chỉ với LKM)
adb shell lsmod | grep -E "kernelsu|susfs"
```

---

## ❓ Xử Lý Lỗi Nhanh

### Bootloop sau khi flash?

```
1. Reboot vào Recovery
2. Flash lại stock boot.img
3. Hoặc Restore backup nếu có
```

### WiFi/Cellular không hoạt động?

```
1. Vào Recovery
2. Flash lại stock boot.img tạm thời
3. Boot vào system
4. Tắt Global Umount trong KernelSU Manager
5. Flash lại kernel
```

### Workflow build bị lỗi?

```powershell
# Re-run workflow
gh run list
gh run rerun <RUN_ID>

# Hoặc re-run các job thất bại
gh run rerun <RUN_ID> --failed
```

---

## 📊 So Sánh 2 Loại Build

| Tính năng | Kernel Hoàn Chỉnh | KernelSU LKM |
|-----------|-------------------|--------------|
| Thời gian build | 30-45 phút | 10-15 phút |
| Cài đặt | Flash qua recovery | Cài như module |
| Ổn định | Cao hơn | Tốt |
| An toàn | Có thể bootloop | An toàn hơn |
| Tính năng | Đầy đủ | Đủ dùng |
| Khuyên dùng | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

**Khuyến nghị:**
- **Lần đầu dùng:** Build LKM (an toàn hơn)
- **Dùng lâu dài:** Build kernel hoàn chỉnh (ổn định hơn)

---

## 🎯 Các Lệnh Hay Dùng

```powershell
# Xem tất cả workflows
gh workflow list

# Enable workflow nếu bị disabled
gh workflow enable build-kernel.yml
gh workflow enable build-lkm.yml

# Xem log chi tiết của build
gh run view <RUN_ID> --log

# Xem các artifacts có sẵn
gh run view <RUN_ID>

# Hủy build đang chạy
gh run cancel <RUN_ID>

# Xóa run cũ
gh run delete <RUN_ID>

# Xem releases
gh release list

# Tạo release
gh release create v1.0.0 ./build/*.zip
```

---

## 📚 Tài Liệu Đầy Đủ

- [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) - Hướng dẫn chi tiết đầy đủ
- [README.md](README.md) - Thông tin tổng quan

---

## 💡 Tips

1. **Build lần đầu:** Dùng LKM để test, an toàn hơn
2. **GitHub Actions giới hạn:** Free account có 2000 phút/tháng
3. **Artifacts tự xóa:** Sau 90 ngày, nên tạo releases
4. **Backup quan trọng:** Luôn backup boot.img trước khi flash
5. **Test trước:** Nên test kernel trên máy ảo hoặc thiết bị backup

---

**Chúc bạn build thành công! 🎉**

Nếu gặp vấn đề, hãy xem [WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md) để biết chi tiết hơn.

