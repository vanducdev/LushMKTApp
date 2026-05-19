import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/features/orders/providers/order_providers.dart';

class OrderHistoryView extends ConsumerWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'LỊCH SỬ ĐƠN DỊCH VỤ',
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Info Note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Nhấn vào đơn hàng để xem tiến trình chạy tương tác thời gian thực và thông tin bảo hành.',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
            ),
            
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Text(
                        'Chưa có lịch sử đơn hàng nào.',
                        style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _buildOrderCard(context, ref, order);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Khung hiển thị thẻ đơn hàng dịch vụ (Order card item)
  Widget _buildOrderCard(BuildContext context, WidgetRef ref, OrderItemModel order) {
    Color statusColor = Colors.grey;
    String statusText = order.status;

    if (order.status == 'completed') {
      statusColor = const Color(0xFF00FF88); // Neon Green
      statusText = 'Hoàn thành';
    } else if (order.status == 'processing') {
      statusColor = const Color(0xFF00E5FF); // Neon Blue
      statusText = 'Đang chạy';
    } else if (order.status == 'pending') {
      statusColor = const Color(0xFFFFD740); // Neon Yellow
      statusText = 'Đang chờ duyệt';
    } else if (order.status == 'cancelled') {
      statusColor = const Color(0xFFFF5252); // Red
      statusText = 'Đã hủy';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00E5FF).withOpacity(0.04),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mã đơn & Trạng thái
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Text(
                  statusText.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),

          // Tên dịch vụ buff
          Text(
            order.serviceName,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Link cần buff
          Text(
            order.targetLink,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 12),

          // Số lượng & Giá tiền
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số lượng: ${order.quantity}',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
              Text(
                '${order.totalPrice.toInt()} ₫',
                style: GoogleFonts.orbitron(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00E5FF),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),

          // Ngày & Nút xem tiến độ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.date,
                style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
              ),
              InkWell(
                onTap: () => _showOrderProgressModal(context, ref, order.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'TIẾN TRÌNH',
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00E5FF),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.analytics_outlined, color: Color(0xFF00E5FF), size: 10),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// BOTTOM SHEET: Theo dõi tiến độ đơn hàng thời gian thực (Order Progress details)
  void _showOrderProgressModal(BuildContext context, WidgetRef ref, String orderId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0F14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            // Xem sự thay đổi trạng thái ngay lập tức trên Bottom Sheet!
            final activeOrders = ref.watch(orderHistoryProvider);
            final order = activeOrders.firstWhere((o) => o.id == orderId);

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  // Mã & Nút Giả lập chạy trực tiếp
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'THEO DÕI TIẾN TRÌNH ĐƠN',
                        style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(orderHistoryProvider.notifier).simulateNextStatus(order.id);
                        },
                        icon: const Icon(Icons.bolt_rounded, color: Colors.black, size: 12),
                        label: const Text('GIẢ LẬP CHẠY'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E5FF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    order.serviceName,
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Link buff: ${order.targetLink}',
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // ANIMATED TIMELINE STEPPER UI
                  _buildTimelineStep(
                    '1',
                    'ĐÃ TIẾP NHẬN (PENDING)',
                    'Đơn hàng buff tương tác đã được hệ thống ghi nhận thành công và lập lịch hàng đợi.',
                    _isStepActive(order.status, 1),
                    _isStepCompleted(order.status, 1),
                  ),
                  _buildTimelineConnector(_isStepCompleted(order.status, 1)),
                  
                  _buildTimelineStep(
                    '2',
                    'ĐANG KHỞI CHẠY (PROCESSING)',
                    'Hệ thống đang kết nối trực tiếp với API nhà mạng và phân phối lưu lượng tương tác.',
                    _isStepActive(order.status, 2),
                    _isStepCompleted(order.status, 2),
                  ),
                  _buildTimelineConnector(_isStepCompleted(order.status, 2)),

                  _buildTimelineStep(
                    '3',
                    'HOÀN THÀNH (COMPLETED)',
                    'Giao dịch chạy tương tác hoàn tất 100% chỉ số. Đơn hàng kích hoạt chính sách bảo hành VIP.',
                    _isStepActive(order.status, 3),
                    _isStepCompleted(order.status, 3),
                  ),

                  // Cảnh báo hủy nếu có
                  if (order.status == 'cancelled') ...[
                    _buildTimelineConnector(true, isError: true),
                    _buildTimelineStep(
                      '!',
                      'ĐƠN ĐÃ HỦY (CANCELLED)',
                      'Đơn hàng buff tương tác bị lỗi hoặc link mục tiêu không hợp lệ. Số dư đã được hoàn lại ví.',
                      true,
                      false,
                      isError: true,
                    ),
                  ],

                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('ĐÓNG QUAN SÁT', style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold)),
                  )
                ],
              );
            };
          },
        );
      },
    );
  }

  // Helpers kiểm định tiến trình
  bool _isStepActive(String status, int step) {
    if (status == 'pending' && step == 1) return true;
    if (status == 'processing' && step == 2) return true;
    if (status == 'completed' && step == 3) return true;
    return false;
  }

  bool _isStepCompleted(String status, int step) {
    if (status == 'completed') return true;
    if (status == 'processing' && step < 2) return true;
    return false;
  }

  /// Hộp vẽ từng bước Timeline Stepper
  Widget _buildTimelineStep(String number, String title, String subtitle, bool isActive, bool isCompleted, {bool isError = false}) {
    Color stepColor = Colors.grey;
    IconData icon = Icons.circle;

    if (isActive) {
      stepColor = isError ? const Color(0xFFFF5252) : const Color(0xFF00E5FF);
      icon = isError ? Icons.error_outline : Icons.play_arrow_rounded;
    } else if (isCompleted) {
      stepColor = const Color(0xFF00FF88);
      icon = Icons.check_circle_rounded;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hình tròn chứa số hoặc check icon
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: stepColor.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(color: stepColor, width: 1.5),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: Color(0xFF00FF88), size: 14)
              : Text(
                  number,
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: stepColor,
                  ),
                ),
        ),
        const SizedBox(width: 16),

        // Text tiêu đề & mô tả bước
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isActive || isCompleted ? Colors.white : Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.grey,
                  height: 1.4,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /// Vẽ thanh kết nối dọc Timeline
  Widget _buildTimelineConnector(bool isCompleted, {bool isError = false}) {
    Color connectorColor = isCompleted
        ? const Color(0xFF00FF88)
        : (isError ? const Color(0xFFFF5252) : Colors.white10);

    return Container(
      width: 1.5,
      height: 28,
      margin: const EdgeInsets.only(left: 11),
      color: connectorColor,
    );
  }
}
