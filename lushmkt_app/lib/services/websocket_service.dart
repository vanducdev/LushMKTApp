import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// Các loại sự kiện Realtime
enum RealtimeEventType {
  notification,
  liveOrder,
  chat,
  sellerAlert,
}

class RealtimeEvent {
  final RealtimeEventType type;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  RealtimeEvent({
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.timestamp,
  });
}

class WebSocketService {
  WebSocketChannel? _channel;
  final _controller = StreamController<RealtimeEvent>.broadcast();
  Timer? _mockTimer;
  bool _isConnecting = false;

  Stream<RealtimeEvent> get eventStream => _controller.stream;

  WebSocketService() {
    _startSimulatedBroadcaster();
  }

  /// Khởi tạo kết nối WebSocket thực tế
  void connect(String wsUrl) {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message);
            final event = _parseServerEvent(decoded);
            if (event != null) {
              _controller.add(event);
            }
          } catch (_) {}
        },
        onError: (err) {
          _isConnecting = false;
        },
        onDone: () {
          _isConnecting = false;
        },
      );
    } catch (_) {
      _isConnecting = false;
    }
  }

  /// Phân tích gói tin từ máy chủ PHP Websocket / Reverb
  RealtimeEvent? _parseServerEvent(Map<String, dynamic> json) {
    final typeStr = json['type'] as String?;
    if (typeStr == null) return null;

    RealtimeEventType type;
    switch (typeStr) {
      case 'notification':
        type = RealtimeEventType.notification;
        break;
      case 'live_order':
        type = RealtimeEventType.liveOrder;
        break;
      case 'chat':
        type = RealtimeEventType.chat;
        break;
      case 'seller_alert':
        type = RealtimeEventType.sellerAlert;
        break;
      default:
        return null;
    }

    return RealtimeEvent(
      type: type,
      title: json['title'] ?? 'Sự kiện mới',
      message: json['message'] ?? '',
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      timestamp: DateTime.now(),
    );
  }

  /// Gửi tin nhắn chat thông qua socket
  void sendMessage(String message, String receiverId) {
    if (_channel != null) {
      final payload = jsonEncode({
        'action': 'send_message',
        'receiver_id': receiverId,
        'message': message,
      });
      _channel!.sink.add(payload);
    }

    // Tự động đẩy sự kiện gửi cục bộ để cập nhật UI tức thời
    _controller.add(RealtimeEvent(
      type: RealtimeEventType.chat,
      title: 'Bạn',
      message: message,
      data: {'sender_id': 'me', 'receiver_id': receiverId},
      timestamp: DateTime.now(),
    ));

    // Giả lập bot phản hồi tự động sau 1.5 giây
    Future.delayed(const Duration(milliseconds: 1500), () {
      final replies = [
        "Chào bạn, clone via fb bên shop là hàng ngâm chất lượng cao có sẵn 2FA nhé!",
        "Dạ shop đang online đây ạ, bạn cần mua số lượng lớn via cổ kháng có ưu đãi giảm 10%.",
        "Chào bạn, tài khoản đã được nạp tự động, bạn kiểm tra lại số dư ví nhé.",
        "Dạ chính sách bảo hành via là 1 đổi 1 trong vòng 24h đối với lỗi sai pass, checkpoint."
      ];
      final randomReply = (replies..shuffle()).first;

      _controller.add(RealtimeEvent(
        type: RealtimeEventType.chat,
        title: 'Shop Support VIP',
        message: randomReply,
        data: {'sender_id': receiverId, 'receiver_id': 'me'},
        timestamp: DateTime.now(),
      ));
    });
  }

  /// Tự động sinh sự kiện giả lập định kỳ (Mô phỏng máy chủ đang push tin liên tục)
  void _startSimulatedBroadcaster() {
    _mockTimer?.cancel();
    _mockTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      final rand = DateTime.now().millisecond % 4;
      RealtimeEvent event;

      switch (rand) {
        case 0:
          event = RealtimeEvent(
            type: RealtimeEventType.notification,
            title: 'Hệ thống Thanh Toán',
            message: 'Tài khoản LUSH9982 vừa nạp 200,000đ thành công qua VietQR!',
            data: {'amount': 200000},
            timestamp: DateTime.now(),
          );
          break;
        case 1:
          event = RealtimeEvent(
            type: RealtimeEventType.liveOrder,
            title: 'Mua tài nguyên mới',
            message: 'User ducva*** vừa mua thành công: VIA FB Cổ Kháng 2FA (x5 tài khoản).',
            data: {'product_id': 12, 'qty': 5},
            timestamp: DateTime.now(),
          );
          break;
        case 2:
          event = RealtimeEvent(
            type: RealtimeEventType.sellerAlert,
            title: 'Thương nhân Cảnh Báo',
            message: 'Yêu cầu rút ví 1,500,000đ của thương hiệu LUSH-MMO đang chờ duyệt chuyển khoản.',
            data: {'amount': 1500000},
            timestamp: DateTime.now(),
          );
          break;
        default:
          event = RealtimeEvent(
            type: RealtimeEventType.chat,
            title: 'Hệ thống hỗ trợ',
            message: 'Tin nhắn tự động: Chào mừng bạn đến với kênh support thời gian thực. Hãy hỏi mọi câu hỏi về VPS, VIA FB nhé!',
            data: {'sender_id': 'system'},
            timestamp: DateTime.now(),
          );
          break;
      }

      _controller.add(event);
    });
  }

  void disconnect() {
    _channel?.sink.close(status.goingAway);
    _mockTimer?.cancel();
    _controller.close();
  }
}

// Riverpod Provider cho WebSocket Service
final websocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  ref.onDispose(() => service.disconnect());
  return service;
});

// Provider lắng nghe dòng sự kiện trực tiếp
final realtimeEventsProvider = StreamProvider<RealtimeEvent>((ref) {
  final wsService = ref.watch(websocketServiceProvider);
  return wsService.eventStream;
});
