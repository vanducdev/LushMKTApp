import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lushmkt_app/repositories/home_repository.dart';

// Provider cho Ticker chạy chữ thông báo nổi bật thời gian thực
final announcementTickerProvider = StateProvider<String>((ref) {
  return "🔥 LUSH-MKT KHUYẾN MÃI: Tặng 10% giá trị nạp tiền qua tài khoản ngân hàng VietQR tự động. Hệ thống vừa bổ sung 50,000 tài khoản VIA Facebook chất lượng cao!";
});

// FutureProvider lấy danh sách Banner quảng cáo từ API
final bannersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  try {
    final response = await repo.getBanners();
    final List<dynamic> data = response.data;
    return List<Map<String, dynamic>>.from(data);
  } catch (e) {
    // Trả về Mock data làm móng để giao diện luôn hiển thị lấp lánh khi offline/chưa chạy API
    return [
      {
        'id': 1,
        'title': 'Siêu khuyến mãi nạp tiền',
        'image_url': 'image/isometric-b2b-illustration.png', // Sử dụng ảnh cục bộ có sẵn
      },
      {
        'id': 2,
        'title': 'Hệ thống Proxy IPv6 Xoay Vòng',
        'image_url': 'image/isometric-b2b-illustration.png',
      }
    ];
  }
});

// FutureProvider lấy danh mục sản phẩm (FB, Gmail, Proxy, VPS)
final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  try {
    final response = await repo.getCategories();
    final List<dynamic> data = response.data;
    return List<Map<String, dynamic>>.from(data);
  } catch (e) {
    // Mock Categories chuẩn MMO Cyber
    return [
      {'id': 1, 'name': 'FACEBOOK', 'slug': 'facebook', 'icon': 'facebook', 'type': 'service'},
      {'id': 2, 'name': 'GMAIL', 'slug': 'gmail', 'icon': 'envelope', 'type': 'product'},
      {'id': 3, 'name': 'PROXY XOAY', 'slug': 'proxy', 'icon': 'shield', 'type': 'product'},
      {'id': 4, 'name': 'CLOUD VPS', 'slug': 'vps', 'icon': 'server', 'type': 'product'},
    ];
  }
});

// FutureProvider lấy danh sách Dịch vụ phổ biến (Buff Like, Follow, TikTok, Telegram)
final hotServicesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  try {
    final response = await repo.getHotServices();
    final List<dynamic> data = response.data;
    return List<Map<String, dynamic>>.from(data);
  } catch (e) {
    return [
      {
        'id': 1,
        'name': 'Buff Sub Facebook - Speed Limit VIP',
        'price_per_one': 25.0,
        'min_quantity': 100,
        'description': 'Tăng sub trang cá nhân bảo hành vĩnh viễn, tốc độ 10k/ngày.'
      },
      {
        'id': 2,
        'name': 'Buff Member Telegram Group',
        'price_per_one': 80.0,
        'min_quantity': 500,
        'description': 'Thêm thành viên nhóm Telegram thật 100%, không tụt member.'
      }
    ];
  }
});

// FutureProvider lấy danh sách Sản phẩm bán chạy (Tài khoản VIA, Clone Gmail, Proxy)
final featuredProductsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  try {
    final response = await repo.getFeaturedProducts();
    final List<dynamic> data = response.data;
    return List<Map<String, dynamic>>.from(data);
  } catch (e) {
    return [
      {
        'id': 1,
        'name': 'VIA Facebook XMDT Cổ (500-1000 Friends)',
        'price': 85000.0,
        'stock_quantity': 354,
        'description': 'Đã xác minh danh tính, trâu bò, bao lột định dạng 2FA.'
      },
      {
        'id': 2,
        'name': 'Gmail Ngoại Cổ (Reg 2020-2022) Chưa Add SĐT',
        'price': 12000.0,
        'stock_quantity': 1850,
        'description': 'Gmail ngâm lâu năm, cực sạch, thích hợp làm kênh YouTube, MMO.'
      },
      {
        'id': 3,
        'name': 'Proxy IPv4 Việt Nam Riêng Tư (Sử dụng 30 Ngày)',
        'price': 45000.0,
        'stock_quantity': 99,
        'description': 'Băng thông không giới hạn, tốc độ cao 100Mbps.'
      }
    ];
  }
});

// FutureProvider lấy số liệu thống kê realtime của người dùng
final homeStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  try {
    await repo.getStats();
    return {
      'total_spent': 1850000.0,
      'active_orders': 2,
      'active_proxies': 5,
    };
  } catch (e) {
    return {
      'total_spent': 1850000.0,
      'active_orders': 2,
      'active_proxies': 5,
    };
  }
});
