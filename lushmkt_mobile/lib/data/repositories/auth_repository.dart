import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.lushmkt.com/api', // Production Backend URL
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> login(String email, String password) async {
    return await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

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

  Future<Response> verifyOtp(String email, String otp) async {
    return await _dio.post('/auth/verify-otp', data: {
      'email': email,
      'otp': otp,
    });
  }

  Future<Response> forgotPassword(String email) async {
    return await _dio.post('/auth/forgot-password', data: {
      'email': email,
    });
  }

  Future<Response> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    return await _dio.post('/auth/reset-password', data: {
      'email': email,
      'otp': otp,
      'password': password,
    });
  }
}
