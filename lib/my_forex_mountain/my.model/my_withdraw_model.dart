class WalletResponse {
  final String walletBalance;
  final List<MyWithdrawRequestModel> transactions;

  WalletResponse({
    required this.walletBalance,
    required this.transactions,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      walletBalance: json['wallet_balance']?.toString() ?? '0.0000',
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => MyWithdrawRequestModel.fromJson(e))
          .toList(),
    );
  }
}



class MyWithdrawRequestModel {
  final String id;
  final String createdAt;
  final String username;
  final String name;
  final String netPayable;
  final String paymentType;
  final String status;

  MyWithdrawRequestModel({
    required this.id,
    required this.createdAt,
    required this.username,
    required this.name,
    required this.netPayable,
    required this.paymentType,
    required this.status,
  });

  factory MyWithdrawRequestModel.fromJson(Map<String, dynamic> json) {
    return MyWithdrawRequestModel(
      id: json['id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      netPayable: json['net_payable']?.toString() ?? '0.0',
      paymentType: json['payment_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'username': username,
      'name': name,
      'net_payable': netPayable,
      'payment_type': paymentType,
      'status': status,
    };
  }
}
