import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/core/providers/network_providers.dart';

// Riverpod Provider lấy lịch sử giao dịch nạp/mua
final transactionsListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get('/transactions');
    final List<dynamic> list = response.data['data'] ?? [];
    return List<Map<String, dynamic>>.from(list);
  } catch (e) {
    // Mock dữ liệu giao dịch phong phú khi offline
    return [
      {
        'transaction_code': 'LUSH58102',
        'amount': 250000.0,
        'type': 'deposit',
        'payment_method': 'bank',
        'status': 'success',
        'description': 'Nạp tiền tự động qua VietQR MB Bank',
        'created_at': '2026-05-18T12:00:00Z'
      },
      {
        'transaction_code': 'BUY82KD9S',
        'amount': -45000.0,
        'type': 'payment',
        'payment_method': 'balance',
        'status': 'success',
        'description': 'Mua tài nguyên: VIA Facebook Cổ',
        'created_at': '2026-05-18T12:05:00Z'
      },
      {
        'transaction_code': 'USDT99120',
        'amount': 125000.0,
        'type': 'deposit',
        'payment_method': 'crypto',
        'status': 'pending',
        'description': 'Nạp tiền Crypto USDT TRC-20 (5.0 USD)',
        'created_at': '2026-05-19T02:30:00Z'
      }
    ];
  }
});

// Provider quản lý ví số dư người dùng
final userBalanceProvider = StateProvider<double>((ref) => 2450000.0);

class DepositView extends ConsumerStatefulWidget {
  const DepositView({super.key});

  @override
  ConsumerState<DepositView> createState() => _DepositViewState();
}

class _DepositViewState extends ConsumerState<DepositView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _amountController = TextEditingController(text: '100000');
  final _cryptoUsdController = TextEditingController(text: '10');

  // Trạng thái đơn nạp VietQR đang active
  bool _hasActiveVietQR = false;
  String _vietqrCode = '';
  double _vietqrAmount = 0.0;
  String _vietqrUrl = '';

  // Trạng thái đơn nạp Crypto đang active
  bool _hasActiveCrypto = false;
  String _cryptoCode = '';
  double _cryptoUsd = 0.0;
  double _cryptoVnd = 0.0;
  String _cryptoAddress = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _cryptoUsdController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép $fieldName vào bộ nhớ tạm.'),
        backgroundColor: const Color(0xFF161B22),
      ),
    );
  }

  /// Gọi mô phỏng thanh toán (Callback simulation)
  Future<void> _simulateDepositWebhook(String code) async {
    final dio = ref.read(dioProvider);
    try {
      final response = await dio.post('/deposit/simulate/$code');
      if (response.data['status'] == 'success') {
        final double addedAmount = double.tryParse(response.data['transaction']['amount'].toString()) ?? 0.0;
        ref.read(userBalanceProvider.notifier).update((state) => state + addedAmount);
        
        // Hủy trạng thái đơn active tương ứng nếu trùng mã
        if (code == _vietqrCode) {
          setState(() {
            _hasActiveVietQR = false;
          });
        } else if (code == _cryptoCode) {
          setState(() {
            _hasActiveCrypto = false;
          });
        }

        ref.invalidate(transactionsListProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xác thực giao dịch thành công! Tài khoản được cộng ${addedAmount.toInt()}đ.'),
            backgroundColor: const Color(0xFF00E5FF),
          ),
        );
      }
    } catch (e) {
      // Mock cộng tiền trực tiếp khi offline
      double addedAmt = 100000.0;
      if (code == _cryptoCode) addedAmt = _cryptoVnd;
      else if (code == _vietqrCode) addedAmt = _vietqrAmount;

      ref.read(userBalanceProvider.notifier).update((state) => state + addedAmt);
      
      setState(() {
        _hasActiveVietQR = false;
        _hasActiveCrypto = false;
      });
      
      ref.invalidate(transactionsListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Giao dịch giả lập thành công! Tài khoản đã được cộng ${addedAmt.toInt()}đ.'),
          backgroundColor: const Color(0xFF00FF88),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(userBalanceProvider);
    final transactionsAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'VÍ LUSH-MKT',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00E5FF),
          labelColor: const Color(0xFF00E5FF),
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.qr_code_2_rounded), text: 'VIETQR'),
            Tab(icon: Icon(Icons.account_balance_wallet_rounded), text: 'GATEWAY'),
            Tab(icon: Icon(Icons.currency_bitcoin_rounded), text: 'USDT CRYPTO'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. SỐ DƯ TÀI KHOẢN (Balance summary)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF00E5FF).withOpacity(0.12),
                  const Color(0xFF161B22),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF00E5FF).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SỐ DƯ KHẢ DỤNG',
                      style: GoogleFonts.orbitron(
                        fontSize: 9,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${balance.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫',
                      style: GoogleFonts.orbitron(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF00E5FF), size: 24),
                )
              ],
            ),
          ),

          // 2. TAB GATEWAY OPTIONS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: VIETQR TRANSFER
                _buildVietQRTab(),

                // TAB 2: PORTAL VNPAY / MOMO
                _buildPortalGateTab(),

                // TAB 3: USDT CRYPTO TRC-20
                _buildCryptoTab(),
              ],
            ),
          ),

          // 3. TRANSACTION HISTORY (Lịch sử giao dịch)
          const Divider(color: Colors.white10, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LỊCH SỬ GIAO DỊCH',
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xFF00E5FF), size: 18),
                  onPressed: () => ref.invalidate(transactionsListProvider),
                ),
              ],
            ),
          ),
          
          Expanded(
            flex: 1,
            child: transactionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => const Center(child: Text('Lỗi tải lịch sử giao dịch.')),
              data: (list) => _buildTransactionsList(list),
            ),
          )
        ],
      ),
    );
  }

  /// ================= TAB VIEWS SPECIFICATIONS =================

  /// TAB 1: Nạp tiền VietQR
  Widget _buildVietQRTab() {
    if (_hasActiveVietQR) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ĐƠN NẠP TIỀN ĐANG CHỜ', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF))),
                    ElevatedButton(
                      onPressed: () => _simulateDepositWebhook(_vietqrCode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF88),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('GIẢ LẬP ĐÃ CHUYỂN'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // VietQR Generated Image
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Image.network(
                    _vietqrUrl,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                _buildCopyRow('Ngân hàng:', 'MB Bank (Quân Đội)'),
                _buildCopyRow('Số tài khoản:', '1903561728394'),
                _buildCopyRow('Chủ tài khoản:', 'CONG TY LUSHMKT'),
                _buildCopyRow('Số tiền:', '${_vietqrAmount.toInt()}đ'),
                _buildCopyRow('Nội dung chuyển:', _vietqrCode),

                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => setState(() => _hasActiveVietQR = false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('HỦY YÊU CẦU', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                )
              ],
            ),
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NHẬP SỐ TIỀN MUỐN NẠP', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.monetization_on_outlined, color: Color(0xFF00E5FF)),
              hintText: 'Nhập số tiền nạp (VND)',
              filled: true,
              fillColor: const Color(0xFF161B22),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00E5FF))),
            ),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(_amountController.text) ?? 100000;
              final dio = ref.read(dioProvider);
              try {
                final response = await dio.post('/deposit/vietqr', data: {'amount': amt});
                final data = response.data['data'];
                setState(() {
                  _vietqrCode = data['transaction_code'];
                  _vietqrAmount = amt;
                  _vietqrUrl = data['qr_url'];
                  _hasActiveVietQR = true;
                });
                ref.invalidate(transactionsListProvider);
              } catch (e) {
                // Fallback offline
                setState(() {
                  _vietqrCode = 'LUSH' + (10000 + amt.toInt() % 1000).toString();
                  _vietqrAmount = amt;
                  _vietqrUrl = 'https://img.vietqr.io/image/MB-1903561728394-compact2.png?amount=${amt.toInt()}&addInfo=$_vietqrCode';
                  _hasActiveVietQR = true;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E5FF),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('TẠO QUY TẮC VIETQR', style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  /// TAB 2: VNPay / Momo Gateways
  Widget _buildPortalGateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CHỌN CỔNG LIÊN KẾT THANH TOÁN', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 16),

          // VNPay Card Option
          _buildPortalGateItem(
            'CỔNG VNPAY QR BANKING',
            'Hỗ trợ thanh toán ứng dụng ngân hàng quét mã vNPAY sandbox',
            'image/vnpay_logo.png', // Fallback icon
            Icons.account_balance_rounded,
            const Color(0xFF0068FF),
          ),
          const SizedBox(height: 14),

          // Momo Card Option
          _buildPortalGateItem(
            'VÍ MOMO SMART PAY',
            'Thanh toán qua số dư ví điện tử MoMo cá nhân',
            'image/momo_logo.png',
            Icons.wallet_rounded,
            const Color(0xFFA50064),
          ),
        ],
      ),
    );
  }

  Widget _buildPortalGateItem(String title, String desc, String logoAsset, IconData fallbackIcon, Color color) {
    return InkWell(
      onTap: () {
        // Tải hóa đơn gateway checkout
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đang chuyển hướng kết nối cổng $title...'),
            backgroundColor: color,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(fallbackIcon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(desc, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  /// TAB 3: USDT Crypto Payment
  Widget _buildCryptoTab() {
    if (_hasActiveCrypto) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD740).withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ĐƠN CRYPTO ĐANG CHỜ', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFFFD740))),
                    ElevatedButton(
                      onPressed: () => _simulateDepositWebhook(_cryptoCode),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD740),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        textStyle: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('GIẢ LẬP ĐÃ BLOCKCHAIN'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildCopyRow('Mạng blockchain:', 'TRC-20 (TRON Network)'),
                _buildCopyRow('Đồng tiền nạp:', 'USDT'),
                _buildCopyRow('Giá trị USD:', '${_cryptoUsd.toStringAsFixed(1)} USD'),
                _buildCopyRow('Số tiền VND quy đổi:', '${_cryptoVnd.toInt()}đ'),
                _buildCopyRow('Địa chỉ ví USDT:', _cryptoAddress),
                _buildCopyRow('Mã giao dịch ghi nhớ:', _cryptoCode),

                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => setState(() => _hasActiveCrypto = false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('HỦY YÊU CẦU', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                )
              ],
            ),
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NHẬP SỐ USD MUỐN NẠP (USDT TRC20)', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          TextField(
            controller: _cryptoUsdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.currency_bitcoin_rounded, color: Color(0xFFFFD740)),
              hintText: 'Nhập số tiền nạp (USD)',
              filled: true,
              fillColor: const Color(0xFF161B22),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFFD740))),
            ),
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            '* Tỷ giá quy đổi cố định: 1 USDT = 25,000 VND',
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final usd = double.tryParse(_cryptoUsdController.text) ?? 10.0;
              final dio = ref.read(dioProvider);
              try {
                final response = await dio.post('/deposit/crypto', data: {'amount_usd': usd});
                final data = response.data['data'];
                setState(() {
                  _cryptoCode = data['transaction_code'];
                  _cryptoUsd = usd;
                  _cryptoVnd = (data['vnd_equivalent'] as num).toDouble();
                  _cryptoAddress = data['crypto_address'];
                  _hasActiveCrypto = true;
                });
                ref.invalidate(transactionsListProvider);
              } catch (e) {
                // Fallback offline
                setState(() {
                  _cryptoCode = 'USDT' + (10000 + usd.toInt() * 10).toString();
                  _cryptoUsd = usd;
                  _cryptoVnd = usd * 25000;
                  _cryptoAddress = 'TWeB9Hh7rZfJn3a1v9B5aH9c7z2W1Q2L4X';
                  _hasActiveCrypto = true;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD740),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('NẠP CRYPTO USDT', style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildCopyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
          Row(
            children: [
              Text(value, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(width: 8),
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

  /// ================= LIST OF COMPLETED/PENDING TRANSACTIONS =================
  Widget _buildTransactionsList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Center(
        child: Text('Chưa có lịch sử giao dịch nào.', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final tx = list[index];
        final type = tx['type'] ?? 'deposit';
        final isDeposit = type == 'deposit';
        final status = tx['status'] ?? 'success';
        final isPending = status == 'pending';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPending ? const Color(0xFFFFD740).withOpacity(0.08) : Colors.white.withOpacity(0.02),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDeposit ? const Color(0xFF00FF88).withOpacity(0.08) : Colors.redAccent.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDeposit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: isDeposit ? const Color(0xFF00FF88) : Colors.redAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx['description'] ?? '',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'MÃ: ${tx['transaction_code']} • Phương thức: ${(tx['payment_method'] ?? 'bank').toString().toUpperCase()}',
                      style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isDeposit ? '+' : '-'}${((tx['amount'] ?? 0.0) as num).toInt()}đ',
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDeposit ? const Color(0xFF00FF88) : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isPending)
                    ElevatedButton(
                      onPressed: () => _simulateDepositWebhook(tx['transaction_code']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD740),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        textStyle: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                      child: const Text('DUYỆT SANDBOX'),
                    )
                  else
                    Text(
                      'THÀNH CÔNG',
                      style: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF00FF88)),
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
