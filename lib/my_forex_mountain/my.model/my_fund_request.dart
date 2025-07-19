class MyFundRequestModel {
  final String id;
  final String orderId;
  final String createdAt;
  final String paymentType;
  final String totalAmount;
  final String status;
  final String transactionFile;

  MyFundRequestModel({
    required this.id,
    required this.orderId,
    required this.createdAt,
    required this.paymentType,
    required this.totalAmount,
    required this.status,
    required this.transactionFile,
  });

  factory MyFundRequestModel.fromJson(Map<String, dynamic> json) {
    return MyFundRequestModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      paymentType: json['payment_type']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      transactionFile: json['transaction_file']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'created_at': createdAt,
      'payment_type': paymentType,
      'total_amount': totalAmount,
      'status': status,
      'transaction_file': transactionFile,
    };
  }
  String get statusText {
    switch (status) {
      case '0':
        return 'Pending';
      case '1':
        return 'Completed';
      case '2':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }



}
