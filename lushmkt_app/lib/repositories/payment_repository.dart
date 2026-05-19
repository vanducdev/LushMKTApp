import 'package:dio/dio.dart';

class PaymentRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.lushmkt.com/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> generateQr(double amount) async {
    return await _dio.post('/payment/generate-qr', data: {'amount': amount});
  }

  Future<Response> getTransactionHistory() async {
    return await _dio.get('/payment/transactions');
  }

  Future<Response> applyCoupon(String coupon) async {
    return await _dio.post('/payment/coupon', data: {'code': coupon});
  }
}
