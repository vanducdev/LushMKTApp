class ProductModel {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      category: json['category'] ?? 'VIA Facebook',
      description: json['description'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewCount: json['review_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'description': description,
      'rating': rating,
      'review_count': reviewCount,
    };
  }
}
