import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lushmkt_app/core/network/api_service.dart';

// Provider cho Dio Client thô
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = ApiService.baseUrl;
  dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.receiveTimeout = const Duration(seconds: 15);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Accept'] = 'application/json';
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          // Xử lý token hết hạn toàn cục (nếu cần)
        }
        return handler.next(error);
      },
    ),
  );
  return dio;
});

// Provider cho ApiService bọc ngoài
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
