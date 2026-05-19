import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lushmkt_app/features/auth/views/login_view.dart';
import 'package:lushmkt_app/features/profile/views/settings_view.dart';
import 'package:lushmkt_app/features/profile/controllers/settings_controller.dart';
import 'package:lushmkt_app/features/social/controllers/social_controller.dart';
import 'package:lushmkt_app/features/auth/controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  final SocialController _socialController = Get.find<SocialController>();
  final AuthController _authController = Get.find<AuthController>();

  final _nameEditController = TextEditingController();
  final _bioEditController = TextEditingController();
  String _userBio = 'Tài khoản mới tham gia. Chưa cập nhật tiểu sử.';

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _settingsController.isDarkMode.value;
      final Color textColor = isDark ? Colors.white : Colors.black87;
      final Color cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
      
      final user = _authController.currentUser.value;
      final name = user?.name ?? 'Lush User';
      final email = user?.email ?? 'user@lushmkt.com';

      // Filter social activities for this user
      final myPosts = _socialController.posts.where((p) => p.authorEmail == email).toList();
      final myProducts = _socialController.storeProducts.where((p) => p.authorName == name).toList();

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0D0F14) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(
            'HỒ SƠ CỦA TÔI',
            style: _settingsController.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          backgroundColor: isDark ? const Color(0xFF0D0F14) : Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.settings_suggest_outlined, color: textColor),
              onPressed: () => Get.to(() => const SettingsView()),
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. STUNNING HEADER USER INFO CARD
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF00E5FF).withOpacity(0.12),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(name, style: _settingsController.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 4),
                    Text(email, style: _settingsController.getTextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(
                      _userBio,
                      style: _settingsController.getTextStyle(fontSize: 12, color: textColor.withOpacity(0.6)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showEditProfileDialog(context, name),
                      icon: const Icon(Icons.edit, size: 14),
                      label: const Text('CHỈNH SỬA HỒ SƠ'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                        foregroundColor: textColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        textStyle: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. STATISTICS COUNTERS GRID
            Row(
              children: [
                _buildStatItem('BÀI VIẾT', myPosts.length.toString(), cardColor, textColor),
                const SizedBox(width: 12),
                _buildStatItem('SẢN PHẨM', myProducts.length.toString(), cardColor, textColor),
              ],
            ),
            const SizedBox(height: 24),

            // 3. PERSONAL SOCIAL ACTIVITY FEED
            Text(
              'BÀI ĐĂNG CỦA TÔI',
              style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.5)),
            ),
            const SizedBox(height: 12),

            if (myPosts.isEmpty)
              Card(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Text('Bạn chưa đăng bài viết nào.', style: _settingsController.getTextStyle(fontSize: 11, color: Colors.grey)),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myPosts.length,
                itemBuilder: (context, index) {
                  final post = myPosts[index];
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.authorName, style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
                              Text('Vừa xong', style: _settingsController.getTextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(post.text, style: _settingsController.getTextStyle(fontSize: 12, color: textColor)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            // 4. LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _authController.logout();
                  Get.offAll(() => const LoginView());
                  Get.snackbar('Đăng Xuất', 'Phiên làm việc đã kết thúc an toàn.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.grey, colorText: Colors.white);
                },
                icon: const Icon(Icons.power_settings_new, size: 18),
                label: Text('ĐĂNG XUẤT TÀI KHOẢN', style: _settingsController.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, Color cardColor, Color textColor) {
    return Expanded(
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _settingsController.isDarkMode.value ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(value, style: _settingsController.getTextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF))),
              const SizedBox(height: 4),
              Text(label, style: _settingsController.getTextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Edit Profile Form Dialog
  void _showEditProfileDialog(BuildContext context, String currentName) {
    _nameEditController.text = currentName;
    _bioEditController.text = _userBio;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _settingsController.isDarkMode.value ? const Color(0xFF161B22) : Colors.white,
          title: Text('CẬP NHẬT HỒ SƠ', style: _settingsController.getTextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameEditController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bioEditController,
                decoration: const InputDecoration(labelText: 'Tiểu sử'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('HỦY', style: _settingsController.getTextStyle(fontSize: 12, color: Colors.redAccent)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text('CẬP NHẬT', style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onPressed: () {
                final newName = _nameEditController.text.trim();
                final newBio = _bioEditController.text.trim();

                if (newName.isNotEmpty) {
                  final user = _authController.currentUser.value;
                  if (user != null) {
                    user.name = newName;
                    _authController.currentUser.refresh();
                  }
                }
                if (newBio.isNotEmpty) {
                  setState(() {
                    _userBio = newBio;
                  });
                }
                Get.back();
              },
            )
          ],
        );
      },
    );
  }
}
