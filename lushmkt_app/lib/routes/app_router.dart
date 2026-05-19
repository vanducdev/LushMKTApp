import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import Views
import 'package:lushmkt_app/features/splash/views/splash_view.dart';
import 'package:lushmkt_app/features/auth/views/login_view.dart';
import 'package:lushmkt_app/features/auth/views/register_view.dart';
import 'package:lushmkt_app/features/auth/views/otp_verification_view.dart';
import 'package:lushmkt_app/features/auth/views/forgot_password_view.dart';
import 'package:lushmkt_app/features/home/views/home_view.dart';
import 'package:lushmkt_app/features/notifications/views/notifications_view.dart';
import 'package:lushmkt_app/features/orders/views/order_history_view.dart';
import 'package:lushmkt_app/features/wallet/views/deposit_view.dart';
import 'package:lushmkt_app/features/marketplace/views/product_purchase_view.dart';
import 'package:lushmkt_app/features/marketplace/views/service_order_view.dart';
import 'package:lushmkt_app/features/profile/views/profile_view.dart';
import 'package:lushmkt_app/features/profile/views/settings_view.dart';
import 'package:lushmkt_app/features/profile/views/tickets_view.dart';
import 'package:lushmkt_app/features/seller/views/seller_dashboard_view.dart';
import 'package:lushmkt_app/features/chat/views/chat_view.dart';

// Provider quản lý Auth Token ảo để GoRouter lắng nghe và tự động chuyển hướng
final authTokenProvider = StateProvider<String>((ref) => "");

// Provider thiết lập cấu hình GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  final token = ref.watch(authTokenProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      
      // Authentication
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpVerificationView(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordView(),
      ),
      
      // Main Application Client Screens
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsView(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryView(),
      ),
      GoRoute(
        path: '/wallet',
        builder: (context, state) => const DepositView(),
      ),
      GoRoute(
        path: '/product-purchase',
        builder: (context, state) => const ProductPurchaseView(),
      ),
      GoRoute(
        path: '/service-order',
        builder: (context, state) => const ServiceOrderView(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: '/tickets',
        builder: (context, state) => const TicketsView(),
      ),
      GoRoute(
        path: '/seller',
        builder: (context, state) => const SellerDashboardView(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatView(),
      ),
    ],
    
    // Logic bảo mật chuyển hướng tự động (Guards & Auto Redirect)
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' ||
                          state.matchedLocation == '/register' ||
                          state.matchedLocation == '/forgot-password' ||
                          state.matchedLocation == '/otp' ||
                          state.matchedLocation == '/splash';

      // Nếu chưa có token mà cố truy cập vào các màn chính -> Đẩy về Login
      if (token.isEmpty && !isLoggingIn) {
        return '/login';
      }

      // Nếu đã đăng nhập thành công mà vẫn truy cập màn Login -> Đẩy thẳng vào Home
      if (token.isNotEmpty && state.matchedLocation == '/login') {
        return '/';
      }

      return null;
    },
  );
});
