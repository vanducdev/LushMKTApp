import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../auth/login_view.dart';
import 'tickets_view.dart';
import '../../controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController _authController = Get.put(AuthController());

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Đã Sao Chép',
      'Đã sao chép khóa API MMO thành công.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF161B22),
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRANG CÁ NHÂN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF0D0F14)),
          
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Obx(() {
                final user = _authController.currentUser.value;
                final userName = user?.name ?? 'Lush User';
                final userEmail = user?.email ?? 'user@lushmkt.com';
                final userApiKey = user?.apiKey ?? 'lush_mkt_live_key_918237198a9d8213bc89a';
                final balance = user?.balance ?? 2450000.0;

                return Column(
                  children: [
                    // 1. Glowing Avatar & Level Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                              boxShadow: [
                                BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.2), blurRadius: 20),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Color(0xFF161B22),
                              child: Text('L', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 28, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00E5FF).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'VIP GOLD LEVEL 3',
                              style: TextStyle(color: Color(0xFF00E5FF), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 2. Spending Stats Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('VÍ TIỀN', '${balance.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ'),
                          Container(height: 30, width: 1, color: Colors.white10),
                          _buildStatItem('ĐÃ TIÊU', '12.450.000đ'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. API Key Card for MMO Automation
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text('KHÓA KẾT NỐI API TOOL MMO', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PERSONAL API KEY', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(
                                  userApiKey,
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, color: Color(0xFF00E5FF), size: 20),
                            onPressed: () => _copyToClipboard(userApiKey),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Settings List Options
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Column(
                        children: [
                          _buildListTile(Icons.history_edu, 'Lịch sử mua tài nguyên', () {}),
                          const Divider(color: Colors.white10, height: 1),
                          _buildListTile(Icons.headset_mic_outlined, 'Vế hỗ trợ kỹ thuật (Tickets)', () => Get.to(() => const TicketsView())),
                          const Divider(color: Colors.white10, height: 1),
                          _buildListTile(Icons.security_rounded, 'Bảo mật & Đổi mật khẩu', () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _authController.logout();
                          Get.offAll(() => const LoginView());
                          Get.snackbar(
                            'Đã Đăng Xuất',
                            'Đã đăng xuất khỏi tài khoản LushMKT thành công.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF161B22),
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.redAccent, width: 1),
                          ),
                        ),
                        child: const Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                      ),
                    )
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  // Stat item builder
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // List tile item builder
  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00E5FF), size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
      onTap: onTap,
    );
  }
}
