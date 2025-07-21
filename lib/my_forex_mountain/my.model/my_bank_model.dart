class BankDetailsModel {
  final UsdtTrcModel? usdtTrc;
  final UsdtBepModel? usdtBep;
  final BankModel? bank;
  final PhonePayModel? phonePay;
  final GooglePayModel? googlePay;

  BankDetailsModel({
    this.usdtTrc,
    this.usdtBep,
    this.bank,
    this.phonePay,
    this.googlePay,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      usdtTrc: json['usdt_trc'] != null
          ? UsdtTrcModel.fromJson(json['usdt_trc'])
          : null,
      usdtBep: json['usdt_bep'] != null
          ? UsdtBepModel.fromJson(json['usdt_bep'])
          : null,
      bank: json['bank'] != null ? BankModel.fromJson(json['bank']) : null,
      phonePay: json['phone_pay'] != null
          ? PhonePayModel.fromJson(json['phone_pay'])
          : null,
      googlePay: json['google_pay'] != null
          ? GooglePayModel.fromJson(json['google_pay'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usdt_trc': usdtTrc?.toJson(),
      'usdt_bep': usdtBep?.toJson(),
      'bank': bank?.toJson(),
      'phone_pay': phonePay?.toJson(),
      'google_pay': googlePay?.toJson(),
    };
  }
}
class UsdtTrcModel {
  final String? usdtAddress;

  UsdtTrcModel({this.usdtAddress});

  factory UsdtTrcModel.fromJson(Map<String, dynamic> json) {
    return UsdtTrcModel(
      usdtAddress: json['usdt_address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usdt_address': usdtAddress,
    };
  }
}
class UsdtBepModel {
  final String? obdAddress;

  UsdtBepModel({this.obdAddress});

  factory UsdtBepModel.fromJson(Map<String, dynamic> json) {
    return UsdtBepModel(
      obdAddress: json['obd_address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'obd_address': obdAddress,
    };
  }
}
class BankModel {
  final String? bank;
  final String? branch;
  final String? ibnCode;
  final String? swiftCode;
  final String? ifscCode;
  final String? accountHolderName;
  final String? accountNumber;

  BankModel({
    this.bank,
    this.branch,
    this.ibnCode,
    this.swiftCode,
    this.ifscCode,
    this.accountHolderName,
    this.accountNumber,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      bank: json['bank'] as String?,
      branch: json['branch'] as String?,
      ibnCode: json['ibn_code'] as String?,
      swiftCode: json['swift_code'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      accountHolderName: json['account_holder_name'] as String?,
      accountNumber: json['account_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'branch': branch,
      'ibn_code': ibnCode,
      'swift_code': swiftCode,
      'ifsc_code': ifscCode,
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
    };
  }
}
class PhonePayModel {
  final String? phonePayNo;
  final String? phonePayId;
  final String? phonePayQr;

  PhonePayModel({
    this.phonePayNo,
    this.phonePayId,
    this.phonePayQr,
  });

  factory PhonePayModel.fromJson(Map<String, dynamic> json) {
    return PhonePayModel(
      phonePayNo: json['phone_pay_no'] as String?,
      phonePayId: json['phone_pay_id'] as String?,
      phonePayQr: json['phone_pay_qr'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_pay_no': phonePayNo,
      'phone_pay_id': phonePayId,
      'phone_pay_qr': phonePayQr,
    };
  }
}
class GooglePayModel {
  final String? googlePayNo;
  final String? googlePayId;
  final String? googlePayQr;

  GooglePayModel({
    this.googlePayNo,
    this.googlePayId,
    this.googlePayQr,
  });

  factory GooglePayModel.fromJson(Map<String, dynamic> json) {
    return GooglePayModel(
      googlePayNo: json['google_pay_no'] as String?,
      googlePayId: json['google_pay_id'] as String?,
      googlePayQr: json['google_pay_qr'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'google_pay_no': googlePayNo,
      'google_pay_id': googlePayId,
      'google_pay_qr': googlePayQr,
    };
  }
}
