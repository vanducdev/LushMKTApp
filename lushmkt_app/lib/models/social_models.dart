class SocialPostModel {
  final int id;
  final String authorName;
  final String authorEmail;
  final String text;
  final String? imageUrl;
  final String? location;
  int likes;
  List<String> comments;
  final DateTime timestamp;

  SocialPostModel({
    required this.id,
    required this.authorName,
    required this.authorEmail,
    required this.text,
    this.imageUrl,
    this.location,
    this.likes = 0,
    required this.comments,
    required this.timestamp,
  });
}

class DigitalResourceModel {
  final int id;
  String name;
  String description;
  String fileType; // .exe, .py, .ipa, .zip etc.
  String? fileUrl;
  String category;
  double price;
  final String authorName;

  DigitalResourceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.fileType,
    this.fileUrl,
    required this.category,
    this.price = 0.0,
    required this.authorName,
  });
}

class DepositOrder {
  final String id;
  final double amount;
  String status; // 'pending', 'approved', 'declined'
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String transferNote;
  final String userEmail;
  final DateTime createdAt;

  DepositOrder({
    required this.id,
    required this.amount,
    this.status = 'pending',
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.transferNote,
    required this.userEmail,
    required this.createdAt,
  });
}

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type; // 'deposit', 'post', 'like', 'system'
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}
