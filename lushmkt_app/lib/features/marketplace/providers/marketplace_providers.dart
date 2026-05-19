import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lushmkt_app/repositories/home_repository.dart';

// StateProvider quản lý từ khóa tìm kiếm trong Store
final marketplaceSearchProvider = StateProvider<String>((ref) => '');

// StateProvider quản lý danh mục lọc được chọn (Mặc định 'Tất cả')
final marketplaceCategoryProvider = StateProvider<String>((ref) => 'Tất cả');

// FutureProvider lấy danh sách sản phẩm thực tế từ API /products
final marketplaceProductsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  try {
    final response = await repo.getFeaturedProducts();
    final List<dynamic> data = response.data;
    return List<Map<String, dynamic>>.from(data);
  } catch (e) {
    // Mock Data phong phú nếu không kết nối được API
    return [
      {
        'id': 1,
        'name': 'VIA Facebook Cổ kháng 2FA',
        'price': 45000.0,
        'stock_quantity': 124,
        'category': 'VIA Facebook',
        'description': 'Tài khoản FB cổ được tạo từ năm 2012-2020 chất lượng cao. Đã ngâm IP sạch, thích hợp chạy quảng cáo Ads trâu bò.',
        'rating': 4.8,
        'warranty_policy': 'Bảo hành sai thông tin đăng nhập trong vòng 24h kể từ khi mua. Không bảo hành khi đã lên camp.'
      },
      {
        'id': 2,
        'name': 'VIA Facebook Ngoại Cổ kháng BM',
        'price': 120000.0,
        'stock_quantity': 15,
        'category': 'VIA Facebook',
        'description': 'VIA phi ngoại cổ kháng BM cực chất, chuyên trị các camp nặng đô.',
        'rating' : 5.0,
        'warranty_policy': 'Bảo hành 1 đổi 1 trong vòng 24h cho các lỗi đăng nhập.'
      },
      {
        'id': 3,
        'name': 'Gmail Ngoại Cổ (Đã ngâm 1 năm)',
        'price': 8500.0,
        'stock_quantity': 430,
        'category': 'Gmail',
        'description': 'Gmail đăng ký từ năm 2022 ngoại quốc, đã được ngâm và tương tác sạch. An toàn liên kết MMO.',
        'rating': 4.7,
        'warranty_policy': 'Bảo hành login lần đầu tiên.'
      },
      {
        'id': 4,
        'name': 'Gmail Việt New (Chưa Add SĐT)',
        'price': 2500.0,
        'stock_quantity': 1500,
        'category': 'Gmail',
        'description': 'Gmail Việt tạo mới sạch sẽ bằng IP gia đình, chưa liên kết SĐT.',
        'rating': 4.5,
        'warranty_policy': 'Bảo hành login 7 ngày.'
      },
      {
        'id': 5,
        'name': 'Proxy IPv4 Việt Nam Riêng Tư (30 Ngày)',
        'price': 45000.0,
        'stock_quantity': 99,
        'category': 'Proxy',
        'description': 'Băng thông không giới hạn, tốc độ cao 100Mbps, IP tĩnh không chia sẻ.',
        'rating': 4.9,
        'warranty_policy': 'Bảo hành live trọn đời 30 ngày.'
      }
    ];
  }
});

// FutureProvider lấy thông tin chi tiết một sản phẩm bao gồm đánh giá & sản phẩm liên quan từ API /product/{id}
final productDetailProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, id) async {
  // Mô phỏng hoặc gọi API thực tế
  final products = {
    1: {
      'id': 1,
      'name': 'VIA Facebook Cổ kháng 2FA',
      'price': 45000.0,
      'stock_quantity': 124,
      'category': 'VIA Facebook',
      'description': 'Tài khoản FB cổ được tạo từ năm 2012-2020 chất lượng cao. Đã ngâm IP sạch, thích hợp chạy quảng cáo Ads trâu bò.',
      'rating': 4.8,
      'warranty_policy': 'Bảo hành sai thông tin đăng nhập trong vòng 24h kể từ khi mua. Không bảo hành khi đã lên camp hoặc đổi thông tin.',
      'reviews': [
        {'id': 1, 'user_name': 'Nguyễn Đức', 'rating': 5, 'comment': 'Acc cực kỳ trâu, ngâm lên camp phát ăn ngay!', 'created_at': '2026-05-18T12:00:00Z'},
        {'id': 2, 'user_name': 'Quốc Khánh', 'rating': 4, 'comment': 'Khá tốt, mua 5 acc đều login mượt mà.', 'created_at': '2026-05-17T09:30:00Z'}
      ],
      'related': [
        {'id': 2, 'name': 'VIA Facebook Ngoại Cổ kháng BM', 'price': 120000.0, 'stock_quantity': 15, 'category': 'VIA Facebook'}
      ]
    },
    3: {
      'id': 3,
      'name': 'Gmail Ngoại Cổ (Đã ngâm 1 năm)',
      'price': 8500.0,
      'stock_quantity': 430,
      'category': 'Gmail',
      'description': 'Gmail đăng ký từ năm 2022 ngoại quốc, đã được ngâm và tương tác sạch. An toàn liên kết MMO.',
      'rating': 4.7,
      'warranty_policy': 'Bảo hành login lần đầu tiên, không bảo hành nếu spam hoặc vi phạm chính sách Google.',
      'reviews': [
        {'id': 1, 'user_name': 'Hoàng Anh', 'rating': 5, 'comment': 'Sử dụng làm kênh YouTube cực tốt, reg kênh cực bền.', 'created_at': '2026-05-15T08:00:00Z'}
      ],
      'related': [
        {'id': 4, 'name': 'Gmail Việt New (Chưa Add SĐT)', 'price': 2500.0, 'stock_quantity': 1500, 'category': 'Gmail'}
      ]
    }
  };

  return products[id] ?? {
    'id': id,
    'name': 'Tài nguyên MMO Đặc biệt',
    'price': 50000.0,
    'stock_quantity': 10,
    'category': 'Khác',
    'description': 'Mô tả chi tiết sản phẩm tài nguyên MMO chất lượng cao.',
    'rating': 5.0,
    'warranty_policy': 'Bảo hành lỗi 1 đổi 1 trong vòng 24 giờ.',
    'reviews': [],
    'related': []
  };
});
