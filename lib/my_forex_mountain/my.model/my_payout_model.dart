class MyPayoutModel {
  final String id;
  final String date;
  final String customerId;
  final String username;
  final String name;
  final String accountNo;
  final String ifscCode;
  final String bank;
  final String amount;
  final String coin;
  final String status;
  final String pC;
  final String createdAt;
  final String updatedAt;

  MyPayoutModel({
    required this.id,
    required this.date,
    required this.customerId,
    required this.username,
    required this.name,
    required this.accountNo,
    required this.ifscCode,
    required this.bank,
    required this.amount,
    required this.coin,
    required this.status,
    required this.pC,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyPayoutModel.fromJson(Map<String, dynamic> json) {
    return MyPayoutModel(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      customerId: json['customer_id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      accountNo: json['account_no']?.toString() ?? '',
      ifscCode: json['ifsc_code']?.toString() ?? '',
      bank: json['bank']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0.0',
      coin: json['coin']?.toString() ?? '0.0',
      status: json['status']?.toString() ?? '',
      pC: json['p_c']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'customer_id': customerId,
      'username': username,
      'name': name,
      'account_no': accountNo,
      'ifsc_code': ifscCode,
      'bank': bank,
      'amount': amount,
      'coin': coin,
      'status': status,
      'p_c': pC,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
