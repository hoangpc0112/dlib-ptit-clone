# DLIB.PTIT.EDU.VN CLONE

## 🚀 Hướng dẫn cài đặt

Thực hiện các bước sau theo thứ tự để thiết lập môi trường:

### 1. Xây dựng Images
Sử dụng các file cấu hình Docker để build các dịch vụ cần thiết:
```bash
docker compose -f docker-compose.yml -f docker-compose-cli.yml build
```

### 2. Khởi chạy hệ thống
Chạy các container ở chế độ nền (detached mode):
```bash
docker compose -p d6 -f docker-compose.yml up -d
```

### 3. Thiết lập tài khoản Quản trị viên
Tạo tài khoản admin để đăng nhập vào hệ thống:
```bash
docker compose -p d6 -f docker-compose-cli.yml run --rm dspace-cli create-administrator \
  -e test@test.edu \
  -f admin \
  -l user \
  -p admin \
  -c en
```
*Lưu ý: Bạn có thể thay đổi các tham số `-e` (email) và `-p` (password) tùy ý.*

### 4. Nạp dữ liệu mẫu (Sample Data)
Nếu bạn cần dữ liệu để chạy thử nghiệm, hãy thực thi lệnh sau:
```bash
docker compose -p d6 -f docker-compose-cli.yml -f dspace/src/main/docker-compose/cli.ingest.yml run --rm dspace-cli
```

---

## 🛠 Quản lý hệ thống

### Dừng hệ thống
Để dừng và xóa các container nhưng vẫn giữ lại volume dữ liệu:
```bash
docker compose -p d6 stop
```

### Tắt hoàn toàn (Cleanup)
Để gỡ bỏ hoàn toàn hệ thống:
```bash
docker compose -p d6 down
```