import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lushmkt_app/services/websocket_service.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  
  // Danh sách tin nhắn hiển thị cục bộ
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'shop',
      'text': 'Chào bạn! LushMKT Hỗ trợ VIP xin nghe. Bạn cần tư vấn về VIA Facebook, VPS hay nạp thẻ ạ?',
      'time': '09:00'
    }
  ];

  // Danh sách dòng sự kiện Realtime nhận được
  final List<RealtimeEvent> _liveEvents = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Tự động lắng nghe dòng sự kiện WebSocket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(websocketServiceProvider).eventStream.listen((event) {
        if (!mounted) return;

        setState(() {
          // Lưu trữ sự kiện vào feed
          _liveEvents.insert(0, event);

          // Nếu là sự kiện chat và dành cho Client, đẩy vào màn hình chat luôn!
          if (event.type == RealtimeEventType.chat && event.title != 'Bạn') {
            _messages.add({
              'sender': 'shop',
              'text': event.message,
              'time': DateFormat('HH:mm').format(event.timestamp)
            });
            _scrollToBottom();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(websocketServiceProvider).sendMessage(text, 'shop_support');
    
    setState(() {
      _messages.add({
        'sender': 'me',
        'text': text,
        'time': DateFormat('HH:mm').format(DateTime.now())
      });
    });

    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REALTIME HUB',
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                // Blinking green dot
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00FF88),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0xFF00FF88), blurRadius: 4, spreadRadius: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'LIVE SOCKET CONNECTED',
                  style: GoogleFonts.orbitron(fontSize: 7, fontWeight: FontWeight.bold, color: const Color(0xFF00FF88)),
                )
              ],
            )
          ],
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
          labelStyle: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.forum_rounded), text: 'HỖ TRỢ VIP CHAT'),
            Tab(icon: Icon(Icons.stream_rounded), text: 'DÒNG SỰ KIỆN LIVE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: VIP CHAT ROOM
          _buildChatTab(),

          // TAB 2: LIVE BROADCAST TIMELINE FEED
          _buildLiveFeedTab(),
        ],
      ),
    );
  }

  /// TAB 1: Phòng chat hỗ trợ VIP
  Widget _buildChatTab() {
    return Column(
      children: [
        // Shop profile badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFF161B22),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF00E5FF),
                child: Icon(Icons.support_agent_rounded, color: Colors.black),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phòng Chăm Sóc Khách Hàng VIP', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('Trực tuyến 24/7 • API WebSockets', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Chat Bubble list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isMe = msg['sender'] == 'me';

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF00E5FF) : const Color(0xFF161B22),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                    ),
                    border: isMe ? null : Border.all(color: Colors.white.withOpacity(0.02)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['text'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isMe ? Colors.black : Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          msg['time'] ?? '',
                          style: GoogleFonts.orbitron(
                            fontSize: 8,
                            color: isMe ? Colors.black54 : Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Chat Inputs bar
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0F14),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn hỗ trợ...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF161B22),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.white.withOpacity(0.04))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: Color(0xFF00E5FF))),
                    ),
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF00E5FF),
                    child: Icon(Icons.send_rounded, color: Colors.black, size: 18),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  /// TAB 2: Sự kiện Realtime Timeline
  Widget _buildLiveFeedTab() {
    if (_liveEvents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sensors_rounded, color: Colors.grey, size: 40),
              const SizedBox(height: 12),
              Text(
                'Đang chờ luồng dữ liệu WebSockets...',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '(Các sự kiện nạp tiền, mua acc, cảnh báo shop sẽ phát tự động sau vài giây)',
                style: GoogleFonts.inter(fontSize: 9, color: Colors.grey.withOpacity(0.6), fontStyle: FontStyle.italic),
                textAlign: CenterPlayMode.center,
              )
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _liveEvents.length,
      itemBuilder: (context, index) {
        final event = _liveEvents[index];
        Color eventColor = Colors.grey;
        IconData icon = Icons.info_outline;

        if (event.type == RealtimeEventType.notification) {
          eventColor = const Color(0xFFFFD740); // Yellow
          icon = Icons.notifications_active_rounded;
        } else if (event.type == RealtimeEventType.liveOrder) {
          eventColor = const Color(0xFF00E5FF); // Cyan
          icon = Icons.shopping_bag_rounded;
        } else if (event.type == RealtimeEventType.sellerAlert) {
          eventColor = const Color(0xFFFF5252); // Red
          icon = Icons.security_rounded;
        } else if (event.type == RealtimeEventType.chat) {
          eventColor = const Color(0xFF00FF88); // Green
          icon = Icons.chat_bubble_rounded;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: eventColor.withOpacity(0.12), width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: eventColor.withOpacity(0.08), shape: BoxShape.circle),
                child: Icon(icon, color: eventColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.title.toUpperCase(),
                          style: GoogleFonts.orbitron(fontSize: 10, fontWeight: FontWeight.bold, color: eventColor, letterSpacing: 0.5),
                        ),
                        Text(
                          DateFormat('HH:mm:ss').format(event.timestamp),
                          style: GoogleFonts.orbitron(fontSize: 8, color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.message,
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white, height: 1.4),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// Giúp fix Center alignment style
extension CenterPlayMode on TextAlign {
  static const TextAlign center = TextAlign.center;
}
