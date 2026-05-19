import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lushmkt_app/core/providers/network_providers.dart';

// Provider quản lý SellerRepository để tiêm vào các Controller/Notifiers khác
final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SellerRepository(dio);
});

class SellerRepository {
  final Dio _dio;

  SellerRepository(this._dio);

  /// 1. Lấy báo cáo phân tích & doanh thu người bán
  Future<Response> getAnalytics() async {
    return await _dio.get('/seller/analytics');
  }

  /// 2. Lấy danh sách đơn hàng khách đã mua
  Future<Response> getOrders() async {
    return await _dio.get('/seller/orders');
  }

  /// 3. Đăng bán sản phẩm mới
  Future<Response> uploadProduct({
    required String name,
    required double price,
    required int stockQuantity,
    required String category,
    required String description,
    required String warrantyPolicy,
  }) async {
    return await _dio.post('/seller/products', data: {
      'name': name,
      'price': price,
      'stock_quantity': stockQuantity,
      'category': category,
      'description': description,
      'warranty_policy': warrantyPolicy,
    });
  }

  /// 4. Gửi hồ sơ xác minh (Upload giấy tờ, Avatar, Shop Name)
  Future<Response> verifySeller({
    required String avatarUrl,
    required String documentUrl,
    required String shopName,
  }) async {
    return await _dio.post('/seller/verify', data: {
      'avatar_url': avatarUrl,
      'document_url': documentUrl,
      'shop_name': shopName,
    });
  }

  /// 5. Lấy trạng thái duyệt người bán
  Future<Response> getVerificationStatus() async {
    return await _dio.get('/seller/status');
  }

  /// 6. Tạo yêu cầu rút tiền mặt
  Future<Response> withdrawFunds({
    required double amount,
    required String bankName,
    required String bankAccountNumber,
    required String bankAccountName,
  }) async {
    return await _dio.post('/seller/withdraw', data: {
      'amount': amount,
      'bank_name': bankName,
      'bank_account_number': bankAccountNumber,
      'bank_account_name': bankAccountName,
    });
  }
}
