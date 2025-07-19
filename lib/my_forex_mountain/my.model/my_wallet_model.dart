class MyWalletData {
  final String id;
  final String createdAt;
  final String note;
  final String credit;
  final String debit;
  final String balance;

  MyWalletData({
    required this.id,
    required this.createdAt,
    required this.note,
    required this.credit,
    required this.debit,
    required this.balance,
  });

  factory MyWalletData.fromJson(Map<String, dynamic> json) {
    return MyWalletData(
      id: json['id']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      credit: json['credit']?.toString() ?? '0.00',
      debit: json['debit']?.toString() ?? '0.00',
      balance: json['balance']?.toString() ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'note': note,
      'credit': credit,
      'debit': debit,
      'balance': balance,
    };
  }
}
