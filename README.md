# NT548 - BÀI TẬP THỰC HÀNH 01
**Chủ đề:** Dùng Terraform và CloudFormation để quản lý và triển khai hạ tầng AWS.

## 1. Thông tin chung
* **Môn học:** Công nghệ DevOps và Ứng dụng (NT548)
* **Giảng viên hướng dẫn:** ThS. Lê Anh Tuấn
* **Sinh viên thực hiện:**
    * [Họ và Tên của bạn] - [Mã số sinh viên]
    * [Họ và Tên thành viên 2 nếu có] - [MSSV]

## 2. Mô tả dự án
Dự án này sử dụng **Terraform** để triển khai tự động hạ tầng mạng (VPC) và máy chủ (EC2) trên AWS theo mô hình bảo mật 2 lớp (Public/Private Subnet).

### Kiến trúc hệ thống bao gồm:
* **VPC:** Mạng riêng ảo tuỳ chỉnh.
* **Public Subnet:** Chứa Public EC2 và NAT Gateway, kết nối trực tiếp Internet qua Internet Gateway (IGW).
* **Private Subnet:** Chứa Private EC2, không có Public IP, kết nối Internet thông qua NAT Gateway.
* **Security Groups:**
    * *Public SG:* Chỉ cho phép SSH (Port 22) từ địa chỉ IP cá nhân cụ thể.
    * *Private SG:* Chỉ cho phép SSH từ máy Public EC2.

## 3. Cấu trúc thư mục
Dự án được tổ chức theo mô hình Module hoá để dễ quản lý:

NT548-Lab01/
├── modules/
│   ├── networking/    # Xử lý VPC, Subnet, IGW, NAT, Route Table
│   ├── security/      # Xử lý Security Groups (Firewall)
│   └── compute/       # Xử lý EC2 Instances
├── main.tf            # File cấu hình chính gọi các modules
├── variables.tf       # Khai báo các biến đầu vào
├── outputs.tf         # Hiển thị thông tin quan trọng sau khi chạy xong
└── README.md          # Tài liệu hướng dẫn
## 4. Hướng dẫn chạy

Khởi tạo dự án: Mở terminal tại thư mục dự án và chạy lệnh để tải các plugin cần thiết

terraform init

Lưu ý:  ta cần tìm Public IP của đường truyền mạng mà máy đang sử dụng bằng câu lệnh 

curl ifconfig.me

Ta lấy kết quả trả về để điền vào câu lệnh bên dưới để kiểm tra 

terraform plan -var="my_ip_address=(IP vừa tìm được)"

Triển khai 

terraform apply 

Hủy bỏ hạ tầng sau khi kiểm thử xong:

terraform destroy -var="my_ip_address=(IP vừa tìm được)"

##5.Kiểm thử Test Cases

Test Case 1: Kiểm tra SSH vào Public EC2

# Thay 'key-pair.pem' bằng tên file key của bạn

# Thay 'PUBLIC_IP' bằng IP hiển thị sau khi chạy terraform apply hoặc có thể vào AWS EC2 Instace để tìm

ssh -i key-pair.pem ubuntu@<PUBLIC_IP>

Kết quả: Đăng nhập thành công vào Ubuntu

Test Case 2: Kiểm tra bảo mật Private EC2

Mục tiêu: Private EC2 không thể truy cập trực tiếp từ Internet.

Thực hiện: Thử SSH trực tiếp vào IP Private từ máy cá nhân.

# Thay 'key-pair.pem' bằng tên file key của bạn

# Thay 'PRIVATE_IP' bằng IP hiển thị sau khi chạy terraform apply hoặc có thể vào AWS EC2 Instace để tìm

ssh -i key-pair.pem ubuntu@<PUBLIC_IP>

Kết quả: Báo lỗi Connection timed out hoặc không kết nối được (Đúng yêu cầu).

Test Case 3: Kiểm tra kết nối từ Public sang Private

Mục tiêu: Private EC2 chỉ nhận kết nối từ Public EC2.

Thực hiện:

SSH vào Public EC2 (như Test Case 1).

Tạo file key bên trong máy Public (nano key.pem và dán nội dung key vào).

Phân quyền: chmod 400 key.pem.

SSH sang Private EC2: ssh -i key.pem ubuntu@<PRIVATE_IP_CUA_MAY_PRIVATE>

Kết quả: Đăng nhập thành công.

Test Case 4: Kiểm tra NAT Gateway

Mục tiêu: Private EC2 có thể kết nối ra Internet để update phần mềm.

Thực hiện: Tại máy Private EC2, chạy lệnh ping google.com.

Kết quả: Ping thành công (có phản hồi).
