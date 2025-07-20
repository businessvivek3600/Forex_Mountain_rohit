class BankDetailsModel {
  final String? usdtAddress;
  final String? obdAddress;
  final String? bank;
  final String? branch;
  final String? ibnCode;
  final String? swiftCode;
  final String? ifscCode;
  final String? accountHolderName;
  final String? accountNumber;
  final String? phonePayNo;
  final String? phonePayId;
  final String? phonePayQr;
  final String? googlePayNo;
  final String? googlePayId;
  final String? googlePayQr;

  BankDetailsModel({
    this.usdtAddress,
    this.obdAddress,
    this.bank,
    this.branch,
    this.ibnCode,
    this.swiftCode,
    this.ifscCode,
    this.accountHolderName,
    this.accountNumber,
    this.phonePayNo,
    this.phonePayId,
    this.phonePayQr,
    this.googlePayNo,
    this.googlePayId,
    this.googlePayQr,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      usdtAddress: json['usdt_address'] as String?,
      obdAddress: json['obd_address'] as String?,
      bank: json['bank'] as String?,
      branch: json['branch'] as String?,
      ibnCode: json['ibn_code'] as String?,
      swiftCode: json['swift_code'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      accountHolderName: json['account_holder_name'] as String?,
      accountNumber: json['account_number'] as String?,
      phonePayNo: json['phone_pay_no'] as String?,
      phonePayId: json['phone_pay_id'] as String?,
      phonePayQr: json['phone_pay_qr'] as String?,
      googlePayNo: json['google_pay_no'] as String?,
      googlePayId: json['google_pay_id'] as String?,
      googlePayQr: json['google_pay_qr'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usdt_address': usdtAddress,
      'obd_address': obdAddress,
      'bank': bank,
      'branch': branch,
      'ibn_code': ibnCode,
      'swift_code': swiftCode,
      'ifsc_code': ifscCode,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'phone_pay_no': phonePayNo,
      'phone_pay_id': phonePayId,
      'phone_pay_qr': phonePayQr,
      'google_pay_no': googlePayNo,
      'google_pay_id': googlePayId,
      'google_pay_qr': googlePayQr,
    };
  }
}
