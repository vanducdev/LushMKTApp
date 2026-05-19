import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lushmkt_app/core/providers/network_providers.dart';

// Provider quản lý AuthRepository để tiêm vào các Controller/Notifiers khác
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// 1. Đăng nhập truyền thống
  Future<Response> login(String email, String password) async {
    return await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  /// 2. Đăng ký tài khoản mới
  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  /// 3. Gia hạn Token (JWT Refresh)
  Future<Response> refreshToken(String refreshToken) async {
    return await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
  }

  /// 4. Gửi mã OTP xác thực
  Future<Response> sendOtp(String email) async {
    return await _dio.post('/auth/send-otp', data: {
      'email': email,
    });
  }

  /// 5. Xác minh mã OTP đăng nhập
  Future<Response> verifyOtp(String email, String otp) async {
    return await _dio.post('/auth/verify-otp', data: {
      'email': email,
      'otp': otp,
    });
  }

  /// 6. Đăng nhập Mạng xã hội (Google / Apple)
  Future<Response> socialLogin({
    required String provider,
    required String socialId,
    required String email,
    required String name,
  }) async {
    return await _dio.post('/auth/social-login', data: {
      'provider': provider,
      'social_id': socialId,
      'email': email,
      'name': name,
    });
  }

  /// 7. Đăng nhập Sinh trắc học Face ID
  Future<Response> faceIdLogin({
    required String email,
    required String faceIdToken,
  }) async {
    return await _dio.post('/auth/faceid-login', data: {
      'email': email,
      'face_id_token': faceIdToken,
    });
  }

  /// 8. Đăng xuất tài khoản
  Future<Response> logout() async {
    return await _dio.post('/auth/logout');
  }

  /// 9. Quên mật khẩu
  Future<Response> forgotPassword(String email) async {
    return await _dio.post('/auth/forgot-password', data: {
      'email': email,
    });
  }
}
