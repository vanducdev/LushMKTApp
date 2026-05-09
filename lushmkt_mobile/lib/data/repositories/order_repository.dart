import 'package:dio/dio.dart';

class OrderRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.lushmkt.com/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> getServices() async {
    return await _dio.get('/services');
  }

  Future<Response> createServiceOrder({
    required int serviceId,
    required int quantity,
    required String targetLink,
  }) async {
    return await _dio.post('/orders/service', data: {
      'service_id': serviceId,
      'quantity': quantity,
      'target_link': targetLink,
    });
  }

  Future<Response> getOrderHistory() async {
    return await _dio.get('/orders/history');
  }
}
