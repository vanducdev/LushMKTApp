class ServiceModel {
  final int id;
  final int categoryId;
  final String name;
  final String code;
  final double pricePerOne;
  final int minQuantity;
  final int maxQuantity;
  final String description;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.code,
    required this.pricePerOne,
    required this.minQuantity,
    required this.maxQuantity,
    required this.description,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      pricePerOne: (json['price_per_one'] as num?)?.toDouble() ?? 0.0,
      minQuantity: json['min_quantity'] ?? 0,
      maxQuantity: json['max_quantity'] ?? 0,
      description: json['description'] ?? '',
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'code': code,
      'price_per_one': pricePerOne,
      'min_quantity': minQuantity,
      'max_quantity': maxQuantity,
      'description': description,
      'is_active': isActive,
    };
  }
}
