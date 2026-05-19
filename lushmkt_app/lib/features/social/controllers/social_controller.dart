import 'package:get/get.dart';
import 'package:lushmkt_app/models/social_models.dart';
import 'package:lushmkt_app/features/auth/controllers/auth_controller.dart';

class SocialController extends GetxController {
  final AuthController _authController = Get.put(AuthController());

  // 1. Social Network State
  var posts = <SocialPostModel>[].obs;

  // 2. Store State (EXE, PY, IPA resources)
  var storeProducts = <DigitalResourceModel>[].obs;

  // 3. Deposit Orders (Fintech + Admin approvals)
  var depositOrders = <DepositOrder>[].obs;
  var activeCountdownSeconds = (15 * 60).obs; // 15 minutes countdown

  // 4. Notifications State
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialMockData();
  }

  void _loadInitialMockData() {
    // 1. Starter posts (blank for new users, but displaying interactive seed content)
    posts.addAll([
      SocialPostModel(
        id: 1,
        authorName: 'ADMIN LUSH',
        authorEmail: 'admin@lushmkt.com',
        text: 'Chào mừng các thành viên đến với siêu ứng dụng LushMKT - Chợ tài nguyên MMO và Mạng xã hội tự động hóa lớn nhất Việt Nam!',
        location: 'Hà Nội, Việt Nam',
        likes: 124,
        comments: ['App mượt quá admin ơi', 'Giao diện chuyên nghiệp quá!', 'Rất thích phần nạp tự động'],
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      SocialPostModel(
        id: 2,
        authorName: 'NGUYEN VAN DUC',
        authorEmail: 'duc@lushmkt.com',
        text: 'Mình vừa phát hành Tool tự động hóa Nuôi Facebook nuôi cực cứng, anh em ghé qua phần Store tải file .exe hoặc .py nhé!',
        location: 'Đà Nẵng, Việt Nam',
        likes: 45,
        comments: ['Đã tải test thử rất ngon', 'Sẽ ủng hộ tác giả'],
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
    ]);

    // 2. Starter Store items
    storeProducts.addAll([
      DigitalResourceModel(
        id: 1,
        name: 'LushAutoNuoi FB Tool',
        description: 'Phần mềm tự động nuôi nick Facebook, lên lịch đăng bài, kháng spam hiệu quả tối đa.',
        fileType: '.exe',
        fileUrl: 'https://lushmkt.com/downloads/lush_autonuoi.exe',
        category: 'Tool Nuôi Account',
        price: 150000,
        authorName: 'NGUYEN VAN DUC',
      ),
      DigitalResourceModel(
        id: 2,
        name: 'Auto Like Script (Python)',
        description: 'Script python gọn nhẹ tự động tương tác bài viết theo token cực kỳ an toàn.',
        fileType: '.py',
        fileUrl: 'https://lushmkt.com/downloads/auto_like.py',
        category: 'Python Scripts',
        price: 49000,
        authorName: 'ADMIN LUSH',
      ),
      DigitalResourceModel(
        id: 3,
        name: 'LushMKT iOS Sideload Package',
        description: 'Tệp tin cài đặt LushMKT trực tiếp hỗ trợ sideload đầy đủ cho iPhone.',
        fileType: '.ipa',
        fileUrl: 'https://lushmkt.com/downloads/lushmkt.ipa',
        category: 'iOS Applications',
        price: 0,
        authorName: 'ADMIN LUSH',
      ),
    ]);

    // 3. Initial system notification
    notifications.add(
      NotificationModel(
        id: 1,
        title: 'Chào mừng thành viên mới!',
        body: 'Cảm ơn bạn đã tham gia hệ sinh thái công nghệ MMO LushMKT.',
        type: 'system',
        timestamp: DateTime.now(),
      ),
    );
  }

  // --- SOCIAL FEED ACTIONS ---
  void createPost(String text, String? imageUrl, String? location) {
    final user = _authController.currentUser.value;
    final name = user?.name ?? 'Lush User';
    final email = user?.email ?? 'user@lushmkt.com';

    final newPost = SocialPostModel(
      id: posts.length + 1,
      authorName: name,
      authorEmail: email,
      text: text,
      imageUrl: imageUrl,
      location: location,
      comments: [],
      timestamp: DateTime.now(),
    );

    posts.insert(0, newPost);
    addNotification('Bài viết mới được đăng', 'Bạn vừa chia sẻ bài viết mới thành công.', 'post');
  }

  void likePost(int id) {
    final index = posts.indexWhere((p) => p.id == id);
    if (index != -1) {
      posts[index].likes++;
      posts.refresh();
      addNotification('Tương tác mới', 'Tài khoản khác đã thả tim bài viết của bạn.', 'like');
    }
  }

  void commentPost(int id, String commentText) {
    final index = posts.indexWhere((p) => p.id == id);
    if (index != -1 && commentText.isNotEmpty) {
      posts[index].comments.add(commentText);
      posts.refresh();
      addNotification('Bình luận mới', 'Ai đó vừa bình luận về bài đăng của bạn.', 'like');
    }
  }

  // --- STORE CRUD ACTIONS ---
  void addStoreProduct({
    required String name,
    required String description,
    required String fileType,
    required String category,
    required double price,
    String? fileUrl,
  }) {
    final user = _authController.currentUser.value;
    final author = user?.name ?? 'Lush User';

    final newProduct = DigitalResourceModel(
      id: storeProducts.length + 1,
      name: name,
      description: description,
      fileType: fileType,
      fileUrl: fileUrl ?? 'https://lushmkt.com/downloads/custom_resource',
      category: category,
      price: price,
      authorName: author,
    );

    storeProducts.insert(0, newProduct);
    addNotification('Sản phẩm mới đăng bán', 'Sản phẩm "$name" của bạn đã được đăng bán trong Store.', 'system');
  }

  void updateStoreProduct(int id, {
    required String name,
    required String description,
    required String fileType,
    required String category,
    required double price,
  }) {
    final index = storeProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      storeProducts[index].name = name;
      storeProducts[index].description = description;
      storeProducts[index].fileType = fileType;
      storeProducts[index].category = category;
      storeProducts[index].price = price;
      storeProducts.refresh();
      addNotification('Đã cập nhật sản phẩm', 'Sản phẩm "$name" đã cập nhật thông tin thành công.', 'system');
    }
  }

  void deleteStoreProduct(int id) {
    storeProducts.removeWhere((p) => p.id == id);
    addNotification('Đã xóa sản phẩm', 'Đã gỡ bỏ sản phẩm ra khỏi Store thành công.', 'system');
  }

  // --- FINTECH PAYMENT & RECHARGE ACTIONS ---
  void createDepositOrder(double amount) {
    final user = _authController.currentUser.value;
    final email = user?.email ?? 'user@lushmkt.com';

    final newOrder = DepositOrder(
      id: 'LUSH${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      amount: amount,
      bankName: 'MB Bank (Quân Đội)',
      accountNumber: '0359261551',
      accountHolder: 'NGUYEN VAN DUC',
      transferNote: 'LUSH ${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
      userEmail: email,
      createdAt: DateTime.now(),
    );

    depositOrders.insert(0, newOrder);
    activeCountdownSeconds.value = 15 * 60; // Reset countdown
    addNotification('Đã tạo đơn nạp tiền', 'Đơn nạp số tiền ${amount.toInt()}đ đã được tạo thành công.', 'deposit');
  }

  // Admin approves a deposit order, updating user's balance and pushing notifications
  void adminApproveDeposit(String orderId) {
    final index = depositOrders.indexWhere((o) => o.id == orderId);
    if (index != -1 && depositOrders[index].status == 'pending') {
      depositOrders[index].status = 'approved';
      depositOrders.refresh();

      // Trigger user balance update
      final amount = depositOrders[index].amount;
      final user = _authController.currentUser.value;
      if (user != null) {
        user.balance += amount;
        _authController.currentUser.refresh();
      }

      addNotification(
        'Nạp tiền thành công',
        'Tài khoản của bạn đã được cộng +${amount.toInt().toString()}đ tự động từ đơn hàng $orderId.',
        'deposit',
      );
    }
  }

  void adminDeclineDeposit(String orderId) {
    final index = depositOrders.indexWhere((o) => o.id == orderId);
    if (index != -1 && depositOrders[index].status == 'pending') {
      depositOrders[index].status = 'declined';
      depositOrders.refresh();
      addNotification('Đơn nạp bị từ chối', 'Đơn nạp tiền $orderId của bạn đã bị từ chối hoặc lỗi giao dịch.', 'deposit');
    }
  }

  // --- MESSENGER-LIKE NOTIFICATIONS CONTROL ---
  void addNotification(String title, String body, String type) {
    final newNotif = NotificationModel(
      id: notifications.length + 1,
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
    );
    notifications.insert(0, newNotif);
  }

  void markAllAsRead() {
    for (var notif in notifications) {
      notif.isRead = true;
    }
    notifications.refresh();
  }
}
