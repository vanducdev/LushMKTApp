import 'package:get/get.dart';
import 'package:lushmkt_app/repositories/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  var isLoading = false.obs;
  var activeBannerIndex = 0.obs;

  // Realtime Stats
  var onlineUsers = 1240.obs;
  var completedOrders = 89201.obs;
  var systemStatus = 'Ổn định'.obs;

  // Mock Lists loaded from repository
  var banners = <String>[].obs;
  var categories = <Map<String, dynamic>>[].obs;
  var hotServices = <Map<String, dynamic>>[].obs;
  var featuredProducts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  // Fetch Home Data (banners, categories, hot services, featured products, stats)
  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;
      
      // Load mock/real banners
      banners.assignAll([
        'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80',
        'https://images.unsplash.com/photo-1620641788421-7a1c342ea42e?auto=format&fit=crop&w=600&q=80',
      ]);

      // Load mock/real categories
      categories.assignAll([
        {'id': 1, 'name': 'Dịch vụ Facebook', 'icon': 'facebook', 'count': 12},
        {'id': 2, 'name': 'Tài Khoản Gmail', 'icon': 'email', 'count': 8},
        {'id': 3, 'name': 'VIA Facebook', 'icon': 'face', 'count': 15},
        {'id': 4, 'name': 'Proxy Sạch', 'icon': 'vpn_lock', 'count': 5},
      ]);

      // Load hot services
      hotServices.assignAll([
        {'id': 1, 'name': 'Tăng Like FB Giá Rẻ', 'price': '4đ', 'badge': 'HOT'},
        {'id': 2, 'name': 'Tăng Follow VIP FB', 'price': '12đ', 'badge': 'SPEED'},
      ]);

      // Load featured products
      featuredProducts.assignAll([
        {'id': 1, 'name': 'VIA FB Cổ kháng 2FA', 'price': '45.000đ', 'stock': 124},
        {'id': 2, 'name': 'Gmail Ngoại Cổ ngâm', 'price': '8.500đ', 'stock': 430},
      ]);

      // Update real-time stats randomly to simulate live server
      onlineUsers.value = 1200 + (100 - (200 * (1.0 - 0.5))).toInt();

    } catch (e) {
      // Fallback
    } finally {
      isLoading.value = false;
    }
  }

  // Pull-to-refresh trigger
  Future<void> refreshData() async {
    await fetchHomeData();
  }
}
