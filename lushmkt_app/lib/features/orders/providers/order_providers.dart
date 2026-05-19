import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model mô tả đơn dịch vụ
class OrderItemModel {
  final String id;
  final String serviceName;
  final String targetLink;
  final int quantity;
  final double totalPrice;
  final String status; // pending, processing, completed, cancelled
  final String date;

  OrderItemModel({
    required this.id,
    required this.serviceName,
    required this.targetLink,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.date,
  });

  OrderItemModel copyWith({
    String? id,
    String? serviceName,
    String? targetLink,
    int? quantity,
    double? totalPrice,
    String? status,
    String? date,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      targetLink: targetLink ?? this.targetLink,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}

// StateNotifier quản lý danh sách đơn dịch vụ, cho phép cập nhật trạng thái động
class OrderHistoryNotifier extends StateNotifier<List<OrderItemModel>> {
  OrderHistoryNotifier() : super([]) {
    _loadInitialOrders();
  }

  void _loadInitialOrders() {
    state = [
      OrderItemModel(
        id: 'OD-78192',
        serviceName: 'Tăng Like Facebook Bài Viết (Tốc độ cao)',
        targetLink: 'https://facebook.com/post/123456789',
        quantity: 1000,
        totalPrice: 4000.0,
        status: 'processing',
        date: '09:30 - 09/05/2026',
      ),
      OrderItemModel(
        id: 'OD-67123',
        serviceName: 'Tăng Follow Trang Cá Nhân VIP',
        targetLink: 'https://facebook.com/profile/1000213123',
        quantity: 500,
        totalPrice: 6000.0,
        status: 'completed',
        date: '15:20 - 08/05/2026',
      ),
      OrderItemModel(
        id: 'OD-99012',
        serviceName: 'Buff Comment Facebook Động',
        targetLink: 'https://facebook.com/post/99887766',
        quantity: 100,
        totalPrice: 800.0,
        status: 'pending',
        date: 'Vừa xong',
      ),
    ];
  }

  // Thêm đơn hàng mới
  void addOrder(OrderItemModel order) {
    state = [order, ...state];
  }

  // Giả lập cập nhật trạng thái đơn (pending -> processing -> completed)
  void simulateNextStatus(String id) {
    state = [
      for (final order in state)
        if (order.id == id)
          order.copyWith(status: _getNextStatus(order.status))
        else
          order
    ];
  }

  String _getNextStatus(String current) {
    switch (current) {
      case 'pending':
        return 'processing';
      case 'processing':
        return 'completed';
      case 'completed':
        return 'cancelled';
      case 'cancelled':
        return 'pending';
      default:
        return 'pending';
    }
  }
}

// Provider quản lý danh sách đơn
final orderHistoryProvider = StateNotifierProvider<OrderHistoryNotifier, List<OrderItemModel>>((ref) {
  return OrderHistoryNotifier();
});
