import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/payment_repository.dart';

class PaymentController extends GetxController {
  final PaymentRepository _repository = PaymentRepository();

  var balance = 2450000.0.obs;
  var isLoading = false.obs;

  // VietQR Transfer Details
  var bankName = 'MB Bank (Quân Đội)'.obs;
  var accountNumber = '0359261551'.obs;
  var accountHolder = 'NGUYEN VAN DUC'.obs;
  var qrAmount = 50000.0.obs;
  var transferNote = 'LUSH 781029'.obs;

  // Coupon System
  var couponCode = ''.obs;
  var discountRate = 0.0.obs; // e.g. 0.1 for 10%

  var transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() {
    transactions.assignAll([
      TransactionModel(id: 'TX-910283', amount: 500000, type: 'deposit', status: 'success', date: '08:45 - 09/05/2026', description: 'Nạp tiền tự động qua VietQR MB Bank'),
      TransactionModel(id: 'TX-829103', amount: -45000, type: 'payment', status: 'success', date: '12:15 - 08/05/2026', description: 'Mua sản phẩm: VIA FB Cổ Kháng 2FA'),
      TransactionModel(id: 'TX-781023', amount: 100000, type: 'deposit', status: 'success', date: '18:30 - 07/05/2026', description: 'Nạp tiền tự động qua VietQR MB Bank'),
    ]);
  }

  void applyCouponCode(String code) {
    if (code.toUpperCase() == 'LUSH10') {
      discountRate.value = 0.1;
      Get.snackbar('Áp Dụng Thành Công', 'Mã ưu đãi LUSH10 giảm 10% đã được áp dụng.', snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFF161B22), colorText: Colors.white);
    } else {
      discountRate.value = 0.0;
      Get.snackbar('Lỗi Áp Dụng', 'Mã giảm giá không hợp lệ hoặc đã hết hạn.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void simulateDeposit(double amount) {
    balance.value += amount;
    transactions.insert(0, TransactionModel(
      id: 'TX-${100000 + transactions.length}',
      amount: amount,
      type: 'deposit',
      status: 'success',
      date: 'Vừa xong',
      description: 'Nạp tiền tự động qua VietQR MB Bank',
    ));
  }
}
