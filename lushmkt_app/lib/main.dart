import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/routes/app_router.dart';
import 'package:lushmkt_app/services/storage_service.dart';

void main() async {
  // Đảm bảo các dịch vụ hệ thống của Flutter được liên kết đầy đủ
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Khởi động Hive và SharedPreferences trước khi vẽ giao diện
  final storageService = await StorageService.init();
  
  runApp(
    // 2. Wrap ứng dụng trong ProviderScope để kích hoạt Riverpod State Management
    ProviderScope(
      overrides: [
        // Ghi đè Provider bằng thực thể đã khởi tạo đồng bộ thành công
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const LushMktApp(),
    ),
  );
}

// Chuyển đổi sang ConsumerWidget để lắng nghe các Providers của Riverpod
class LushMktApp extends ConsumerWidget {
  const LushMktApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Lắng nghe cấu hình Router khai báo từ GoRouter
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'LushMKT',
      debugShowCheckedModeBanner: false,
      
      // 4. Liên kết luồng điều hướng GoRouter
      routerConfig: router,
      
      // Mặc định luôn dùng chế độ Dark Cyber Mode
      themeMode: ThemeMode.dark,
      
      // Cấu hình Theme Cyber Dark cao cấp
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F14), // Nền không gian tối sâu
        primaryColor: const Color(0xFF00E5FF),          // Cyan phát sáng
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF7000FF),                 // Purple huyền bí
          background: Color(0xFF0D0F14),
          surface: Color(0xFF161B22),                   // Card dark
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          error: Color(0xFFFF2D55),
        ),
        textTheme: GoogleFonts.orbitronTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF161B22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
