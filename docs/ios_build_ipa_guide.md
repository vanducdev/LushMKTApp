# CẨM NANG BIÊN DỊCH VÀ XUẤT FILE .IPA LUSH-MKT (iOS PRODUCTION BUILD)
> **DỰ ÁN**: LUSH-MKT (Premium MMO Service & Resource Super-Marketplace)  
> **PHIÊN BẢN**: 1.0.0 (Bản Đặc tả Kỹ thuật Biên dịch iOS / Xcode / Cloud CI-CD)  
> **TÁC GIẢ**: Antigravity - Advanced Agentic Coding Assistant (Google DeepMind Team)  

---

## I. HIỂU VỀ GIỚI HẠN BIÊN DỊCH BẢN BUILD IOS (.IPA)

Vì hệ điều hành cục bộ của bạn đang là **Windows**, việc biên dịch trực tiếp ra tệp tin cài đặt iOS (`.ipa`) bị chặn bởi quy định kỹ thuật của Apple. Hệ thống bắt buộc phải có **hệ điều hành macOS**, trình biên dịch **Xcode** và thư viện **Apple SDK** để hoàn tất việc ký chứng chỉ bảo mật (Provisioning Profile) và xuất file.

Tuy nhiên, bạn có **2 giải pháp tiêu chuẩn công nghiệp** để nhận bản build `.ipa` cực kỳ nhanh chóng dưới đây.

```
                   🛠️ SƠ ĐỒ ĐƯỜNG ỐNG BIÊN DỊCH FILE .IPA
  ┌────────────────────────────────────────────────────────────────────────┐
  │ 💻 CÁCH A: BIÊN DỊCH TRÊN MÁY MAC CỦA BẠN (Sử dụng 3 lệnh Xcode CLI)   │
  ├────────────────────────────────────────────────────────────────────────┤
  │ ☁️ CÁCH B: TỰ ĐỘNG BIÊN DỊCH CLOUD CI/CD (Sử dụng Codemagic miễn phí)  │
  └────────────────────────────────────────────────────────────────────────┘
```

---

## II. PHƯƠNG ÁN A: BIÊN DỊCH TRÊN MÁY MACBOOK CỤC BỘ (LOCAL MAC)

Nếu bạn có máy Mac hoặc thuê máy Mac Cloud (như MacinCloud, XcodeCloud), hãy copy thư mục dự án `lushmkt_app/` sang máy Mac và thực hiện tuần tự 3 bước sau:

### Bước 1: Đồng bộ hóa thư viện iOS CocoaPods
Mở Terminal trên máy Mac, truy cập vào thư mục `lushmkt_app` và chạy lệnh tải pod:
```bash
flutter pub get
cd ios
pod install
```

### Bước 2: Cài đặt Chứng chỉ bảo mật (Apple Certificates)
1. Mở Xcode, chọn **Open an Existing Project** và dẫn tới thư mục `lushmkt_app/ios/Runner.xcworkspace`.
2. Chọn dự án **Runner** ở cột bên trái ➔ Chọn tab **Signing & Capabilities**.
3. Tích chọn **Automatically manage signing**, chọn **Team** là tài khoản Apple Developer của bạn.
4. Đảm bảo **Bundle Identifier** là duy nhất (ví dụ: `com.lushmkt.app`).

### Bước 3: Biên dịch và xuất File `.ipa` sản phẩm
Chạy lệnh biên dịch tối ưu hóa phiên bản phát hành trên Terminal:
```bash
# Biên dịch file lưu kho (Archive)
flutter build ipa --release
```
* **Kết quả:** Bản build `.ipa` sẽ được xuất ra tại đường dẫn:  
  `build/ios/ipa/Runner.ipa`  
  Bạn có thể dùng tệp này tải lên TestFlight hoặc cài đặt trực tiếp qua phần mềm 3uTools/AltStore để test!

---

## III. PHƯƠNG ÁN B: TỰ ĐỘNG HÓA BIÊN DỊCH TRÊN ĐÁM MÂY (CLOUD CI/CD)

Nếu bạn hoàn toàn làm việc trên **Windows** và không muốn mua máy Mac, hãy sử dụng **Codemagic** (Nền tảng build app Flutter trên đám mây tốt nhất hiện nay, cho phép build miễn phí).

Chúng tôi đã viết sẵn tệp cấu hình đường ống [codemagic.yaml](file:///e:/LushMKTApp/lushmkt_app/codemagic.yaml) tối ưu. Bạn chỉ cần làm theo 3 bước sau:
1. Đăng ký tài khoản miễn phí tại **Codemagic.io** và liên kết với Github/Gitlab của bạn.
2. Thêm dự án `lushmkt_app` vào bảng điều khiển Codemagic.
3. Nhấn nút **Start Build**, Codemagic sẽ tự động kích hoạt máy chủ macOS trên mây, nạp tệp `codemagic.yaml` dưới đây, tự biên dịch và gửi trả link tải file `.ipa` và `.apk` về email của bạn sau 5 phút!

Dưới đây là nội dung cấu hình tự động biên dịch, chúng tôi sẽ khởi tạo tệp này trực tiếp trong dự án của bạn:
```yaml
# codemagic.yaml
workflows:
  ios-release-workflow:
    name: LushMKT iOS Release Builder
    max_build_duration: 15
    instance_type: mac_mini_m1
    environment:
      flutter: stable
      xcode: latest
    triggering:
      events:
        - push
      branch_patterns:
        - pattern: main
    scripts:
      - name: Set up CocoaPods and Fetch Packages
        script: |
          flutter pub get
          find . -name "Podfile" -execdir pod install \;
      - name: Build iOS IPA Production
        script: |
          # Build bản release không cần code signing cứng để cài TestFlight
          flutter build ipa --release --export-method=ad-hoc
    artifacts:
      - build/ios/ipa/*.ipa
```

---

## IV. CÔNG CỤ CÀI ĐẶT & TEST THỬ FILE .IPA KHÔNG CẦN CHỢ APP STORE

Sau khi nhận được file `.ipa` từ máy Mac hoặc Codemagic, bạn có thể phân phối cài đặt cho điện thoại iPhone của khách hàng hoặc đội ngũ tester bằng các công cụ sau:

1. **TestFlight (Chính thức từ Apple):** Tải file lên App Store Connect, app sẽ tự xuất hiện trong hòm thư TestFlight của người dùng qua Email.
2. **Cài qua cáp USB (Dành cho Windows/Mac):** Tải phần mềm **3uTools** về máy tính Windows, cắm cáp iPhone ➔ Chọn mục **Apps** ➔ Nhấn **Import & Install ipa** để cài trực tiếp vào máy.
3. **Cài qua web OTA (Không cần máy tính):** Tải tệp `.ipa` lên trang **Diawi.com** hoặc **InstallOnAir.com**, hệ thống sẽ sinh ra một mã QR và link cài đặt. Người dùng iPhone chỉ cần quét mã QR bằng camera để tự động cài app vào máy.
