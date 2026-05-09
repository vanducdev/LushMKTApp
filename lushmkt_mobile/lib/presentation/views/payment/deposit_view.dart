import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/social_controller.dart';
import '../../controllers/auth_controller.dart';

class DepositView extends StatefulWidget {
  const DepositView({super.key});

  @override
  State<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends State<DepositView> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  final SocialController _socialController = Get.find<SocialController>();
  final AuthController _authController = Get.find<AuthController>();

  final _amountController = TextEditingController(text: '100000');
  Timer? _timer;
  int _secondsRemaining = 15 * 60; // 15 minutes
  bool _hasActiveOrder = false;
  String _activeOrderId = '';
  double _activeOrderAmount = 100000;
  String _activeTransferNote = 'LUSH1234';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 15 * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _hasActiveOrder = false;
        });
        Get.snackbar('Hết hạn', 'Đơn nạp tiền đã hết hạn giao dịch.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Đã Sao Chép',
      'Đã sao chép $fieldName vào bộ nhớ tạm.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF161B22),
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _settingsController.isDarkMode.value;
      final Color textColor = isDark ? Colors.white : Colors.black87;
      final Color cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
      final user = _authController.currentUser.value;
      final balance = user?.balance ?? 0.0;

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0D0F14) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(
            'NẠP TIỀN TỰ ĐỘNG',
            style: _settingsController.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          backgroundColor: isDark ? const Color(0xFF0D0F14) : Colors.white,
          elevation: 0,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. BALANCE OVERVIEW CARD
            Card(
              color: const Color(0xFF00E5FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SỐ DƯ HIỆN TẠI', style: _settingsController.getTextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(
                          '${balance.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                          style: _settingsController.getTextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(Icons.account_balance_wallet_rounded, color: Colors.black),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. CHOOSE AMOUNT PANEL (If no active order)
            if (!_hasActiveOrder) ...[
              Text('CHỌN SỐ TIỀN MUỐN NẠP', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.5))),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.monetization_on_outlined, color: Color(0xFF00E5FF)),
                  labelText: 'Số tiền nạp (VND)',
                ),
                style: _settingsController.getTextStyle(fontSize: 13, color: textColor),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(_amountController.text) ?? 100000;
                    _socialController.createDepositOrder(amt);
                    
                    final newestOrder = _socialController.depositOrders.first;
                    setState(() {
                      _hasActiveOrder = true;
                      _activeOrderId = newestOrder.id;
                      _activeOrderAmount = amt;
                      _activeTransferNote = newestOrder.transferNote;
                    });
                    _startTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('TẠO ĐƠN NẠP TIỀN', style: _settingsController.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ] else ...[
              // 3. ACTIVE ORDER VIETQR & COUNTDOWN
              Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: const Color(0xFF00E5FF).withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ĐƠN NẠP TIỀN ĐANG HOẠT ĐỘNG', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 12, color: Colors.redAccent),
                                const SizedBox(width: 4),
                                Text(_formatTime(_secondsRemaining), style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      // QR CODE
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Image.asset(
                          'image/qr-bank.jpg',
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Dynamic VietQR fallback if asset is missing or has issues
                            return Image.network(
                              'https://img.vietqr.io/image/MB-0359261551-compact2.png?amount=${_activeOrderAmount.toInt()}&addInfo=$_activeTransferNote',
                              height: 180,
                              width: 180,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildCopyRow('Ngân hàng:', 'MB Bank (Quân Đội)', textColor),
                      _buildCopyRow('Số tài khoản:', '0359261551', textColor),
                      _buildCopyRow('Chủ tài khoản:', 'NGUYEN VAN DUC', textColor),
                      _buildCopyRow('Số tiền:', '${_activeOrderAmount.toInt()}đ', textColor),
                      _buildCopyRow('Nội dung:', _activeTransferNote, textColor),

                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          _timer?.cancel();
                          setState(() {
                            _hasActiveOrder = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('HỦY ĐƠN NẠP', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      )
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),

            // 4. ADMIN APPROVAL PANEL (Directly accessible inside VIP testing)
            _buildAdminApprovalsPanel(cardColor, textColor),
          ],
        ),
      );
    });
  }

  Widget _buildCopyRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _settingsController.getTextStyle(fontSize: 12, color: Colors.grey)),
          Row(
            children: [
              Text(value, style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _copyToClipboard(value, label),
                child: const Icon(Icons.copy_rounded, color: Color(0xFF00E5FF), size: 14),
              )
            ],
          )
        ],
      ),
    );
  }

  // Interactive admin deposit manager panel
  Widget _buildAdminApprovalsPanel(Color cardColor, Color textColor) {
    final pendingOrders = _socialController.depositOrders.where((o) => o.status == 'pending').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TRANG DUYỆT ĐƠN CỦA ADMIN', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor.withOpacity(0.5))),
        const SizedBox(height: 12),
        Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: _settingsController.isDarkMode.value ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: pendingOrders.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Không có đơn nạp tiền nào đang chờ duyệt.', style: _settingsController.getTextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingOrders.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final order = pendingOrders[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Đơn ${order.id} - ${order.amount.toInt()}đ', style: _settingsController.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                        subtitle: Text('Note: ${order.transferNote}\nUser: ${order.userEmail}', style: _settingsController.getTextStyle(fontSize: 10, color: Colors.grey)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _socialController.adminApproveDeposit(order.id);
                                if (_hasActiveOrder && _activeOrderId == order.id) {
                                  _timer?.cancel();
                                  setState(() {
                                    _hasActiveOrder = false;
                                  });
                                }
                                Get.snackbar('Đã duyệt', 'Đã duyệt cộng tiền thành công cho ${order.userEmail}!', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                              child: Text('DUYỆT', style: _settingsController.getTextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                _socialController.adminDeclineDeposit(order.id);
                                if (_hasActiveOrder && _activeOrderId == order.id) {
                                  _timer?.cancel();
                                  setState(() {
                                    _hasActiveOrder = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4)),
                              child: Text('TỪ CHỐI', style: _settingsController.getTextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        )
      ],
    );
  }
}
