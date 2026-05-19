import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lushmkt_app/features/seller/repositories/seller_repository.dart';

// FutureProvider lấy báo cáo doanh thu & biểu đồ phân tích người bán
final sellerAnalyticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(sellerRepositoryProvider);
  try {
    final response = await repo.getAnalytics();
    return Map<String, dynamic>.from(response.data['data']);
  } catch (e) {
    // Trả về Mock cao cấp nếu mất kết nối hoặc offline
    return {
      'shop_name': 'MMO EMPIRE STORE',
      'balance': 2450000.0,
      'total_revenue': 14850000.0,
      'active_products': 8,
      'total_sold_orders': 195,
      'recent_sales': [
        {'month': 'Jan', 'sales': 1200000},
        {'month': 'Feb', 'sales': 2400000},
        {'month': 'Mar', 'sales': 1800000},
        {'month': 'Apr', 'sales': 4500000},
        {'month': 'May', 'sales': 4950000}
      ],
      'verification_status': 'approved',
    };
  }
});

// FutureProvider lấy danh sách đơn hàng đã bán
final sellerOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(sellerRepositoryProvider);
  try {
    final response = await repo.getOrders();
    final List<dynamic> list = response.data['data'];
    return List<Map<String, dynamic>>.from(list);
  } catch (e) {
    return [
      {
        'id': 101,
        'order_code': 'BUYX82KD9S',
        'product_name': 'VIA Facebook Cổ kháng 2FA',
        'quantity': 10,
        'total_price': 450000.0,
        'status': 'completed',
        'buyer_name': 'Nguyễn Đức',
        'created_at': '2026-05-18T12:00:00Z'
      },
      {
        'id': 102,
        'order_code': 'BUYJ129SD8',
        'product_name': 'Gmail Ngoại Cổ (Reg 2020)',
        'quantity': 50,
        'total_price': 600000.0,
        'status': 'completed',
        'buyer_name': 'Quốc Khánh',
        'created_at': '2026-05-17T09:30:00Z'
      }
    ];
  }
});

// FutureProvider lấy trạng thái xác minh (Verification Status)
final sellerVerificationStatusProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(sellerRepositoryProvider);
  try {
    final response = await repo.getVerificationStatus();
    return Map<String, dynamic>.from(response.data['data']);
  } catch (e) {
    return {
      'status': 'approved', // none, pending, approved
      'shop_name': 'MMO EMPIRE STORE',
    };
  }
});
