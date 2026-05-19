# TÀI LIỆU ĐẶC TẢ THIẾT KẾ UI/UX & DESIGN SYSTEM (PHÂN KHÚC PREMIUM)
> **DỰ ÁN**: LUSH-MKT (Premium MMO Service & Resource Super-Marketplace)  
> **PHIÊN BẢN**: 1.0.0 (Tài liệu Thiết kế Giao diện & Luồng trải nghiệm)  
> **TÁC GIẢ**: Antigravity - Advanced Agentic Coding Assistant (Google DeepMind Team)  

---

## I. HỆ THỐNG THIẾT KẾ (DESIGN SYSTEM SPECIFICATIONS)

Bản thiết kế giao diện LushMKT được tối ưu hóa cho ứng dụng di động Flutter và tương thích 100% với hệ thống Component Figma theo chuẩn **Cyber-Linear Premium**.

```
                           🎨 LUSH DESIGN SYSTEM TOKENS
   ┌───────────────────────────────────┬───────────────────────────────────┐
   │             COLORS                │            TYPOGRAPHY             │
   ├───────────────────────────────────┼───────────────────────────────────┤
   │ • Dark Blue: #090C15 (Deep space) │ • Orbitron: Phong cách cơ khí     │
   │ • Neon Purple: #7000FF (Futuristic)│   Dành cho Headings & Branding    │
   │ • Cyber Cyan: #00E5FF (High-tech) │ • SF Pro / Inter: Tối giản sạch   │
   │ • Clean White: #FFFFFF (Contrast) │   Dành cho Body text & Metadata   │
   └───────────────────────────────────┴───────────────────────────────────┘
```

### 1. Bảng mã màu (Color Palette tokens)
* **Dark Blue (Nền chính):** `#090C15` - Đại diện cho chiều sâu huyền ảo của vũ trụ MMO.
* **Cyber Purple (Tím chủ đạo):** `#7000FF` - Mang lại cảm giác xa xỉ, quyền lực và bí ẩn.
* **Cyber Cyan (Màu bổ trợ):** `#00E5FF` - Màu sắc công nghệ cao, phát sáng lôi cuốn sự chú ý.
* **White Clean (Bề mặt sáng):** `#F8F9FA` - Làm nền sạch cho văn bản, độ đọc cao trên màn hình OLED tối.
* **Dark Card (Thẻ giao diện):** `#161B22` với `opacity(0.8)` kết hợp viền neon siêu mảnh 1px.

### 2. Hệ thống Typography (SF Pro & Inter)
* **Font chữ hệ thống di động:** **SF Pro Display / SF Pro Text** (iOS) và **Inter** (Android).
* **Font chữ tiêu đề (Display & Title):** **Orbitron** (Tạo phong cách số, công nghệ, đậm tính MMO).
* **Quy chuẩn Font-scale trong Figma:**
  * **H1 (Large Title):** Orbitron - Bold - 28pt - Line Height 34px - Letter Spacing +2%
  * **H2 (Section Header):** Orbitron - SemiBold - 20pt - Line Height 26px - Letter Spacing +1.5%
  * **H3 (Card Title):** Orbitron - Medium - 16pt - Line Height 22px - Letter Spacing +1%
  * **Body Large (Nút bấm, điểm số dư):** Inter - SemiBold - 15pt - Line Height 20px
  * **Body Medium (Nội dung chính):** Inter - Regular - 13pt - Line Height 18px
  * **Body Small (Thông tin phụ, metadata):** Inter - Regular - 11pt - Line Height 14px

---

## II. ĐẶC TẢ CHI TIẾT CÁC THÀNH PHẦN (FIGMA COMPONENTS & VARIANTS)

Để lập trình viên và thiết kế viên Figma dễ dàng phối hợp, các thành phần được xây dựng theo kiến trúc **Component Variants** linh hoạt.

### 1. Buttons (Nút bấm)
* **Biến thể (Variants):** `Type=[Primary, Secondary, Text]`, `State=[Default, Hover/Focus, Active, Disabled]`, `Icon=[None, Left, Right]`.
* **Thông số Auto Layout trong Figma:**
  * **Padding:** `Horizontal: 24px`, `Vertical: 14px`
  * **Border Radius:** `12px`
  * **Gap (Nếu có Icon):** `8px`
  * **Hiệu ứng:** Primary Button có hiệu ứng đổ bóng phát sáng (Shadow blur: 16px, Color: `#00E5FF` tại 25% opacity).

### 2. Cards (Thẻ nội dung)
* **Biến thể (Variants):** `Style=[Glassmorphism, Dark Solid]`, `Border=[Glow Cyan, Default Tối]`.
* **Thông số Auto Layout trong Figma:**
  * **Padding:** `All around: 16px` (hoặc `20px` với thẻ lớn)
  * **Border Radius:** `16px`
  * **Hiệu ứng Glass:** `Backdrop Blur: 15px`, `Color: #161B22` ở `75%` Opacity, `Border: 1px solid #00E5FF` ở `12%` Opacity.

### 3. Inputs (Trường nhập liệu)
* **Biến thể (Variants):** `State=[Default, Focus, Error]`, `Password=[True, False]`.
* **Thông số Auto Layout trong Figma:**
  * **Padding:** `Left/Right: 16px`, `Top/Bottom: 16px`
  * **Border Radius:** `12px`
  * **Focus State Glow:** Khi được focus, đường viền đổi sang `#00E5FF` (Độ dày 1.5px), đổ bóng mờ ảo 8px xung quanh trường.

### 4. Navbar (Thanh điều hướng dưới)
* **Thiết kế:** Floating Glassmorphic Bar (Thanh nổi bo góc 24px lơ lửng trên màn hình nền).
* **Thông số Auto Layout:**
  * **Margin từ đáy màn hình:** `16px`
  * **Padding:** `Horizontal: 24px`, `Vertical: 12px`
  * **Hiệu ứng hoạt họa:** Khi click chọn Icon, chấm tròn Neon Cyan bên dưới Icon sẽ chạy trượt mềm mại (Slide animation) sang tab mới.

### 5. Toasts & Modals
* **Toast Notification:** Auto layout ngang, lơ lửng góc trên màn hình. `Padding: 16px 12px`, bo viền `16px` kèm icon trạng thái màu Success hoặc Error.
* **Modal Bottom-Sheet:** Chiều rộng full-width di động, bo tròn 2 góc trên `24px`. Sử dụng `Backdrop Blur: 20px` để làm mờ nhẹ phần nền phía sau, tạo chiều sâu thị giác tối đa.

---

## III. BẢN VẼ PHÁC THẢO CHỨC NĂNG CÁC MÀN HÌNH (SCREEN-BY-SCREEN BLUEPRINT)

Hệ thống bao gồm 15 màn hình chia thành 3 luồng chính: **Auth (Xác thực)**, **Main Client (Người mua)**, và **Seller Dashboard (Người bán)**.

```
                           📁 LUSH-MKT CORE MOBILE FLOWS
┌─────────────────────────┐   ┌───────────────────────────┐   ┌──────────────────────────┐
│     AUTH WORKFLOW       │   │   MAIN CLIENT WORKFLOW    │   │     SELLER WORKFLOW      │
├─────────────────────────┤   ├───────────────────────────┤   ├──────────────────────────┤
│ 1. Splash (Giới thiệu)  │   │ 5. Home (Trang chủ)       │   │ 12. Seller Dashboard     │
│ 2. Login (Đăng nhập)    │   │ 6. Marketplace (Chợ tổng) │   │ 13. Product Manager      │
│ 3. Register (Đăng ký)   │   │ 7. Product Detail (Chi    │   │ 14. Analytics (Biểu đồ)  │
│ 4. OTP Verification     │   │    tiết cấu hình VPS/Pxy) │   │ 15. Withdraw (Rút tiền)  │
└─────────────────────────┘   │ 8. Wallet (Nạp VietQR)    │   └──────────────────────────┘
                              │ 9. Orders (Xem tài nguyên)│
                              │ 10. Notifications (Báo)   │
                              │ 11. Profile (Thông tin)   │
                              └───────────────────────────┘
```

### 🔓 1. Luồng Xác thực (Auth Workflow)

#### Màn hình 1: Splash Screen (Trang khởi động)
* **Ý tưởng UX:** Hiển thị tức thì khi mở app. Tạo dấu ấn thương hiệu mạnh mẽ với hiệu ứng mở rộng (scale) logo từ nhỏ đến lớn kết hợp thanh loading chạy mượt.
* **Thành phần:**
  * Background tối sâu `#090C15`.
  * Logo biểu tượng Rocket bay cao phát sáng màu `#00E5FF`.
  * Dòng chữ thương hiệu `LushMKT` sử dụng font chữ Orbitron phong cách cơ khí.
  * Hộp thoại phụ thông báo trạng thái kết nối máy chủ thời gian thực.

#### Màn hình 2: Login Screen (Đăng nhập nhanh)
* **Ý tưởng UX:** Hỗ trợ đăng nhập nhanh bằng tài khoản đã lưu (Kiểu Facebook Multi-Account Switcher) để người bán MMO có thể đổi acc nhanh chóng mà không cần gõ pass nhiều lần.
* **Thành phần:**
  * Panel tài khoản đã lưu (Avatar tròn, tên người dùng, nút xóa acc đã lưu).
  * Panel gõ mật khẩu cổ điển (Ẩn/Hiện pass bằng nút mắt mở, nút Đăng nhập chính với hiệu ứng Gradient phát sáng).
  * Liên kết đăng ký nhanh phía dưới cùng.

#### Màn hình 3: Register Screen (Đăng ký tài khoản)
* **Ý tưởng UX:** Form đăng ký ngắn gọn. Có kiểm tra điều kiện mật khẩu thời gian thực (độ dài, ký tự đặc biệt) hiển thị bằng các chấm xanh lá/đỏ trực quan.
* **Thành phần:**
  * Trường nhập: Tên, Email, Mật khẩu, Nhập lại mật khẩu.
  * Hộp chọn đồng ý Điều khoản & Dịch vụ.

#### Màn hình 4: OTP Verification Screen (Xác thực OTP mã hóa)
* **Ý tưởng UX:** Mã OTP tự động focus vào ô kế tiếp khi gõ xong. Có đồng hồ đếm ngược gửi lại mã màu đỏ/xám.
* **Thành phần:**
  * 6 ô nhập mã OTP tách biệt với Auto-Layout rộng thoải mái.
  * Văn bản chỉ dẫn số điện thoại/email nhận mã.

---

### 🛒 2. Luồng Người mua (Main Client Workflow)

#### Màn hình 5: Home Screen (Trang chủ mua sắm)
* **Ý tưởng UX:** Thiết kế Linear cao cấp với mật độ thông tin cao. Người dùng thấy ngay các danh mục tài nguyên hot cùng số dư tài khoản của họ ở phía trên đỉnh.
* **Thành phần:**
  * Header: Số dư ví cá nhân (màu Neon Cyan lấp lánh) bên cạnh nút Nạp tiền nhanh.
  * Carousel Banner trượt giới thiệu sự kiện ưu đãi giảm giá Proxy/VPS.
  * Grid danh mục tài nguyên (VPS, IPv4, IPv6, Key Tool, Acc Clone) với biểu tượng phẳng gọn gàng.
  * Mục "Sản phẩm mua nhiều nhất" xếp hạng theo thẻ Glassmorphic sang trọng.

#### Màn hình 6: Marketplace (Bảng giá chợ tổng hợp)
* **Ý tưởng UX:** Thiết kế dạng Tab để lọc nhanh giữa dịch vụ cấu hình linh động (Services) và kho tài nguyên số lượng lớn (Products). Có thanh lọc (Filter) theo quốc gia, thời hạn sử dụng.
* **Thành phần:**
  * Thanh tìm kiếm tài nguyên thông minh.
  * Bộ lọc ngang: Quốc gia (Việt Nam, US, SG...), Loại (Rotate, Static).
  * Danh sách thẻ sản phẩm hiển thị: Số lượng tồn kho, Đánh giá sao, Nút mua ngay phát sáng.

#### Màn hình 7: Product Detail Screen (Chi tiết & Đặt mua)
* **Ý tưởng UX:** Các phần thông số kỹ thuật dài được thu gọn dạng accordion (collapsible). Nút "Mua Ngay" luôn cố định dưới chân màn hình (sticky bottom) giúp tăng tỷ lệ mua hàng.
* **Thành phần:**
  * Hình ảnh/Banner mô phỏng hệ điều hành hoặc chất lượng proxy.
  * Bảng thông số kỹ thuật (Ram, CPU, Băng thông, Hệ điều hành).
  * Hộp tăng giảm số lượng (nút cộng/trừ cơ học).
  * Tổng tiền tạm tính hiển thị tự động cập nhật thời gian thực.

#### Màn hình 8: Wallet & Deposit Screen (Nạp tiền VietQR động)
* **Ý tưởng UX:** Sinh mã VietQR động theo chuẩn Napas kèm nội dung chuyển khoản tự động. Có nút "Sao chép số tài khoản" và "Sao chép nội dung" riêng biệt kèm hiệu ứng phản hồi lấp lánh.
* **Thành phần:**
  * Khung quét mã QR to rõ nằm giữa màn hình, có dải sáng quét dọc mô phỏng camera quét mã thực tế.
  * Bảng hướng dẫn chi tiết 3 bước nạp tiền.
  * Lịch sử 5 giao dịch nạp tiền gần nhất dạng timeline.

#### Màn hình 9: Orders Screen (Kho tài nguyên đã mua)
* **Ý tưởng UX:** Nơi hiển thị các dịch vụ đang chạy của khách hàng. Đặc biệt quan trọng: Nút **"Copy Một Chạm"** toàn bộ định dạng thông tin bàn giao (như `IP|Port|User|Pass` hoặc tài khoản `UID|Pass|2FA`) để dán ngay vào các tool nuôi nick.
* **Thành phần:**
  * Danh sách đơn hàng phân chia theo màu sắc trạng thái (Active - Xanh lá, Expiring - Vàng, Expired - Đỏ).
  * Trường thông tin bàn giao dạng mã nguồn (Monospace font) dễ đọc.
  * Nút Gia hạn nhanh ngay trên đơn hàng sắp hết hạn.

#### Màn hình 10: Notifications (Thông báo thời gian thực)
* **Ý tưởng UX:** Phân loại thông báo thành 3 nhóm rõ ràng: Giao dịch ví, Đơn hàng hoàn tất, Khuyến mãi hệ thống.
* **Thành phần:**
  * Danh sách thông báo có gắn icon màu sắc trực quan theo từng nhóm chủ đề.

#### Màn hình 11: Profile Screen (Quản lý cá nhân & API Key)
* **Ý tưởng UX:** Hỗ trợ tạo và bảo mật mã khóa API (API Key) để liên kết với tool MMO ngoài.
* **Thành phần:**
  * Khu vực thông tin cá nhân: Avatar, Cấp độ tài khoản (Vip 1, Vip 2).
  * Ô cấu hình mã API Key (Ẩn mã bằng dấu chấm tròn, có nút copy).
  * Các tùy chọn cài đặt: Bảo mật 2FA, Đổi mật khẩu, Liên hệ hỗ trợ.

---

### 💼 3. Luồng Người bán (Seller Dashboard Workflow)

#### Màn hình 12: Seller Dashboard (Quản trị bán hàng)
* **Ý tưởng UX:** Giao diện đậm chất quản lý SaaS. Hiển thị 3 chỉ số tài chính cốt lõi: Tổng doanh thu, Số đơn hàng thành công, và Số lượng sản phẩm còn tồn kho.
* **Thành phần:**
  * 3 thẻ thống kê nhanh (Metric cards) xếp ngang mượt mà.
  * Biểu đồ doanh thu dạng đường lượn sóng lấp lánh (Sparkline) bằng Neon Purple.
  * Danh sách 5 đơn hàng vừa phát sinh cần duyệt hoặc tự động hoàn thành.

#### Màn hình 13: Product Manager (Quản lý kho hàng tự động)
* **Ý tưởng UX:** Thiết kế nút "Thêm sản phẩm" nổi bật góc phải. Cho phép tải tệp tin chứa danh sách tài nguyên (dạng `.txt` hàng loạt) lên hệ thống để bán dần.
* **Thành phần:**
  * Danh sách sản phẩm của Shop kèm công tắc ON/OFF trạng thái hiển thị bán.
  * Số lượng sản phẩm chi tiết trong kho (Số lượng còn lại/Số lượng đã bán).
  * Hộp thoại kéo thả file `.txt` nhập hàng loạt tài nguyên.

#### Màn hình 14: Analytics detail (Phân tích doanh thu sâu)
* **Ý tưởng UX:** Biểu đồ dạng cột và đường kết hợp thể hiện tương quan giữa lượt truy cập sản phẩm và tỷ lệ mua hàng thực tế (Conversion rate).
* **Thành phần:**
  * Lọc khoảng thời gian: Hôm nay, 7 ngày qua, 30 ngày qua.
  * Biểu đồ cột tròn các danh mục bán chạy nhất.

#### Màn hình 15: Withdraw Screen (Rút tiền tức thì)
* **Ý tưởng UX:** Nhập số tiền muốn rút kèm chọn ngân hàng liên kết. Hệ thống sẽ tự động trừ số dư và gửi yêu cầu lệnh rút tiền đến hệ thống phê duyệt nhanh.
* **Thành phần:**
  * Ô nhập số tiền rút có gợi ý rút nhanh (Rút toàn bộ số dư, Rút 50%, Rút 20%).
  * Danh sách ngân hàng phổ biến tại Việt Nam dạng lưới logo (Vietcombank, MB, Techcombank...).
  * Trạng thái duyệt lệnh rút tiền (Đang chờ xử lý, Đã hoàn thành).

---

## IV. NGUYÊN TẮC THIẾT KẾ DUAL-MODE & RESPONSIVE TRONG FIGMA

### 1. Đồng bộ hóa mã màu sáng/tối (Dark vs Light Token Sync)
Để hệ thống tự động thay đổi chế độ sáng tối mượt mà, các biến màu trong Figma Variables được khớp nối chi tiết:

| Tên biến màu (Figma Token) | Dark Mode Value (Mặc định) | Light Mode Value (Thay thế) | Trách nhiệm hiển thị |
| :--- | :--- | :--- | :--- |
| `sys.bg.main` | `#090C15` (Deep space) | `#F8F9FA` (Clean gray-white)| Nền scaffold chính của ứng dụng |
| `sys.bg.card` | `#161B22` ở 80% opacity | `#FFFFFF` | Nền các thẻ sản phẩm |
| `sys.text.primary` | `#FFFFFF` | `#0D0F14` | Chữ tiêu đề chính |
| `sys.text.secondary` | `#8E929E` | `#5C606C` | Chữ chú thích, metadata |
| `sys.border` | `#00E5FF` ở 12% opacity | `#E2E8F0` | Viền mỏng ngăn cách phần tử |

### 2. Nguyên tắc Auto Layout & Responsive (Thích ứng đa kích thước)
* **Mobile Viewport (390px - Mặc định):** Áp dụng lưới cột dọc `4 Columns`, `Gutter: 16px`, `Margin: 16px`. Mọi thẻ Glassmorphic Card thiết đặt chiều rộng ở trạng thái `Fill Container`.
* **Tablet Viewport (834px):** Áp dụng lưới `8 Columns`, `Gutter: 20px`, `Margin: 24px`. Chuyển đổi các danh sách sản phẩm hàng dọc dài thành dạng lưới cột đôi (Grid - 2 Columns) để tận dụng chiều rộng máy tính bảng.
* **Web Viewport (1440px):** Áp dụng lưới `12 Columns`, `Gutter: 24px`, `Margin: 64px`. Giao diện tự động mở rộng thêm thanh điều hướng Sidebar bên trái (thay thế cho Bottom Navbar) và chia màn hình làm 2 khu vực làm việc song song (Quản lý và Chi tiết).

---

> [!IMPORTANT]  
> Toàn bộ các thông số Auto Layout, Component Variants và hệ màu trong tài liệu thiết kế này đã được triển khai dưới dạng mã Flutter thực tế tại [e:\LushMKTApp\lushmkt_mobile\lib\core\theme\lush_design_system.dart](file:///e:/LushMKTApp/lushmkt_mobile/lib/core/theme/lush_design_system.dart). Lập trình viên có thể nhập trực tiếp các giá trị biến này vào công cụ Figma để đảm bảo bản thiết kế và mã nguồn khớp nhau chuẩn xác nhất.
