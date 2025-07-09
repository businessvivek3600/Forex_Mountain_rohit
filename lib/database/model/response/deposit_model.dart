
class DepositRequest {
  final bool status;
  final int isLoggedIn;
  final String title;
  final String walletBalance;
  final List<PaymentType> paymentTypes;
  final int minimumUsd;
  final List<FundPackage> fundPackage;

  DepositRequest({
    required this.status,
    required this.isLoggedIn,
    required this.title,
    required this.walletBalance,
    required this.paymentTypes,
    required this.minimumUsd,
    required this.fundPackage,
  });

  factory DepositRequest.fromJson(Map<String, dynamic> json) {
    return DepositRequest(
      status: json['status'],
      isLoggedIn: json['is_logged_in'],
      title: json['title'],
      walletBalance: json['wallet_balance'],
      paymentTypes: (json['payment_type'] as List)
          .map((item) => PaymentType.fromJson(item))
          .toList(),
      minimumUsd: json['minimum_usd'],
      fundPackage: (json['fund_package'] as List)
          .map((item) => FundPackage.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'is_logged_in': isLoggedIn,
      'title': title,
      'wallet_balance': walletBalance,
      'payment_type': paymentTypes.map((item) => item.toJson()).toList(),
      'minimum_usd': minimumUsd,
      'fund_package': fundPackage.map((item) => item.toJson()).toList(),
    };
  }
}

class PaymentType {
  final String type;
  final String image;

  PaymentType({
    required this.type,
    required this.image,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      type: json['type'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'image': image,
    };
  }
}

class FundPackage {
  final String id;
  final String orderId;
  final String createdAt;
  final String customerId;
  final String username;
  final String amount;
  final String packageAmount;
  final String? receiverAddress;
  final String totalAmount;
  final String? paymentType;
  final String? paymentUrl;
  final String txnId;
  final String status;
  final String note;
  final String? slip;
  final String? updatedAt;

  FundPackage({
    required this.id,
    required this.orderId,
    required this.createdAt,
    required this.customerId,
    required this.username,
    required this.amount,
    required this.packageAmount,
    this.receiverAddress,
    required this.totalAmount,
    this.paymentType,
    this.paymentUrl,
    required this.txnId,
    required this.status,
    required this.note,
    this.slip,
    this.updatedAt,
  });

  factory FundPackage.fromJson(Map<String, dynamic> json) {
    return FundPackage(
      id: json['id'],
      orderId: json['order_id'],
      createdAt: json['created_at'],
      customerId: json['customer_id'],
      username: json['username'],
      amount: json['amount'],
      packageAmount: json['package_amount'],
      receiverAddress: json['reciver_address'],
      totalAmount: json['total_amount'],
      paymentType: json['payment_type'],
      paymentUrl: json['payment_url'],
      txnId: json['txn_id'],
      status: json['status'],
      note: json['note'],
      slip: json['slip_url'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'created_at': createdAt,
      'customer_id': customerId,
      'username': username,
      'amount': amount,
      'package_amount': packageAmount,
      'reciver_address': receiverAddress,
      'total_amount': totalAmount,
      'payment_type': paymentType,
      'payment_url': paymentUrl,
      'txn_id': txnId,
      'status': status,
      'note': note,
      'slip_url': slip,
      'updated_at': updatedAt,
    };
  }
}
