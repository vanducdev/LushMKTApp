import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/features/profile/providers/ticket_providers.dart';

class TicketsView extends ConsumerStatefulWidget {
  const TicketsView({super.key});

  @override
  ConsumerState<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends ConsumerState<TicketsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers cho form gửi ticket mới
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedDept = 'Dịch vụ mạng xã hội';
  String _selectedPriority = 'Trung bình';
  
  // Trạng thái đính kèm ảnh
  bool _isUploadingImage = false;
  String? _attachedImageUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  /// Giả lập quá trình chọn và upload ảnh lỗi bằng chứng
  void _simulatePickAndUploadImage() {
    setState(() {
      _isUploadingImage = true;
    });

    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isUploadingImage = false;
        // Mock link ảnh bằng chứng giao dịch/lỗi
        _attachedImageUrl = 'https://picsum.photos/id/237/400/300';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đính kèm ảnh lỗi bằng chứng thành công!'),
          backgroundColor: Color(0xFF00FF88),
        ),
      );
    });
  }

  /// Xử lý gửi Ticket mới lên hệ thống
  void _submitNewTicket() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng điền đầy đủ tiêu đề và nội dung mô tả lỗi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ref.read(supportTicketsProvider.notifier).createTicket(
      title: title,
      department: _selectedDept,
      priority: _selectedPriority,
      description: desc,
      attachedImage: _attachedImageUrl,
    );

    // Reset form
    _titleController.clear();
    _descController.clear();
    setState(() {
      _attachedImageUrl = null;
      _selectedDept = 'Dịch vụ mạng xã hội';
      _selectedPriority = 'Trung bình';
    });

    // Chuyển tab về Inbox
    _tabController.animateTo(0);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gửi yêu cầu hỗ trợ mới thành công! Kỹ thuật viên sẽ phản hồi sớm.'),
        backgroundColor: Color(0xFF00E5FF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tickets = ref.watch(supportTicketsProvider);
    final faqs = ref.watch(faqListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'TRUNG TÂM HỖ TRỢ VIP',
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00E5FF),
          labelColor: const Color(0xFF00E5FF),
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.orbitron(fontSize: 9, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_rounded), text: 'YÊU CẦU ĐÃ GỬI'),
            Tab(icon: Icon(Icons.add_comment_rounded), text: 'GỬI ĐƠN MỚI'),
            Tab(icon: Icon(Icons.quiz_rounded), text: 'HỎI ĐÁP FAQ'),
          ],
        ),
      ),
      body: Column(
        children: [
          // QUICK LIVE CHAT GATEWAY ANCHOR (Tin nhắn trực tiếp bằng WebSockets)
          InkWell(
            onTap: () => GoRouter.of(context).push('/chat'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00E5FF).withOpacity(0.12),
                    const Color(0xFF0D0F14),
                  ],
                ),
                border: const Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_rounded, color: Color(0xFF00E5FF), size: 16),
                      const SizedBox(width: 10),
                      Text(
                        'Kết nối Live Chat WebSockets hỗ trợ 24/7 ➔',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF)),
                      ),
                    ],
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Color(0xFF00FF88), shape: BoxShape.circle),
                  )
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: TICKETS INBOX LIST
                _buildTicketsInboxTab(tickets),

                // TAB 2: SUBMIT NEW TICKET
                _buildSubmitTicketTab(),

                // TAB 3: FAQ ACCORDIONS
                _buildFaqTab(faqs),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// TAB 1: Danh sách Ticket đã gửi
  Widget _buildTicketsInboxTab(List<TicketModel> ticketsList) {
    if (ticketsList.isEmpty) {
      return Center(
        child: Text('Bạn chưa gửi yêu cầu hỗ trợ nào.', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: ticketsList.length,
      itemBuilder: (context, index) {
        final ticket = ticketsList[index];
        final isReplied = ticket.status == 'Đã trả lời';
        final Color statusColor = isReplied ? const Color(0xFF00FF88) : const Color(0xFFFFD740);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.id,
                    style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: statusColor.withOpacity(0.2)),
                    ),
                    child: Text(
                      ticket.status.toUpperCase(),
                      style: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),

              Text(
                ticket.title,
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),

              Text(
                ticket.description,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 12),

              // Bằng chứng ảnh lỗi đính kèm nếu có
              if (ticket.attachedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ticket.attachedImage!,
                    height: 100,
                    width: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white10,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_rounded, color: Colors.grey, size: 16),
                            SizedBox(width: 8),
                            Text('Anh_Bang_Chung.jpg', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ticket.date, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                  InkWell(
                    onTap: () {
                      _showTicketExchangeDialog(context, ticket);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF00E5FF).withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'XEM TRAO ĐỔI',
                        style: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF)),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  /// TAB 2: Đăng ký tạo yêu cầu hỗ trợ mới
  Widget _buildSubmitTicketTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Text('TẠO YÊU CẦU KỸ THUẬT', style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 16),

        // Tiêu đề lỗi
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Nhập tiêu đề lỗi (ví dụ: Lỗi nạp tiền ví)...',
            labelText: 'Tiêu đề yêu cầu hỗ trợ',
            filled: true,
            fillColor: const Color(0xFF161B22),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00E5FF))),
          ),
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
        ),
        const SizedBox(height: 16),

        // Chọn phòng ban
        DropdownButtonFormField<String>(
          value: _selectedDept,
          decoration: InputDecoration(
            labelText: 'Phòng ban xử lý',
            filled: true,
            fillColor: const Color(0xFF161B22),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
          ),
          dropdownColor: const Color(0xFF161B22),
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
          items: const [
            DropdownMenuItem(value: 'Dịch vụ mạng xã hội', child: Text('Bộ Phận Mạng Xã Hội (Like/Sub)')),
            DropdownMenuItem(value: 'Bộ phận thanh toán', child: Text('Cổng Nạp Tiền & Rút Ví Ví')),
            DropdownMenuItem(value: 'Hỗ trợ kỹ thuật VPS', child: Text('Hỗ Trợ Kỹ Thuật VPS & Proxy')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedDept = val);
          },
        ),
        const SizedBox(height: 16),

        // Chọn độ ưu tiên
        DropdownButtonFormField<String>(
          value: _selectedPriority,
          decoration: InputDecoration(
            labelText: 'Độ ưu tiên xử lý',
            filled: true,
            fillColor: const Color(0xFF161B22),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
          ),
          dropdownColor: const Color(0xFF161B22),
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
          items: const [
            DropdownMenuItem(value: 'Thấp', child: Text('Thấp (Xử lý trong 24h)')),
            DropdownMenuItem(value: 'Trung bình', child: Text('Trung bình (Xử lý trong 12h)')),
            DropdownMenuItem(value: 'Cao', child: Text('Cao (Ưu tiên xử lý gấp - 4h)')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedPriority = val);
          },
        ),
        const SizedBox(height: 16),

        // Chi tiết lỗi
        TextField(
          controller: _descController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Nhập thông tin chi tiết mã đơn hàng bị lỗi, link mục tiêu, hoặc bill thanh toán ngân hàng...',
            labelText: 'Mô tả chi tiết sự cố',
            filled: true,
            fillColor: const Color(0xFF161B22),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00E5FF))),
          ),
          style: GoogleFonts.inter(fontSize: 12, color: Colors.white, height: 1.4),
        ),
        const SizedBox(height: 20),

        // MOCK UPLOAD IMAGE BUTTON (Tải ảnh lỗi đính kèm bằng chứng)
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _isUploadingImage ? null : _simulatePickAndUploadImage,
              icon: _isUploadingImage
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                  : const Icon(Icons.photo_library_rounded, size: 14, color: Colors.black),
              label: Text(_isUploadingImage ? 'ĐANG TẢI LÊN...' : 'ĐÍNH KÈM ẢNH BẰNG CHỨNG', style: GoogleFonts.orbitron(fontSize: 9, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 12),

            // Thumbnail xem trước ảnh đã tải lên
            if (_attachedImageUrl != null)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(_attachedImageUrl!, width: 44, height: 44, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: () => setState(() => _attachedImageUrl = null),
                      child: const CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.redAccent,
                        child: Icon(Icons.close_rounded, color: Colors.white, size: 10),
                      ),
                    ),
                  )
                ],
              )
          ],
        ),
        const SizedBox(height: 30),

        // Nút gửi ticket
        ElevatedButton(
          onPressed: _submitNewTicket,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E5FF),
            foregroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('GỬI YÊU CẦU HỖ TRỢ', style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  /// TAB 3: FAQ Hỏi Đáp Accordions
  Widget _buildFaqTab(List<FaqModel> faqs) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: ExpansionTile(
            title: Text(
              faq.question,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            iconColor: const Color(0xFF00E5FF),
            collapsedIconColor: Colors.grey,
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(
                faq.answer,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey, height: 1.5),
              )
            ],
          ),
        );
      },
    );
  }

  /// DIALOG HIỂN THỊ CHI TIẾT TRAO ĐỔI TICKET
  void _showTicketExchangeDialog(BuildContext context, TicketModel ticket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161B22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Text(ticket.id, style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF))),
              const SizedBox(width: 8),
              Expanded(
                child: Text('TRAO ĐỔI HỖ TRỢ', style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tiêu đề: ${ticket.title}', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                
                // Tin khách gửi
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bạn gửi:', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF))),
                      const SizedBox(height: 4),
                      Text(ticket.description, style: GoogleFonts.inter(fontSize: 11, color: Colors.white70, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Phản hồi của admin/kỹ thuật
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF88).withOpacity(0.04),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kỹ thuật viên VIP phản hồi:', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF00FF88))),
                      const SizedBox(height: 6),
                      Text(
                        ticket.status == 'Đã trả lời'
                            ? 'Chào bạn, đơn hỗ trợ nạp thẻ của bạn đã được kiểm tra và hoàn tất cộng tiền vào ví khả dụng. Chúc bạn một ngày giao dịch hiệu quả!'
                            : 'Yêu cầu sự cố của bạn đã chuyển tới bộ phận liên quan và đang trong hàng đợi kiểm thử API API. Kỹ thuật viên sẽ trả lời trong ít phút.',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white70, height: 1.4),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ĐÓNG', style: GoogleFonts.orbitron(fontSize: 10, color: const Color(0xFF00E5FF))),
            )
          ],
        );
      },
    );
  }
}
