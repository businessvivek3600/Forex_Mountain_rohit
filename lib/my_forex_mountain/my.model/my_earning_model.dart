

class MyEarning {
  final String id;
  final String createdAt;
  final String note;
  final String amount;

  MyEarning({
    required this.id,
    required this.createdAt,
    required this.note,
    required this.amount,
  });

  /// Factory method to create an instance from JSON
  factory MyEarning.fromJson(Map<String, dynamic> json) {
    return MyEarning(
      id: json['id'] ?? '',
      createdAt: json['created_at'] ?? '',
      note: json['note'] ?? '',
      amount: json['amount'] ?? '',
    );
  }

  /// Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'note': note,
      'amount': amount,
    };
  }
}
