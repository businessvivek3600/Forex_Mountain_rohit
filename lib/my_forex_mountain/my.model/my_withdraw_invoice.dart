class InvDetail {
  final String id;
  final String date;
  final String type;
  final String customerId;
  final String username;
  final String name;
  final String accountHolderName;
  final String? accountNo;
  final String ifscCode;
  final String? bank;
  final String? branch;
  final String? ibnCode;
  final String? swiftCode;
  final String? btcAddress;
  final String? bizzcoinAddress;
  final String? bizzcoinAddressTrc20;
  final String? usdtAddress;
  final String? obdAddress;
  final String? phonePayNo;
  final String? phonePayId;
  final String? phonePayQr;
  final String? googlePayNo;
  final String? googlePayId;
  final String? googlePayQr;
  final String amount;
  final String minBal;
  final String adminPer;
  final String adminCharge;
  final String tdsPer;
  final String tdsCharge;
  final String repurchasedPer;
  final String repurchasedCharge;
  final String netPayable;
  final String coinPrice;
  final String netCoinPrice;
  final String paymentType;
  final String country;
  final String currency;
  final String currencyAmt;
  final String transactionNumber;
  final String status;
  final String? remarks;
  final String? ipAddress;
  final String createdAt;
  final String? updatedAt;

  InvDetail({
    required this.id,
    required this.date,
    required this.type,
    required this.customerId,
    required this.username,
    required this.name,
    required this.accountHolderName,
    this.accountNo,
    required this.ifscCode,
    this.bank,
    this.branch,
    this.ibnCode,
    this.swiftCode,
    this.btcAddress,
    this.bizzcoinAddress,
    this.bizzcoinAddressTrc20,
    this.usdtAddress,
    this.obdAddress,
    this.phonePayNo,
    this.phonePayId,
    this.phonePayQr,
    this.googlePayNo,
    this.googlePayId,
    this.googlePayQr,
    required this.amount,
    required this.minBal,
    required this.adminPer,
    required this.adminCharge,
    required this.tdsPer,
    required this.tdsCharge,
    required this.repurchasedPer,
    required this.repurchasedCharge,
    required this.netPayable,
    required this.coinPrice,
    required this.netCoinPrice,
    required this.paymentType,
    required this.country,
    required this.currency,
    required this.currencyAmt,
    required this.transactionNumber,
    required this.status,
    this.remarks,
    this.ipAddress,
    required this.createdAt,
    this.updatedAt,
  });

  factory InvDetail.fromJson(Map<String, dynamic> json) {
    return InvDetail(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      customerId: json['customer_id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      accountNo: json['account_no'],
      ifscCode: json['ifsc_code'] ?? '',
      bank: json['bank'],
      branch: json['branch'],
      ibnCode: json['ibn_code'],
      swiftCode: json['swift_code'],
      btcAddress: json['btc_address'],
      bizzcoinAddress: json['bizzcoin_address'],
      bizzcoinAddressTrc20: json['bizzcoin_address_trc20'],
      usdtAddress: json['usdt_address'],
      obdAddress: json['obd_address'],
      phonePayNo: json['phone_pay_no'],
      phonePayId: json['phone_pay_id'],
      phonePayQr: json['phone_pay_qr'],
      googlePayNo: json['google_pay_no'],
      googlePayId: json['google_pay_id'],
      googlePayQr: json['google_pay_qr'],
      amount: json['amount'] ?? '0',
      minBal: json['min_bal'] ?? '0',
      adminPer: json['admin_per'] ?? '0',
      adminCharge: json['admin_charge'] ?? '0',
      tdsPer: json['tds_per'] ?? '0',
      tdsCharge: json['tds_charge'] ?? '0',
      repurchasedPer: json['repurchased_per'] ?? '0',
      repurchasedCharge: json['repurchased_charge'] ?? '0',
      netPayable: json['net_payable'] ?? '0',
      coinPrice: json['coin_price'] ?? '0',
      netCoinPrice: json['net_coin_price'] ?? '0',
      paymentType: json['payment_type'] ?? '',
      country: json['country'] ?? '',
      currency: json['currency'] ?? '0',
      currencyAmt: json['currency_amt'] ?? '0',
      transactionNumber: json['transaction_number'] ?? '',
      status: json['status'] ?? '',
      remarks: json['remarks'],
      ipAddress: json['ip_address'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'customer_id': customerId,
      'username': username,
      'name': name,
      'account_holder_name': accountHolderName,
      'account_no': accountNo,
      'ifsc_code': ifscCode,
      'bank': bank,
      'branch': branch,
      'ibn_code': ibnCode,
      'swift_code': swiftCode,
      'btc_address': btcAddress,
      'bizzcoin_address': bizzcoinAddress,
      'bizzcoin_address_trc20': bizzcoinAddressTrc20,
      'usdt_address': usdtAddress,
      'obd_address': obdAddress,
      'phone_pay_no': phonePayNo,
      'phone_pay_id': phonePayId,
      'phone_pay_qr': phonePayQr,
      'google_pay_no': googlePayNo,
      'google_pay_id': googlePayId,
      'google_pay_qr': googlePayQr,
      'amount': amount,
      'min_bal': minBal,
      'admin_per': adminPer,
      'admin_charge': adminCharge,
      'tds_per': tdsPer,
      'tds_charge': tdsCharge,
      'repurchased_per': repurchasedPer,
      'repurchased_charge': repurchasedCharge,
      'net_payable': netPayable,
      'coin_price': coinPrice,
      'net_coin_price': netCoinPrice,
      'payment_type': paymentType,
      'country': country,
      'currency': currency,
      'currency_amt': currencyAmt,
      'transaction_number': transactionNumber,
      'status': status,
      'remarks': remarks,
      'ip_address': ipAddress,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }
}