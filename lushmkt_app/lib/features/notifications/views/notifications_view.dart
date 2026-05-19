import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lushmkt_app/services/notification_service.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Trực tiếp kích hoạt nạp tin giả lập FCM từ server
  void _simulateIncomingFCMPush() {
    final service = ref.read(notificationServiceProvider);
    final push = service.triggerMockFirebasePush();
    
    // Đẩy banner nổi Heads-Up
    service.showHeadsUpBanner(context, push);
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(inboxNotificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'HỘP THƯ BÁO',
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
        actions: [
          // Nút bấm kích hoạt mô phỏng Firebase Cloud Messaging
          ElevatedButton.icon(
            onPressed: _simulateIncomingFCMPush,
            icon: const Icon(Icons.bolt_rounded, color: Colors.black, size: 12),
            label: const Text('NHẬN FCM PUSH'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF88), // Neon Green
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.orbitron(fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: Color(0xFF00E5FF), size: 18),
            onPressed: () {
              ref.read(inboxNotificationsProvider.notifier).markAllRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã đánh dấu toàn bộ thông báo là đã đọc.'),
                  backgroundColor: Color(0xFF161B22),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00E5FF),
          labelColor: const Color(0xFF00E5FF),
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          labelStyle: GoogleFonts.orbitron(fontSize: 9, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.all_inbox_rounded), text: 'TẤT CẢ'),
            Tab(icon: Icon(Icons.campaign_rounded), text: 'KHUYẾN MÃI'),
            Tab(icon: Icon(Icons.shopping_bag_rounded), text: 'ĐƠN HÀNG'),
            Tab(icon: Icon(Icons.gpp_good_rounded), text: 'BẢO MẬT'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: ALL
          _buildNotificationTab(list),

          // TAB 2: PROMOTIONS
          _buildNotificationTab(list.where((n) => n.type == NotificationType.promotion).toList()),

          // TAB 3: LIVE ORDERS
          _buildNotificationTab(list.where((n) => n.type == NotificationType.liveOrder).toList()),

          // TAB 4: SECURITY ALERTS
          _buildNotificationTab(list.where((n) => n.type == NotificationType.security).toList()),
        ],
      ),
    );
  }

  /// Khung danh sách lọc theo Tab tương ứng
  Widget _buildNotificationTab(List<LushNotificationModel> tabList) {
    if (tabList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mail_outline_rounded, color: Colors.grey, size: 40),
              const SizedBox(height: 12),
              Text(
                'Không có thông báo nào trong mục này.',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: tabList.length,
      itemBuilder: (context, index) {
        final notif = tabList[index];
        IconData icon = Icons.info_outline;
        Color iconColor = Colors.blueAccent;

        if (notif.type == NotificationType.promotion) {
          icon = Icons.campaign_rounded;
          iconColor = const Color(0xFFFFD740); // Yellow
        } else if (notif.type == NotificationType.liveOrder) {
          icon = Icons.shopping_bag_rounded;
          iconColor = const Color(0xFF00E5FF); // Cyan
        } else if (notif.type == NotificationType.security) {
          icon = Icons.gpp_maybe_rounded;
          iconColor = const Color(0xFFFF5252); // Red
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notif.isRead ? Colors.white.withOpacity(0.02) : iconColor.withOpacity(0.12),
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.08),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(
              notif.title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                notif.body,
                style: GoogleFonts.inter(fontSize: 11, color: Colors.grey, height: 1.4),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH:mm').format(notif.timestamp),
                  style: GoogleFonts.orbitron(fontSize: 8, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                if (!notif.isRead)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: iconColor, blurRadius: 4, spreadRadius: 1),
                      ],
                    ),
                  )
              ],
            ),
            onTap: () {
              ref.read(inboxNotificationsProvider.notifier).markRead(notif.id);
            },
          ),
        );
      },
    );
  }
}
