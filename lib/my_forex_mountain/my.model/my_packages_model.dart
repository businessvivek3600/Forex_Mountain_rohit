class MyPackagesModel {
  final bool status;
  final int isLogin;
  final String message;
  final Data? data;

  MyPackagesModel({
    required this.status,
    required this.isLogin,
    required this.message,
    this.data,
  });

  factory MyPackagesModel.fromJson(Map<String, dynamic> json) => MyPackagesModel(
    status: json['status'] ?? false,
    isLogin: json['is_login'] ?? 0,
    message: json['message'] ?? '',
    data: json['data'] != null ? Data.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'is_login': isLogin,
    'message': message,
    'data': data?.toJson(),
  };
}

class Data {
  final Packages? packages;
  final List<BuyPackage>? buyPackage;

  Data({
    this.packages,
    this.buyPackage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    packages:
    json['packages'] != null ? Packages.fromJson(json['packages']) : null,
    buyPackage: (json['buy_package'] as List<dynamic>?)
        ?.map((e) => BuyPackage.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'packages': packages?.toJson(),
    'buy_package': buyPackage?.map((e) => e.toJson()).toList(),
  };
}

class Packages {
  final List<Package>? fct;
  final List<Package>? mtp;
  final List<Package>? sip;

  Packages({
    this.fct,
    this.mtp,
    this.sip,
  });

  factory Packages.fromJson(Map<String, dynamic> json) => Packages(
    fct: (json['fct'] as List<dynamic>?)
        ?.map((e) => Package.fromJson(e))
        .toList(),
    mtp: (json['mtp'] as List<dynamic>?)
        ?.map((e) => Package.fromJson(e))
        .toList(),
    sip: (json['sip'] as List<dynamic>?)
        ?.map((e) => Package.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'fct': fct?.map((e) => e.toJson()).toList(),
    'mtp': mtp?.map((e) => e.toJson()).toList(),
    'sip': sip?.map((e) => e.toJson()).toList(),
  };
}

class Package {
  final String? id;
  final String? planId;
  final String? name;
  final String? minAmt;
  final String? directPer;
  final String? duration;
  final String? returnPer;
  final String? etfPer;
  final String? levelMonth;
  final String? status;
  final String? updatedAt;

  Package({
    this.id,
    this.planId,
    this.name,
    this.minAmt,
    this.directPer,
    this.duration,
    this.returnPer,
    this.etfPer,
    this.levelMonth,
    this.status,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json['id'],
    planId: json['plan_id'],
    name: json['name'],
    minAmt: json['min_amt'],
    directPer: json['direct_per'],
    duration: json['duration'],
    returnPer: json['return_per'],
    etfPer: json['etf_per'],
    levelMonth: json['level_month'],
    status: json['status'],
    updatedAt: json['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan_id': planId,
    'name': name,
    'min_amt': minAmt,
    'direct_per': directPer,
    'duration': duration,
    'return_per': returnPer,
    'etf_per': etfPer,
    'level_month': levelMonth,
    'status': status,
    'updated_at': updatedAt,
  };
}

class BuyPackage {
  final String? id;
  final String? invoice;
  final String? invoiceId;
  final String? createdAt;
  final String? customerId;
  final String? username;
  final String? paymentType;
  final String? planId;
  final String? packageId;
  final String? packageName;
  final String? packageAmount;
  final String? duration;
  final String? directPer;
  final String? returnPer;
  final String? status;
  final String? dI;
  final String? startDate;
  final String? nextDate;
  final String? tLMonth;
  final String? rLMonth;
  final String? updatedAt;
  final String? etfPer;
  final String? nextReward; // ✅ new field

  BuyPackage({
    this.id,
    this.invoice,
    this.invoiceId,
    this.createdAt,
    this.customerId,
    this.username,
    this.paymentType,
    this.planId,
    this.packageId,
    this.packageName,
    this.packageAmount,
    this.duration,
    this.directPer,
    this.returnPer,
    this.status,
    this.dI,
    this.startDate,
    this.nextDate,
    this.tLMonth,
    this.rLMonth,
    this.updatedAt,
    this.etfPer,
    this.nextReward,
  });

  factory BuyPackage.fromJson(Map<String, dynamic> json) => BuyPackage(
    id: json['id'],
    invoice: json['invoice'],
    invoiceId: json['invoice_id'],
    createdAt: json['created_at'],
    customerId: json['customer_id'],
    username: json['username'],
    paymentType: json['payment_type'],
    planId: json['plan_id'],
    packageId: json['package_id'],
    packageName: json['package_name'],
    packageAmount: json['package_amount'],
    duration: json['duration'],
    directPer: json['direct_per'],
    returnPer: json['return_per'],
    status: json['status'],
    dI: json['d_i'],
    startDate: json['start_date'],
    nextDate: json['next_date'],
    tLMonth: json['t_l_month'],
    rLMonth: json['r_l_month'],
    updatedAt: json['updated_at'],
    etfPer: json['etf_per'],
    nextReward: json['next_reward'], // ✅ mapped
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'invoice': invoice,
    'invoice_id': invoiceId,
    'created_at': createdAt,
    'customer_id': customerId,
    'username': username,
    'payment_type': paymentType,
    'plan_id': planId,
    'package_id': packageId,
    'package_name': packageName,
    'package_amount': packageAmount,
    'duration': duration,
    'direct_per': directPer,
    'return_per': returnPer,
    'status': status,
    'd_i': dI,
    'start_date': startDate,
    'next_date': nextDate,
    't_l_month': tLMonth,
    'r_l_month': rLMonth,
    'updated_at': updatedAt,
    'etf_per': etfPer,
    'next_reward': nextReward, // ✅ included
  };
}

