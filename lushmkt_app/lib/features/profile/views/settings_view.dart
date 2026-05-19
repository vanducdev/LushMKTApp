import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/features/profile/providers/settings_providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final apiKeys = ref.watch(apiKeysProvider);
    final devices = ref.watch(devicesSessionProvider);
    final referral = ref.watch(referralProvider);

    final Color accentColor = const Color(0xFF00E5FF); // Neon Blue

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'CÀI ĐẶT & THIẾT LẬP',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // ================= SECTION 1: THEME & LANGUAGE =================
            _buildSectionHeader('GIAO DIỆN & NGÔN NGỮ'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Chế độ Tối (Dark Mode)', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text('Giảm mỏi mắt và tiết kiệm pin tối đa', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                    value: settings.isDarkMode,
                    onChanged: (val) => ref.read(appSettingsProvider.notifier).toggleTheme(),
                    activeColor: accentColor,
                  ),
                  const Divider(color: Colors.white10, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ngôn ngữ ứng dụng', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Chọn ngôn ngữ hiển thị chính', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => ref.read(appSettingsProvider.notifier).setLanguage('vi'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: settings.language == 'vi' ? accentColor.withOpacity(0.12) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: settings.language == 'vi' ? accentColor : Colors.white10),
                              ),
                              child: Text('🇻🇳 VI', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: settings.language == 'vi' ? accentColor : Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => ref.read(appSettingsProvider.notifier).setLanguage('en'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: settings.language == 'en' ? accentColor.withOpacity(0.12) : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: settings.language == 'en' ? accentColor : Colors.white10),
                              ),
                              child: Text('🇬🇧 EN', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: settings.language == 'en' ? accentColor : Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= SECTION 2: SECURITY =================
            _buildSectionHeader('BẢO MẬT & SINH TRẮC HỌC'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Xác thực FaceID / Vân tay', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text('Đăng nhập nhanh không cần nhập mật khẩu', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                    value: settings.isFaceIDEnabled,
                    onChanged: (val) => ref.read(appSettingsProvider.notifier).toggleFaceID(),
                    activeColor: accentColor,
                  ),
                  const Divider(color: Colors.white10, height: 20),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Khóa ứng dụng bằng PIN Code', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text('Yêu cầu mã khóa PIN 6 số khi mở app', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                    value: settings.isPINLockEnabled,
                    onChanged: (val) => ref.read(appSettingsProvider.notifier).togglePINLock(),
                    activeColor: accentColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= SECTION 3: REFERRAL (AFFILIATE) =================
            _buildSectionHeader('TIẾP THỊ LIÊN KẾT (REFERRAL)'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ưu đãi hoa hồng 10%', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF00FF88))),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(referralProvider.notifier).simulateNewReferral();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Giả lập: 1 User đăng ký ref thành công! Nhận hoa hồng +25,000 ₫.'),
                              backgroundColor: Color(0xFF00FF88),
                            ),
                          );
                        },
                        icon: const Icon(Icons.flash_on_rounded, size: 10, color: Colors.black),
                        label: const Text('MÔ PHỎNG REF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FF88),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Referral Link Field
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            referral.refLink,
                            style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: Color(0xFF00FF88)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: referral.refLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã sao chép liên kết tiếp thị!'), backgroundColor: Color(0xFF161B22)),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Statistics
                  Row(
                    children: [
                      Expanded(
                        child: _buildRefStatCard('SỐ REF ĐĂNG KÝ', '${referral.totalReferredUsers} thành viên', const Color(0xFF00E5FF)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildRefStatCard('TIỀN HOA HỒNG NHẬN', '${referral.totalEarnings.toInt()} ₫', const Color(0xFF00FF88)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= SECTION 4: DEVELOPER API KEYS =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('API KEYS LẬP TRÌNH VIÊN'),
                TextButton.icon(
                  onPressed: () {
                    ref.read(apiKeysProvider.notifier).generateNewKey();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã tạo API Key liên kết mới thành công!'), backgroundColor: Color(0xFF00FF88)),
                    );
                  },
                  icon: const Icon(Icons.add_rounded, color: Color(0xFF00E5FF), size: 16),
                  label: Text('TẠO KEY MỚI', style: GoogleFonts.orbitron(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF))),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
              child: apiKeys.isEmpty
                  ? Center(
                      child: Text('Bạn chưa tạo API Key nào.', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    )
                  : Column(
                      children: apiKeys.map((key) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(key.id, style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                                    const SizedBox(height: 2),
                                    Text(
                                      key.key,
                                      style: GoogleFonts.orbitron(fontSize: 9, color: Colors.white70),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, color: Colors.grey, size: 16),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: key.key));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Đã sao chép mã khóa API!'), backgroundColor: Color(0xFF161B22)),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 16),
                                    onPressed: () {
                                      ref.read(apiKeysProvider.notifier).revokeKey(key.id);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 24),

            // ================= SECTION 5: LOGGED IN DEVICES =================
            _buildSectionHeader('THIẾT BỊ ĐÃ ĐĂNG NHẬP'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: devices.map((device) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle),
                              child: Icon(
                                device.deviceName.contains('iPhone') ? Icons.phone_iphone_rounded : Icons.laptop_windows_rounded,
                                color: device.isCurrent ? const Color(0xFF00FF88) : Colors.white70,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(device.deviceName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                    if (device.isCurrent) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(color: const Color(0xFF00FF88).withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
                                        child: Text('HIỆN TẠI', style: GoogleFonts.orbitron(fontSize: 6, fontWeight: FontWeight.bold, color: const Color(0xFF00FF88))),
                                      )
                                    ]
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('${device.location} • ${device.lastActive}', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        if (!device.isCurrent)
                          IconButton(
                            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16),
                            onPressed: () {
                              ref.read(devicesSessionProvider.notifier).terminateSession(device.id);
                            },
                          )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildRefStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
