# BẢN ĐỒ TRIỂN KHAI HOẠN THIỆN SẢN PHẨM & PHÁT HÀNH LUSH-MKT (MASTER BLUEPRINT)
> **DỰ ÁN**: LUSH-MKT (Premium MMO Service & Resource Super-Marketplace)  
> **PHIÊN BẢN**: 1.0.0 (Bản Đặc tả Triển khai DevOps, Phát hành App Store & Bảo mật Production)  
> **TÁC GIẢ**: Antigravity - Advanced Agentic Coding Assistant (Google DeepMind Team)  

---

## I. MỤC TIÊU CỦA MASTER BLUEPRINT (PRODUCTION OBJECTIVES)

Tài liệu này đóng vai trò là **Bản vẽ bàn giao tối cao (Master Handover Blueprint)** bao quát toàn bộ quy trình đưa dự án LushMKT từ môi trường phát triển (Development) sang môi trường vận hành quy mô lớn (Production), sẵn sàng phát hành trên Apple App Store và Google Play Store.

```
                      🚀 VÒNG ĐỜI PHÁT TRIỂN & PHÁT HÀNH PRODUCTION
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 🎨 PHASE 15 & 24 : Đánh bóng giao diện (Shimmer Skeleton, Hero, Spacing)│
  ├────────────────────────────────────────────────────────────────────────┤
  │ ⚙️ PHASE 16 & 17 : Vận hành Laravel Filament Admin, JWT, Rate Limit     │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 🧪 PHASE 18      : Kiểm thử tự động (UI, API, Payment Gates, Socket)   │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 📦 PHASE 19 & 20 : Biên dịch iOS IPA Xcode, TestFlight & App Store     │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 🐳 PHASE 21 & 22 : Mở rộng AI VIP, Đóng gói Docker, Caching Redis, CDN │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 📊 PHASE 23 & 25 : Giám sát logs lỗi Firebase, Checklist nghiệm thu    │
  └────────────────────────────────────────────────────────────────────────┘
```

---

## II. ĐẶC TẢ CHI TIẾT TỪ GIAI ĐOẠN 15 ĐẾN 25

### GIAI ĐOẠN 15 & 24 — HOẠT HỌA CAO CẤP & TỐI ƯU GIAO DIỆN (UI/UX POLISHING)
* **Hiệu ứng Shimmer Skeleton:** Sử dụng thư viện `shimmer` thay thế vòng xoay tròn loading nhàm chán bằng các khung quét sáng mờ tinh tế khi đang tải dữ liệu sản phẩm, đơn hàng.
* **Hoạt họa mượt mà (Animations):**
  - **Hero Transition:** Chuyển cảnh zoom phóng to ảnh sản phẩm mượt mà từ màn hình chợ Marketplace vào chi tiết Bottom Sheet.
  - **Fade / Slide Transitions:** Hiệu ứng trượt êm ái khi mở các ngăn Drawer đăng bán của Seller hay chuyển Tab nạp tiền, cài đặt.
  - **Blur (Kính mờ Glassmorphism):** Áp dụng hiệu ứng làm mờ BackdropFilter cho tất cả các thẻ Card để tạo chiều sâu thị giác.
* **Spacings & Typography:** Đồng bộ khoảng cách tiêu chuẩn 8px/16px/24px, font chữ Inter sang trọng kết hợp Orbitron kỹ thuật số cho các mốc định danh/mã thẻ ngân hàng.

---

### GIAI ĐOẠN 16 — BẢNG ĐIỀU KHIỂN & HỆ THỐNG BACKEND (FILAMENT ADMIN)
Chúng tôi khuyên dùng **Laravel Filament** để xây dựng trang quản trị Admin Panel vì sự gọn nhẹ, hiện đại và bảo mật vượt trội:
* **Tính năng Filament Admin:**
  - **User & Merchant Manager:** Duyệt hồ sơ KYC tài khoản người bán, kích hoạt/khóa tài khoản.
  - **Products & Marketplace Moderator:** Duyệt và gỡ các sản phẩm VIA FB, VPS bị báo cáo lỗi.
  - **Financial Reconciliations:** Đối soát tự động các khoản nạp VietQR, Momo và duyệt các lệnh rút tiền từ doanh thu ví của Seller.
  - **Direct Broadcast Alerts:** Soạn tin nhắn Notification khuyến mãi đẩy thẳng qua FCM về app người dùng.

---

### GIAI ĐOẠN 17 — HÀNG RÀO BẢO MẬT PHÍA MÁY CHỦ (API SECURITY SHIELDS)
* **Bắt buộc trên Production:**
  - **JWT Authorization:** Token ký số bảo mật, sử dụng cơ chế Access Token (hạn 15 phút) và Refresh Token lưu trữ mã hóa để tự cấp lại token.
  - **API Rate Limiting:** Thiết lập `ThrottleRequests` phía Laravel (`api.php`) giới hạn tối đa 60 requests/phút trên mỗi địa chỉ IP để chống spam ddos.
  - **HTTPS & SSL Pinning:** Mã hóa toàn bộ đường truyền dữ liệu giữa Flutter và Laravel API, chặn trung gian xem trộm gói tin (chống Man-in-the-Middle).
  - **SQL Injection & XSS Protection:** Sử dụng Eloquent ORM Binding tuyệt đối, lọc sạch dữ liệu đầu vào.
  - **Device Tracking:** Lưu dấu chuỗi thiết bị truy cập (Device UUID) để cảnh báo bảo mật ngay khi phát hiện đăng nhập từ IP lạ.

---

### GIAI ĐOẠN 18 — KIỂM THỬ HỆ THỐNG TOÀN DIỆN (SYSTEM TESTING)
* **Quy trình kiểm thử chất lượng:**
  - **API Unit Testing:** Viết test suite cho Laravel (`tests/Feature/AuthTest.php`, `PaymentTest.php`) đảm bảo logic cộng tiền ví khi webhook gọi luôn chính xác 100%.
  - **Widget UI Testing:** Chạy kiểm thử luồng gõ chat, lướt tab nạp tiền trên thiết bị mô phỏng Android và iOS (iPhone).
  - **Realtime Load Test:** Giả lập 1,000 kết nối WebSockets đồng thời lên cổng chat máy chủ để tối ưu bộ nhớ đệm.

---

### GIAI ĐOẠN 19 & 20 — BIÊN DỊCH VÀ PHÁT HÀNH APP STORE (BUILD & RELEASE)
* **Quy trình build file cài đặt iOS (.IPA):**
  1. Yêu cầu máy chủ macOS cấu hình Xcode và tài khoản Apple Developer Program.
  2. Chạy lệnh: `flutter build ipa --release`.
  3. Mở tệp Runner trong Xcode để cấu hình App Icon, Splash Screen, mô tả Privacy Policy và các quyền thiết bị (FaceID, Photos).
* **Phân phối TestFlight & App Store Connect:**
  - Đẩy bản build nháp lên **TestFlight** để mời đội ngũ tester trải nghiệm sửa lỗi.
  - Thiết lập thông tin chụp màn hình (Screenshots) trên App Store Connect, soạn điều khoản sử dụng Terms & Conditions.
  - Gửi hội đồng Apple duyệt ứng dụng để chính thức xuất bản trên App Store.

---

### GIAI ĐOẠN 21, 22 & 23 — DEVOPS VẬN HÀNH & GIÁM SÁT RADA (SCALING & MONITORING)
* **Kiến trúc Máy chủ (DevOps Architecture):**
  - **Docker & Docker Compose:** Đóng gói độc lập mã nguồn Laravel, database MySQL, Redis Caching thành các Container tách biệt để dễ dàng nhân bản mở rộng.
  - **Nginx Reverse Proxy:** Điều phối luồng HTTPS bảo mật, nén dữ liệu Gzip tăng tốc tải trang.
  - **Redis Cache & CDN Cloudflare:** Lưu đệm thông tin sản phẩm hot, chống nghẽn DB. Sử dụng Cloudflare CDN để truyền tải tài nguyên tĩnh (ảnh đại diện sản phẩm) siêu tốc.
* **Hệ thống giám sát (Rada Monitoring):**
  - **Firebase Crashlytics:** Theo dõi các lỗi sập ứng dụng (crashes) thời gian thực trên thiết bị người dùng để vá lỗi tức thời.
  - **Sentry Logs:** Gom logs lỗi hệ thống phía Laravel máy chủ để lập trình viên chủ động sửa lỗi trước khi khách hàng phát hiện.

---

## III. COMBO CÔNG NGHỆ KHUYÊN DÙNG TỐI ƯU (RECOMMENDED STACK)

Để đảm bảo hiệu năng tối đa, chịu tải tốt và dễ bảo trì, LushMKT được xây dựng trên bộ công nghệ vàng:

```
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 📱 FRONTEND MOBILE CLIENT : Flutter (Riverpod State + GoRouter)         │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 💻 BACKEND API ENGINE     : Laravel RESTful (Eloquent, Sanctum JWT)    │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 💾 DATABASE CORE          : MySQL (Giao dịch) + Redis (Bộ nhớ đệm)     │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 🐳 CONTAINER DEVOPS       : Docker & Docker Compose                    │
  ├────────────────────────────────────────────────────────────────────────┤
  │ ⚡ CDN & PROTECTION       : Cloudflare (Chống DDoS, Nén Ảnh Tĩnh)      │
  ├────────────────────────────────────────────────────────────────────────┤
  │ 📊 RADAR MONITORING       : Firebase & Sentry Logs                     │
  └────────────────────────────────────────────────────────────────────────┘
```

---

## IV. CHECKLIST NGHIỆM THU CUỐI CÙNG (PRODUCTION READY CHECKLIST)

Trước khi bấm nút phát hành chính thức, hãy đảm bảo tất cả các mốc sau đã tích V xanh:

* [x] **0 Compile Errors:** Chạy `flutter analyze` đạt 0 lỗi biên dịch tĩnh.
* [x] **Secure Access:** Toàn bộ API chuyển sang giao thức HTTPS, bật Rate Limit.
* [x] **Payment Verified:** Kiểm tra kỹ cơ chế nạp tiền MB Bank VietQR và sandbox webhook.
* [x] **Realtime Hub Working:** Kênh Live chat và dòng sự kiện WebSockets chạy êm ái.
* [x] **Referral System Sync:** Affiliate link ghi nhận hoa hồng cộng ví chuẩn xác.
* [x] **Push Banner Active:** Tin Firebase Push nhận diện mượt mà kèm banner nổi trượt mượt.
* [x] **Responsive Layouts:** Giao diện hiển thị hoàn hảo trên cả máy tính bảng, điện thoại iPhone và Android.
