import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lushmkt_app/routes/app_router.dart';

// Chuyển đổi sang ConsumerStatefulWidget để sử dụng Riverpod trong StatefulWidget
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Kiểm tra trạng thái đăng nhập tự động bằng Riverpod + GoRouter
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      // Đọc trạng thái token từ Provider của Riverpod
      final token = ref.read(authTokenProvider);
      
      if (token.isNotEmpty) {
        // Điều hướng khai báo sử dụng GoRouter
        context.go('/');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền tối sẫm thương hiệu
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0D0F14),
            ),
          ),
          
          // Điểm phát sáng mờ ảo ở góc (Glow Effect)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withOpacity(0.08),
                    blurRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container Icon thương hiệu viền neon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.02),
                        border: Border.all(
                          color: const Color(0xFF00E5FF).withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        size: 70,
                        color: Color(0xFF00E5FF),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Tên ứng dụng Orbitron
                    const Text(
                      'LushMKT',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'THE PREMIER MMO MARKETPLACE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // Progress Indicator chạy mượt mà
                    SizedBox(
                      width: 160,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const LinearProgressIndicator(
                              color: Color(0xFF00E5FF),
                              backgroundColor: Color(0xFF161B22),
                              minHeight: 3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'KẾT NỐI HỆ THỐNG AN TOÀN...',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
