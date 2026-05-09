class UserModel {
  final int id;
  String name;
  final String email;
  double balance;
  final String role;
  final String? apiKey;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.role,
    this.apiKey,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      role: json['role'] ?? 'user',
      apiKey: json['api_key'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'balance': balance,
      'role': role,
      'api_key': apiKey,
      'avatar': avatar,
    };
  }
}
