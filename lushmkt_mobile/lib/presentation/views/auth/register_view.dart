import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          Container(color: const Color(0xFF0D0F14)),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7000FF).withOpacity(0.12),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.12),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.02),
                        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.person_add_alt_outlined, size: 50, color: Color(0xFF00E5FF)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'TẠO TÀI KHOẢN',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tham gia ngay hệ sinh thái dịch vụ LushMKT',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Full Name Input
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF00E5FF)),
                        labelText: 'Họ và tên',
                        hintText: 'Nhập họ và tên thật của bạn',
                        fillColor: const Color(0xFF161B22).withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Input
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF00E5FF)),
                        labelText: 'Email',
                        hintText: 'Nhập địa chỉ email hợp lệ',
                        fillColor: const Color(0xFF161B22).withOpacity(0.8),
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
                        fillColor: const Color(0xFF161B22).withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Input
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_clock_outlined, color: Color(0xFF00E5FF)),
                        labelText: 'Nhập lại mật khẩu',
                        hintText: 'Nhập lại mật khẩu giống phía trên',
                        fillColor: const Color(0xFF161B22).withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Register Button with premium gradient
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7000FF), Color(0xFF00E5FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7000FF).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.offAll(() => const LoginView());
                          Get.snackbar(
                            'Đăng ký thành công',
                            'Chào mừng thành viên mới! Vui lòng đăng nhập.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'ĐĂNG KÝ NGAY',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Back to login redirect
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
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
