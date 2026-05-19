class TransactionModel {
  final String id;
  final double amount;
  final String type; // 'deposit' or 'payment'
  final String status; // 'success', 'pending', 'failed'
  final String date;
  final String description;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.date,
    required this.description,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'deposit',
      status: json['status'] ?? 'pending',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'status': status,
      'date': date,
      'description': description,
    };
  }
}
