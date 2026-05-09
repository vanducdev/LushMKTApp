import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_view.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController _authController = Get.put(AuthController());

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Professional Clean Dark Theme
          Container(color: const Color(0xFF0D0F14)),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Beautiful Logo Header (with custom file or elegant fallback)
                      _buildLogoHeader(),
                      const SizedBox(height: 24),

                      const Text(
                        'TẠO TÀI KHOẢN MỚI',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tham gia hệ sinh thái dịch vụ LushMKT',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Full Name Input
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline, color: Color(0xFF00E5FF)),
                          labelText: 'Họ và tên',
                          hintText: 'Nhập họ và tên của bạn',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email Input
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF00E5FF)),
                          labelText: 'Email',
                          hintText: 'Nhập địa chỉ email hợp lệ',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.vpn_key_outlined, color: Color(0xFF00E5FF)),
                          labelText: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu ít nhất 6 ký tự',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Input
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscurePassword,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_clock_outlined, color: Color(0xFF00E5FF)),
                          labelText: 'Nhập lại mật khẩu',
                          hintText: 'Nhập lại mật khẩu giống phía trên',
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            final name = _nameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text;
                            final confirmPassword = _confirmPasswordController.text;

                            if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                              Get.snackbar('Cảnh Báo', 'Vui lòng nhập đầy đủ tất cả các trường.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orangeAccent, colorText: Colors.white);
                              return;
                            }

                            if (password != confirmPassword) {
                              Get.snackbar('Cảnh Báo', 'Mật khẩu nhập lại không trùng khớp.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
                              return;
                            }

                            final success = await _authController.register(
                              name: name,
                              email: email,
                              password: password,
                            );

                            if (success) {
                              Get.offAll(() => const LoginView());
                              Get.snackbar(
                                'Đăng Ký Thành Công',
                                'Tài khoản của bạn đã được đăng ký và lưu tự động vào trang đăng nhập!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 4),
                              );
                            } else {
                              Get.snackbar('Đăng Ký Thất Bại', 'Email đã được sử dụng hoặc có lỗi xảy ra.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E5FF),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _authController.isLoading.value
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                              : const Text('ĐĂNG KÝ NGAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Redirect to login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đã có tài khoản? ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: const Text(
                              'Đăng nhập ngay',
                              style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Build Logo Header with exact custom image file and professional fallback
  Widget _buildLogoHeader() {
    const String imagePath = 'c:\\Users\\ducva\\Downloads\\LushMKT\\lushmkt_mobile\\image\\isometric-b2b-illustration.png';
    final file = File(imagePath);

    if (file.existsSync()) {
      return Image.file(
        file,
        height: 150,
        fit: BoxFit.contain,
      );
    }

    // High-end fallback if the custom logo file isn't directly loaded
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.02),
        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.12)),
      ),
      child: const Icon(Icons.rocket_launch_rounded, size: 60, color: Color(0xFF00E5FF)),
    );
  }
}
