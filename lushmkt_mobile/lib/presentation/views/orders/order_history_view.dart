import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController _controller = Get.put(OrderController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('LỊCH SỬ ĐƠN DỊCH VỤ', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF0D0F14)),
          
          SafeArea(
            child: Obx(() {
              if (_controller.orders.isEmpty) {
                return const Center(
                  child: Text('Chưa có lịch sử đơn hàng nào.', style: TextStyle(color: Colors.grey)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _controller.orders.length,
                itemBuilder: (context, index) {
                  final order = _controller.orders[index];
                  final status = order['status'] ?? 'Đang chờ';
                  Color statusColor = Colors.grey;
                  if (status == 'Hoàn thành') {
                    statusColor = Colors.green;
                  } else if (status == 'Đang chạy') {
                    statusColor = const Color(0xFF00E5FF);
                  } else if (status == 'Đang chờ duyệt') {
                    statusColor = const Color(0xFFFFCC00);
                  }

                  return Container(
                    margin: const EdgeInsets.bottom(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['id'] ?? 'OD-00000',
                              style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          order['service_name'] ?? 'Dịch vụ Facebook',
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order['target_link'] ?? '',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.white.withOpacity(0.04)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Số lượng: ${order['quantity']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Text(
                              'Thành tiền: ${order['total_price']}',
                              style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 13, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order['date'] ?? '',
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        )
                      ],
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
