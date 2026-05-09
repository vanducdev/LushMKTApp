import 'package:get/get.dart';
import '../../data/models/service_model.dart';
import '../../data/repositories/order_repository.dart';

class OrderController extends GetxController {
  final OrderRepository _repository = OrderRepository();

  var isLoading = false.obs;
  var services = <ServiceModel>[].obs;
  var orders = <Map<String, dynamic>>[].obs;

  var selectedService = Rxn<ServiceModel>();
  var targetLink = ''.obs;
  var quantity = 100.obs;
  var totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServicesAndHistory();
  }

  void fetchServicesAndHistory() {
    // Populate with mock Facebook Services matching the Database seeder
    services.assignAll([
      ServiceModel(
        id: 1,
        categoryId: 1,
        name: 'Tăng Like Facebook Bài Viết (Tốc độ cao)',
        code: 'fb_like_speed',
        pricePerOne: 4.0,
        minQuantity: 100,
        maxQuantity: 50000,
        description: 'Tốc độ lên nhanh cực đại, an toàn cho nick.',
        isActive: true,
      ),
      ServiceModel(
        id: 2,
        categoryId: 1,
        name: 'Tăng Follow Trang Cá Nhân VIP',
        code: 'fb_follow_vip',
        pricePerOne: 12.0,
        minQuantity: 500,
        maxQuantity: 100000,
        description: 'Sub thật chất lượng cao có bảo hành tụt 30 ngày.',
        isActive: true,
      ),
      ServiceModel(
        id: 3,
        categoryId: 1,
        name: 'Buff Comment Facebook Động',
        code: 'fb_comment_custom',
        pricePerOne: 8.0,
        minQuantity: 10,
        maxQuantity: 5000,
        description: 'Tự soạn nội dung viết mỗi bình luận một dòng mới.',
        isActive: true,
      ),
    ]);

    // Set default selected service
    if (services.isNotEmpty) {
      selectedService.value = services[0];
      calculatePrice();
    }

    // Populate mock order history
    orders.assignAll([
      {
        'id': 'OD-78192',
        'service_name': 'Tăng Like Facebook Bài Viết',
        'target_link': 'https://facebook.com/post/123456789',
        'quantity': 1000,
        'total_price': '4.000đ',
        'status': 'Đang chạy',
        'date': '09:30 - 09/05/2026',
      },
      {
        'id': 'OD-67123',
        'service_name': 'Tăng Follow Trang Cá Nhân VIP',
        'target_link': 'https://facebook.com/profile/1000213123',
        'quantity': 500,
        'total_price': '6.000đ',
        'status': 'Hoàn thành',
        'date': '15:20 - 08/05/2026',
      }
    ]);
  }

  void calculatePrice() {
    if (selectedService.value != null) {
      totalPrice.value = selectedService.value!.pricePerOne * quantity.value;
    }
  }

  Future<bool> createOrder() async {
    if (selectedService.value == null || targetLink.isEmpty || quantity.value <= 0) {
      return false;
    }

    try {
      isLoading.value = true;
      // In production: await _repository.createServiceOrder(...)
      
      // Add new order to history list dynamically
      orders.insert(0, {
        'id': 'OD-${10000 + orders.length}',
        'service_name': selectedService.value!.name,
        'target_link': targetLink.value,
        'quantity': quantity.value,
        'total_price': '${totalPrice.value.toInt()}đ',
        'status': 'Đang chờ duyệt',
        'date': 'Vừa xong',
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
