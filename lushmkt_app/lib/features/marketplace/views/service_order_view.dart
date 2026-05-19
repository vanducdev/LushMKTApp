import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lushmkt_app/features/orders/controllers/order_controller.dart';
import 'package:lushmkt_app/features/orders/views/order_history_view.dart';

class ServiceOrderView extends StatefulWidget {
  final String? serviceName;
  final double? basePrice;

  const ServiceOrderView({
    super.key,
    this.serviceName,
    this.basePrice,
  });

  @override
  State<ServiceOrderView> createState() => _ServiceOrderViewState();
}

class _ServiceOrderViewState extends State<ServiceOrderView> {
  final OrderController _controller = Get.put(OrderController());
  final _linkController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = _controller.quantity.value.toString();
    _linkController.addListener(() {
      _controller.targetLink.value = _linkController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ĐẶT ĐƠN DỊCH VỤ',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFF00E5FF)),
            onPressed: () => Get.to(() => const OrderHistoryView()),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF0D0F14)),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHỌN GÓI DỊCH VỤ FACEBOOK',
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),

                  // 1. Service Dropdown Selection
                  Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        value: _controller.selectedService.value,
                        dropdownColor: const Color(0xFF161B22),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF00E5FF)),
                        items: _controller.services.map((service) {
                          return DropdownMenuItem<dynamic>(
                            value: service,
                            child: Text(
                              service.name,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          _controller.selectedService.value = val;
                          _controller.calculatePrice();
                        },
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),

                  // 2. Target Link Input
                  const Text(
                    'ĐƯỜNG DẪN BÀI VIẾT / TRANG CÁ NHÂN',
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _linkController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'https://facebook.com/...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.link_rounded, color: Color(0xFF00E5FF)),
                      filled: true,
                      fillColor: const Color(0xFF161B22),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00E5FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Quantity Input
                  const Text(
                    'SỐ LƯỢNG CẦN BUFF',
                    style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.add_task_rounded, color: Color(0xFF00E5FF)),
                      filled: true,
                      fillColor: const Color(0xFF161B22),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00E5FF)),
                      ),
                    ),
                    onChanged: (val) {
                      final intQty = int.tryParse(val) ?? 100;
                      _controller.quantity.value = intQty;
                      _controller.calculatePrice();
                    },
                  ),
                  const SizedBox(height: 30),

                  // 4. Pricing Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Đơn giá mỗi tương tác:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Obx(() => Text(
                              '${_controller.selectedService.value?.pricePerOne ?? 0.0}đ',
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey, thickness: 0.1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng chi phí dự kiến:', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                            Obx(() => Text(
                              '${_controller.totalPrice.value.toInt()}đ',
                              style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 16, fontWeight: FontWeight.bold),
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 5. Submit Order Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _controller.isLoading.value
                          ? null
                          : () async {
                              if (_linkController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Thiếu Thông Tin',
                                  'Vui lòng dán liên kết Facebook để tiếp tục.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              final success = await _controller.createOrder();
                              if (success) {
                                Get.snackbar(
                                  'Tạo Đơn Thành Công',
                                  'Yêu cầu của bạn đã được gửi lên hàng đợi máy chủ thành công.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                                _linkController.clear();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 8,
                        shadowColor: const Color(0xFF00E5FF).withOpacity(0.3),
                      ),
                      child: _controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                          : const Text(
                              'TẠO ĐƠN NGAY',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
