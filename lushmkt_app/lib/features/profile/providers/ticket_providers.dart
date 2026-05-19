import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketModel {
  final String id;
  final String title;
  final String department;
  final String priority; // Cao, Trung bình, Thấp
  final String status; // Đang chờ phản hồi, Đã trả lời
  final String description;
  final String date;
  final String? attachedImage;

  TicketModel({
    required this.id,
    required this.title,
    required this.department,
    required this.priority,
    required this.status,
    required this.description,
    required this.date,
    this.attachedImage,
  });

  TicketModel copyWith({
    String? id,
    String? title,
    String? department,
    String? priority,
    String? status,
    String? description,
    String? date,
    String? attachedImage,
  }) {
    return TicketModel(
      id: id ?? this.id,
      title: title ?? this.title,
      department: department ?? this.department,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      description: description ?? this.description,
      date: date ?? this.date,
      attachedImage: attachedImage ?? this.attachedImage,
    );
  }
}

class SupportTicketNotifier extends StateNotifier<List<TicketModel>> {
  SupportTicketNotifier() : super([]) {
    _loadInitialTickets();
  }

  void _loadInitialTickets() {
    state = [
      TicketModel(
        id: 'TK-8912',
        title: 'Đơn hàng buff follow lên chậm',
        department: 'Dịch vụ mạng xã hội',
        priority: 'Trung bình',
        status: 'Đang chờ phản hồi',
        description: 'Tôi đã đặt đơn buff follow OD-67123 được 4 tiếng rồi nhưng mới chỉ lên được 15 follow. Nhờ kỹ thuật kiểm tra và tăng tốc lực chạy giúp tôi.',
        date: '08:15 - 09/05/2026',
      ),
      TicketModel(
        id: 'TK-7812',
        title: 'Lỗi chưa cộng tiền nạp ví qua VietQR',
        department: 'Bộ phận thanh toán',
        priority: 'Cao',
        status: 'Đã trả lời',
        description: 'Tôi đã quét mã VietQR ngân hàng nạp 100,000đ từ MB Bank nhưng tài khoản chưa được cộng số dư khả dụng. Nội dung chuyển khoản là LUSH58102.',
        date: '19:40 - 08/05/2026',
        attachedImage: 'image/trans-fail-demo.png', // Attached mockup
      ),
    ];
  }

  // Thêm Ticket mới kèm file ảnh đính kèm
  void createTicket({
    required String title,
    required String department,
    required String priority,
    required String description,
    String? attachedImage,
  }) {
    final newTicket = TicketModel(
      id: 'TK-${9000 + state.length}',
      title: title,
      department: department,
      priority: priority,
      status: 'Đang chờ phản hồi',
      description: description,
      date: 'Vừa xong',
      attachedImage: attachedImage,
    );
    state = [newTicket, ...state];
  }
}

// Provider quản lý hỗ trợ Ticket
final supportTicketsProvider = StateNotifierProvider<SupportTicketNotifier, List<TicketModel>>((ref) {
  return SupportTicketNotifier();
});

// Danh sách Mock câu hỏi thường gặp FAQ
class FaqModel {
  final String question;
  final String answer;
  bool isExpanded;

  FaqModel({required this.question, required this.answer, this.isExpanded = false});
}

final faqListProvider = StateProvider<List<FaqModel>>((ref) {
  return [
    FaqModel(
      question: 'Thời gian buff tương tác thường mất bao lâu?',
      answer: 'Thời gian chạy các tương tác Like, Follow, View thường dao động từ 15 phút đến tối đa 24h tùy thuộc vào số lượng và tốc độ của máy chủ bạn chọn. Nếu sau 24h đơn hàng chưa bắt đầu chạy, bạn hãy tạo Ticket hoặc Chat trực tiếp với Support VIP.',
    ),
    FaqModel(
      question: 'Chính sách bảo hành clone VIA Facebook tại LushMKT?',
      answer: 'Chúng tôi cam kết bảo hành 1 đổi 1 trong vòng 24h đối với tất cả các tài nguyên bị lỗi pass, lỗi định dạng 2FA hoặc bị checkpoint ngay khi đăng nhập. LushMKT từ chối bảo hành nếu tài khoản bị checkpoint sau khi bạn đã change info pass hoặc spam quảng cáo.',
    ),
    FaqModel(
      question: 'Làm thế nào khi nạp tiền 15 phút chưa vào ví?',
      answer: 'Hệ thống nạp tiền VietQR và Momo được đồng bộ tự động hóa. Nếu sau 15 phút chưa được cộng số dư, bạn hãy kiểm tra xem có điền đúng Nội Dung Ghi Nhớ Chuyển Khoản hay không. Sau đó hãy bấm nút "Đăng ký hỗ trợ" hoặc Chat trực tiếp để gửi bill đính kèm.',
    ),
  ];
});
