import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Các phân nhóm thông báo Push (Firebase Messaging Specs)
enum NotificationType {
  promotion,
  liveOrder,
  security,
}

class LushNotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  LushNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  LushNotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return LushNotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationService {
  final _controller = StreamController<LushNotificationModel>.broadcast();
  Stream<LushNotificationModel> get notificationStream => _controller.stream;

  // Lịch sử danh sách thông báo
  final List<LushNotificationModel> _inbox = [];
  List<LushNotificationModel> get inbox => List.unmodifiable(_inbox);

  NotificationService() {
    _loadDefaultInbox();
  }

  void _loadDefaultInbox() {
    _inbox.addAll([
      LushNotificationModel(
        id: 'NOT-1002',
        type: NotificationType.promotion,
        title: '📢 Ưu Đãi Lớn Giảm 10%',
        body: 'Nhập mã LUSH10 khi nạp VietQR/Momo để nhận thêm 10% giá trị ví khuyến mãi.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LushNotificationModel(
        id: 'NOT-1003',
        type: NotificationType.liveOrder,
        title: '📦 Đơn Tương Tác Đã Hoàn Thành',
        body: 'Đơn hàng buff like OD-78192 của bạn đã chạy đủ 1,000 like bài viết.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      LushNotificationModel(
        id: 'NOT-1004',
        type: NotificationType.security,
        title: '🛡️ Cảnh Báo Bảo Mật Đăng Nhập',
        body: 'Phát hiện thiết bị Windows đăng nhập mới từ IP 113.23.45.109 lúc 08:30.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: true,
      ),
    ]);
  }

  /// Mô phỏng trigger đẩy tin Push từ Firebase Console (FCM Cloud Server)
  LushNotificationModel triggerMockFirebasePush() {
    final rand = DateTime.now().millisecond % 3;
    LushNotificationModel newPush;

    switch (rand) {
      case 0:
        newPush = LushNotificationModel(
          id: 'FCM-${DateTime.now().millisecondsSinceEpoch}',
          type: NotificationType.promotion,
          title: '🔥 Siêu Khuyến Mãi Flash Sale',
          body: 'Chiết khấu đặc biệt 15% đối với dịch vụ buff comment Facebook và Tik Tok chỉ trong hôm nay!',
          timestamp: DateTime.now(),
        );
        break;
      case 1:
        newPush = LushNotificationModel(
          id: 'FCM-${DateTime.now().millisecondsSinceEpoch}',
          type: NotificationType.liveOrder,
          title: '📦 Tiến Trình Chạy Follow Tăng Tốc',
          body: 'Đơn hàng VIP Sub OD-67123 của bạn đã đạt hiệu suất chạy 80% mốc follow mục tiêu.',
          timestamp: DateTime.now(),
        );
        break;
      default:
        newPush = LushNotificationModel(
          id: 'FCM-${DateTime.now().millisecondsSinceEpoch}',
          type: NotificationType.security,
          title: '🚨 Thay Đổi Thiết Lập FaceID',
          body: 'Cảnh báo bảo mật: Cơ chế nhận dạng gương mặt đã được thay đổi hoặc đăng ký lại.',
          timestamp: DateTime.now(),
        );
        break;
    }

    _inbox.insert(0, newPush);
    _controller.add(newPush);
    return newPush;
  }

  /// Đánh dấu tất cả là đã đọc
  void markAllAsRead() {
    for (var i = 0; i < _inbox.length; i++) {
      _inbox[i] = _inbox[i].copyWith(isRead: true);
    }
  }

  /// Đánh dấu đọc một tin
  void markAsRead(String id) {
    final idx = _inbox.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _inbox[idx] = _inbox[idx].copyWith(isRead: true);
    }
  }

  /// Hiển thị Heads-Up Notification Banner đẹp đẽ phía trên viewport
  void showHeadsUpBanner(BuildContext context, LushNotificationModel push) {
    Color bannerColor = const Color(0xFF161B22);
    IconData icon = Icons.notifications_active_rounded;
    Color accent = const Color(0xFF00E5FF);

    if (push.type == NotificationType.promotion) {
      accent = const Color(0xFFFFD740);
      icon = Icons.campaign_rounded;
    } else if (push.type == NotificationType.security) {
      accent = const Color(0xFFFF5252);
      icon = Icons.gpp_bad_rounded;
    }

    final overlayState = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: _SlideDownBanner(
              onDismiss: () => entry?.remove(),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: bannerColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withOpacity(0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: accent.withOpacity(0.08), blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: accent.withOpacity(0.08), shape: BoxShape.circle),
                      child: Icon(icon, color: accent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            push.title,
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            push.body,
                            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey, height: 1.4),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 16),
                      onPressed: () => entry?.remove(),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(entry);
    
    // Auto dismiss after 4 seconds
    Timer(const Duration(seconds: 4), () {
      if (entry != null && entry!.mounted) {
        entry!.remove();
      }
    });
  }
}

class _SlideDownBanner extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const _SlideDownBanner({required this.child, required this.onDismiss});

  @override
  State<_SlideDownBanner> createState() => _SlideDownBannerState();
}

class _SlideDownBannerState extends State<_SlideDownBanner> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _offsetAnimation = Tween<Offset>(begin: const Offset(0, -1.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}

// Riverpod Provider cho NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

// StateNotifier quản lý danh sách Inbox Notification của UI
class InboxStateNotifier extends StateNotifier<List<LushNotificationModel>> {
  final NotificationService _service;

  InboxStateNotifier(this._service) : super([]) {
    state = _service.inbox;
    // Lắng nghe dòng sự kiện FCM mới đẩy vào Inbox
    _service.notificationStream.listen((event) {
      state = [event, ...state];
    });
  }

  void markAllRead() {
    _service.markAllAsRead();
    state = _service.inbox;
  }

  void markRead(String id) {
    _service.markAsRead(id);
    state = _service.inbox;
  }
}

final inboxNotificationsProvider = StateNotifierProvider<InboxStateNotifier, List<LushNotificationModel>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return InboxStateNotifier(service);
});
