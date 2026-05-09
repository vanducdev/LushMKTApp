import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_view.dart';
import 'register_view.dart';
import 'forgot_password_view.dart';
import '../../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController _authController = Get.put(AuthController());
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _showCustomInputForm = false;

  @override
  void initState() {
    super.initState();
    _checkRegistrationAutofill();
  }

  // Auto-fill credentials if they just registered
  Future<void> _checkRegistrationAutofill() async {
    final prefs = await SharedPreferences.getInstance();
    final regEmail = prefs.getString('reg_saved_email');
    final regPassword = prefs.getString('reg_saved_password');
    if (regEmail != null && regEmail.isNotEmpty) {
      _emailController.text = regEmail;
      _passwordController.text = regPassword ?? '';
      _showCustomInputForm = true;
      // Clear after read to prevent repeated autofills
      await prefs.remove('reg_saved_email');
      await prefs.remove('reg_saved_password');
    }
  }

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
                  final savedList = _authController.savedAccounts;
                  final hasSavedAccounts = savedList.isNotEmpty;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Beautiful Logo Header (Uses specified logo image with graceful fallback)
                      _buildLogoHeader(),
                      const SizedBox(height: 24),

                      // 1. FACEBOOK-LIKE MULTI-ACCOUNT SWITCHER PANEL
                      if (hasSavedAccounts && !_showCustomInputForm) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'TÀI KHOẢN ĐÃ LƯU (NHẤP ĐỂ VÀO NHANH)',
                            style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B22),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.04)),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: savedList.length,
                            separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                            itemBuilder: (context, index) {
                              final acc = savedList[index];
                              final name = acc['name'] ?? 'Lush User';
                              final email = acc['email'] ?? '';

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF00E5FF).withOpacity(0.1),
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                subtitle: Text(email, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 12),
                                    const SizedBox(width: 12),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 18),
                                      onPressed: () => _authController.removeSavedAccount(email),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await _authController.loginWithSavedAccount(acc);
                                  Get.offAll(() => const HomeView());
                                  Get.snackbar(
                                    'Đăng Nhập Nhanh',
                                    'Chào mừng trở lại, $name!',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: const Color(0xFF161B22),
                                    colorText: Colors.white,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF00E5FF), size: 18),
                          label: const Text('Đăng nhập bằng tài khoản khác', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 13, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            setState(() {
                              _showCustomInputForm = true;
                            });
                          },
                        ),
                      ] else ...[
                        // 2. STANDARD EMAIL/PASSWORD FORM FIELD PANEL
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF00E5FF)),
                            labelText: 'Email',
                            hintText: 'Nhập địa chỉ email của bạn',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.vpn_key_outlined, color: Color(0xFF00E5FF)),
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu bảo mật',
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

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Get.to(() => const ForgotPasswordView()),
                            child: const Text('Quên mật khẩu?', style: TextStyle(color: Color(0xFF00E5FF), fontSize: 12)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text;

                              if (email.isEmpty || password.isEmpty) {
                                Get.snackbar('Cảnh Báo', 'Vui lòng nhập đầy đủ email và mật khẩu.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orangeAccent, colorText: Colors.white);
                                return;
                              }

                              final success = await _authController.login(email, password);
                              if (success) {
                                Get.offAll(() => const HomeView());
                                Get.snackbar('Đăng Nhập Thành Công', 'Chào mừng đến với hệ sinh thái LushMKT.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                              } else {
                                Get.snackbar('Đăng Nhập Thất Bại', 'Email hoặc mật khẩu không chính xác.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E5FF),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _authController.isLoading.value
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                : const Text('ĐĂNG NHẬP NGAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
                          ),
                        ),

                        if (hasSavedAccounts) ...[
                          const SizedBox(height: 16),
                          TextButton(
                            child: const Text('Xem danh sách tài khoản đã lưu', style: TextStyle(color: Colors.grey, fontSize: 13)),
                            onPressed: () {
                              setState(() {
                                _showCustomInputForm = false;
                              });
                            },
                          ),
                        ],
                      ],

                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chưa có tài khoản? ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const RegisterView());
                            },
                            child: const Text(
                              'Đăng ký ngay',
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

  // Build Logo Header with exact custom image asset
  Widget _buildLogoHeader() {
    return Image.asset(
      'image/isometric-b2b-illustration.png',
      height: 160,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // High-end fallback if the asset fails to load
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.02),
            border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.12)),
          ),
          child: const Icon(Icons.rocket_launch_rounded, size: 60, color: Color(0xFF00E5FF)),
        );
      },
    );
  }
}
