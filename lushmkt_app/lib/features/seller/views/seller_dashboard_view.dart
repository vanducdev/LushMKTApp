import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/features/seller/providers/seller_providers.dart';
import 'package:lushmkt_app/features/seller/repositories/seller_repository.dart';

class SellerDashboardView extends ConsumerStatefulWidget {
  const SellerDashboardView({super.key});

  @override
  ConsumerState<SellerDashboardView> createState() => _SellerDashboardViewState();
}

class _SellerDashboardViewState extends ConsumerState<SellerDashboardView> {
  // Controllers cho Đăng sản phẩm mới
  final _prodNameController = TextEditingController();
  final _prodPriceController = TextEditingController();
  final _prodStockController = TextEditingController();
  final _prodCategoryController = TextEditingController();
  final _prodDescController = TextEditingController();
  final _prodWarrantyController = TextEditingController();

  // Controllers cho Rút tiền
  final _withdrawAmountController = TextEditingController();
  final _withdrawBankNameController = TextEditingController();
  final _withdrawAccNumController = TextEditingController();
  final _withdrawAccNameController = TextEditingController();

  // Controllers cho Xác minh
  final _verifyShopNameController = TextEditingController();
  final _verifyAvatarUrlController = TextEditingController();
  final _verifyDocUrlController = TextEditingController();

  @override
  void dispose() {
    _prodNameController.dispose();
    _prodPriceController.dispose();
    _prodStockController.dispose();
    _prodCategoryController.dispose();
    _prodDescController.dispose();
    _prodWarrantyController.dispose();

    _withdrawAmountController.dispose();
    _withdrawBankNameController.dispose();
    _withdrawAccNumController.dispose();
    _withdrawAccNameController.dispose();

    _verifyShopNameController.dispose();
    _verifyAvatarUrlController.dispose();
    _verifyDocUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(sellerAnalyticsProvider);
    final ordersAsync = ref.watch(sellerOrdersProvider);
    final verificationAsync = ref.watch(sellerVerificationStatusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'SELLER CENTER',
          style: GoogleFonts.orbitron(
            fontSize: 16,
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
        child: RefreshIndicator(
          color: const Color(0xFF00E5FF),
          backgroundColor: const Color(0xFF161B22),
          onRefresh: () async {
            ref.invalidate(sellerAnalyticsProvider);
            ref.invalidate(sellerOrdersProvider);
            ref.invalidate(sellerVerificationStatusProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. SELLER VERIFICATION STATUS BAR
                verificationAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                  data: (verif) => _buildVerificationBanner(verif['status'] ?? 'none'),
                ),
                const SizedBox(height: 16),

                // 2. DASHBOARD ANALYTICS (Revenue, Balance, Products, Orders)
                analyticsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
                  error: (e, s) => const Center(child: Text('Lỗi tải dữ liệu doanh thu.')),
                  data: (data) => _buildAnalyticsSection(data),
                ),
                const SizedBox(height: 24),

                // 3. ACTION QUICK BUTTONS (Upload, Withdraw, Verify)
                _buildActionButtons(context),
                const SizedBox(height: 24),

                // 4. BUSINESS GRAPH / CHART
                analyticsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                  data: (data) => _buildBusinessChart(List<Map<String, dynamic>>.from(data['recent_sales'] ?? [])),
                ),
                const SizedBox(height: 24),

                // 5. ORDER RECEIVED LIST (Quản lý đơn)
                Text(
                  'QUẢN LÝ ĐƠN HÀNG VỪA BÁN',
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                ordersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => const Text('Lỗi tải đơn hàng.'),
                  data: (orders) => _buildOrdersList(orders),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Banner Trạng thái Duyệt Người Bán (Verification Status Banner)
  Widget _buildVerificationBanner(String status) {
    Color bannerColor = const Color(0xFFFF5252); // Red for None
    String text = "CHƯA XÁC MINH CỬA HÀNG (SHOP UNVERIFIED)";
    IconData icon = Icons.warning_amber_rounded;

    if (status == 'pending') {
      bannerColor = const Color(0xFFFFD740); // Yellow for Pending
      text = "HỒ SƠ ĐANG CHỜ DUYỆT (VERIFICATION PENDING)";
      icon = Icons.hourglass_empty_rounded;
    } else if (status == 'approved') {
      bannerColor = const Color(0xFF00E5FF); // Cyan/Green for Approved
      text = "CỬA HÀNG ĐÃ XÁC MINH (VERIFIED MERCHANT)";
      icon = Icons.verified_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: bannerColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: bannerColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.orbitron(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          if (status == 'none')
            ElevatedButton(
              onPressed: () => _showVerificationModal(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: GoogleFonts.orbitron(fontSize: 9, fontWeight: FontWeight.bold),
              ),
              child: const Text('XÁC MINH'),
            ),
        ],
      ),
    );
  }

  /// 2. Khung Thống kê doanh số (Analytics)
  Widget _buildAnalyticsSection(Map<String, dynamic> data) {
    final balance = (data['balance'] ?? 0.0) as double;
    final totalRevenue = (data['total_revenue'] ?? 0.0) as double;

    return Column(
      children: [
        // Doanh thu lớn
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF7000FF).withOpacity(0.15),
                const Color(0xFF161B22),
              ],
            ),
            border: Border.all(
              color: const Color(0xFF7000FF).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TỔNG DOANH THU CỬA HÀNG',
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${totalRevenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Doanh thu trọn đời, tự động cập nhật liên tục',
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Hàng con 3 cột nhỏ
        Row(
          children: [
            Expanded(
              child: _buildSmallAnalyticsItem(
                'VÍ NGƯỜI BÁN',
                '${balance.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}đ',
                const Color(0xFF00E5FF),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSmallAnalyticsItem(
                'SẢN PHẨM BÁN',
                '${data['active_products']} CỔ',
                const Color(0xFFFFD740),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSmallAnalyticsItem(
                'ĐƠN ĐÃ BÁN',
                '${data['total_sold_orders']} ĐƠN',
                const Color(0xFF00FF88),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSmallAnalyticsItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.02),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  /// 3. Các nút Hành động Nhanh (Upload, Withdraw, Verify)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showUploadProductModal(context),
            icon: const Icon(Icons.add_photo_alternate_rounded, size: 16, color: Color(0xFF00E5FF)),
            label: const Text('ĐĂNG SẢN PHẨM'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF00E5FF),
              side: const BorderSide(color: Color(0xFF00E5FF)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showWithdrawModal(context),
            icon: const Icon(Icons.account_balance_rounded, size: 16, color: Colors.black),
            label: const Text('RÚT TIỀN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// 4. Biểu đồ doanh thu tuyến tính dạng cột (Custom Bar Chart)
  Widget _buildBusinessChart(List<Map<String, dynamic>> sales) {
    if (sales.isEmpty) return const SizedBox.shrink();

    // Tìm max để tỷ lệ hóa cột vẽ
    double maxSale = 1.0;
    for (var s in sales) {
      final val = double.tryParse(s['sales'].toString()) ?? 1.0;
      if (val > maxSale) maxSale = val;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.02),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PHÂN TÍCH DOANH SỐ (5 THÁNG VỪA QUA)',
            style: GoogleFonts.orbitron(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sales.map((s) {
              final val = double.tryParse(s['sales'].toString()) ?? 0.0;
              final ratio = val / maxSale;
              final colHeight = 100 * ratio; // Scale to max 100px height

              return Column(
                children: [
                  Text(
                    '${(val / 1000000).toStringAsFixed(1)}M',
                    style: GoogleFonts.orbitron(fontSize: 8, color: const Color(0xFF00E5FF), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 14,
                    height: colHeight == 0 ? 4 : colHeight,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF00E5FF),
                          Color(0xFF7000FF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s['month'] ?? '',
                    style: GoogleFonts.orbitron(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// 5. Danh sách Quản lý Đơn Hàng đã bán (Orders received list)
  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Chưa có đơn hàng nào được mua.', style: GoogleFonts.inter(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.02),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF88).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.outbound_rounded, color: Color(0xFF00FF88), size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['product_name'] ?? '',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Khách: ${order['buyer_name']} • Số lượng: ${order['quantity']} acc',
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${(order['total_price'] ?? 0.0).toInt()}đ',
                    style: GoogleFonts.orbitron(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF00FF88)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MÃ: ${order['order_code']}',
                    style: GoogleFonts.orbitron(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /// ================= FORMS & DRAWERS MODALS =================

  /// FORM ĐĂNG BÁN SẢN PHẨM MỚI (Upload product form modal)
  void _showUploadProductModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0F14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                ),
                Text(
                  'ĐĂNG BÁN TÀI NGUYÊN MMO',
                  style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                ),
                const SizedBox(height: 20),
                _buildModalTextField(_prodNameController, 'Tên tài nguyên (VIA cổ, Gmail ngâm, Proxy...)', Icons.badge_outlined),
                const SizedBox(height: 12),
                _buildModalTextField(_prodPriceController, 'Đơn giá bán (VND)', Icons.payments_outlined, isNumeric: true),
                const SizedBox(height: 12),
                _buildModalTextField(_prodStockController, 'Số lượng tồn kho ban đầu', Icons.inventory_2_outlined, isNumeric: true),
                const SizedBox(height: 12),
                _buildModalTextField(_prodCategoryController, 'Danh mục (Ví dụ: VIA Facebook, Gmail, Proxy)', Icons.grid_view_rounded),
                const SizedBox(height: 12),
                _buildModalTextField(_prodDescController, 'Mô tả chi tiết cách thức ngâm acc', Icons.description_outlined, maxLines: 3),
                const SizedBox(height: 12),
                _buildModalTextField(_prodWarrantyController, 'Chính sách bảo hành VIP', Icons.gavel_outlined, maxLines: 2),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final name = _prodNameController.text.trim();
                    final price = double.tryParse(_prodPriceController.text) ?? 0.0;
                    final stock = int.tryParse(_prodStockController.text) ?? 0;
                    final cat = _prodCategoryController.text.trim();
                    final desc = _prodDescController.text.trim();
                    final warranty = _prodWarrantyController.text.trim();

                    if (name.isEmpty || cat.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên và danh mục sản phẩm.')));
                      return;
                    }

                    final repo = ref.read(sellerRepositoryProvider);
                    try {
                      await repo.uploadProduct(
                        name: name,
                        price: price,
                        stockQuantity: stock,
                        category: cat,
                        description: desc,
                        warrantyPolicy: warranty,
                      );
                      ref.invalidate(sellerAnalyticsProvider);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đăng bán sản phẩm thành công! Đang chờ Admin phê duyệt.'), backgroundColor: Color(0xFF00E5FF)),
                      );
                      
                      // Clear forms
                      _prodNameController.clear();
                      _prodPriceController.clear();
                      _prodStockController.clear();
                      _prodCategoryController.clear();
                      _prodDescController.clear();
                      _prodWarrantyController.clear();
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi gửi hồ sơ đăng bán.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('ĐĂNG BÁN NGAY', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  /// FORM THỰC HIỆN RÚT TIỀN MẶT (Withdraw funds form modal)
  void _showWithdrawModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0F14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                ),
                Text(
                  'YÊU CẦU RÚT TIỀN DOANH THU',
                  style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                ),
                const SizedBox(height: 20),
                _buildModalTextField(_withdrawAmountController, 'Số tiền cần rút (Tối thiểu 50,000đ)', Icons.payments_rounded, isNumeric: true),
                const SizedBox(height: 12),
                _buildModalTextField(_withdrawBankNameController, 'Tên ngân hàng nhận (Ví dụ: MB Bank, Vietcombank)', Icons.account_balance_rounded),
                const SizedBox(height: 12),
                _buildModalTextField(_withdrawAccNumController, 'Số tài khoản thụ hưởng', Icons.pin_outlined),
                const SizedBox(height: 12),
                _buildModalTextField(_withdrawAccNameController, 'Tên chủ tài khoản (VIẾT HOA KHÔNG DẤU)', Icons.person_outline),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final amount = double.tryParse(_withdrawAmountController.text) ?? 0.0;
                    final bank = _withdrawBankNameController.text.trim();
                    final num = _withdrawAccNumController.text.trim();
                    final name = _withdrawAccNameController.text.trim();

                    if (amount < 50000 || bank.isEmpty || num.isEmpty || name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ và đúng định dạng yêu cầu.')));
                      return;
                    }

                    final repo = ref.read(sellerRepositoryProvider);
                    try {
                      final response = await repo.withdrawFunds(
                        amount: amount,
                        bankName: bank,
                        bankAccountNumber: num,
                        bankAccountName: name,
                      );
                      ref.invalidate(sellerAnalyticsProvider);
                      Navigator.pop(context);
                      
                      final msg = response.data['message'] ?? 'Yêu cầu rút tiền thành công!';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg), backgroundColor: const Color(0xFF00E5FF)),
                      );

                      _withdrawAmountController.clear();
                      _withdrawBankNameController.clear();
                      _withdrawAccNumController.clear();
                      _withdrawAccNameController.clear();
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không đủ số dư ví hoặc có lỗi xảy ra.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('GỬI YÊU CẦU RÚT TIỀN', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  /// HỒ SƠ XÁC MINH CỬA HÀNG NGƯỜI BÁN (Seller verification form modal)
  void _showVerificationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0F14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                ),
                Text(
                  'HỒ SƠ ĐĂNG KÝ XÁC MINH NGƯỜI BÁN',
                  style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                ),
                const SizedBox(height: 20),
                _buildModalTextField(_verifyShopNameController, 'Tên cửa hàng (Shop Name)', Icons.storefront_rounded),
                const SizedBox(height: 12),
                _buildModalTextField(_verifyAvatarUrlController, 'Đường dẫn ảnh đại diện Shop (Avatar URL)', Icons.photo_camera_back_outlined),
                const SizedBox(height: 12),
                _buildModalTextField(_verifyDocUrlController, 'Giấy tờ tùy thân căn cước (Citizen ID Image URL)', Icons.file_present_rounded),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final shop = _verifyShopNameController.text.trim();
                    final avatar = _verifyAvatarUrlController.text.trim();
                    final doc = _verifyDocUrlController.text.trim();

                    if (shop.isEmpty || avatar.isEmpty || doc.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng cung cấp đầy đủ thông tin xác minh.')));
                      return;
                    }

                    final repo = ref.read(sellerRepositoryProvider);
                    try {
                      await repo.verifySeller(
                        avatarUrl: avatar,
                        documentUrl: doc,
                        shopName: shop,
                      );
                      ref.invalidate(sellerVerificationStatusProvider);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Hồ sơ xác minh đã được gửi! Đang chờ Admin duyệt.'), backgroundColor: Color(0xFF00E5FF)),
                      );

                      _verifyShopNameController.clear();
                      _verifyAvatarUrlController.clear();
                      _verifyDocUrlController.clear();
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi gửi hồ sơ xác minh.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('GỬI HỒ SƠ PHÊ DUYỆT', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalTextField(TextEditingController controller, String label, IconData icon, {bool isNumeric = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF00E5FF), size: 20),
        labelText: label,
        labelStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF161B22),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00E5FF))),
      ),
      style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
    );
  }
}
