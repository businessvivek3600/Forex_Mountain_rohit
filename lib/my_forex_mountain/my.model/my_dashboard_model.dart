import 'my_customer_model.dart';

class DashboardModel {
  final String? title;
  final MyCustomerModel? customer;
  final MemberSaleModel? memberSale;
  final List<BuyPackageModel>? buyPackages;

  DashboardModel({
    this.title,
    this.customer,
    this.memberSale,
    this.buyPackages,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      title: json['title'],
      customer: json['customer'] != null ? MyCustomerModel.fromJson(json['customer']) : null,
      memberSale: json['member_sale'] != null ? MemberSaleModel.fromJson(json['member_sale']) : null,
      buyPackages: json['buy_packages'] is List
          ? (json['buy_packages'] as List)
          .map((e) => BuyPackageModel.fromJson(e))
          .toList()
          : [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'customer': customer?.toJson(),
      'member_sale': memberSale?.toJson(),
      'buy_packages': buyPackages?.map((e) => e.toJson()).toList(),
    };
  }
}


class MemberSaleModel {
  final String? id;
  final String? customerId;
  final String? username;
  final String? totalMember;
  final String? activeTotalMember;
  final String? directMember;
  final String? activeDirectMember;
  final String? selfSale;
  final String? teamSale;
  final String? directSale;
  final String? incomeDirect;
  final String? incomeRank;
  final String? incomeFct;
  final String? incomeFctReferral;
  final String? incomeMtp;
  final String? incomeSip;
  final String? incomeLevel;
  final String? incomeTotal;
  final String? balCommission;
  final String? balTransaction;
  final String? createdAt;
  final String? updatedAt;

  MemberSaleModel({
    this.id,
    this.customerId,
    this.username,
    this.totalMember,
    this.activeTotalMember,
    this.directMember,
    this.activeDirectMember,
    this.selfSale,
    this.teamSale,
    this.directSale,
    this.incomeDirect,
    this.incomeRank,
    this.incomeFct,
    this.incomeFctReferral,
    this.incomeMtp,
    this.incomeSip,
    this.incomeLevel,
    this.incomeTotal,
    this.balCommission,
    this.balTransaction,
    this.createdAt,
    this.updatedAt,
  });

  factory MemberSaleModel.fromJson(Map<String, dynamic> json) {
    return MemberSaleModel(
      id: json['id'],
      customerId: json['customer_id'],
      username: json['username'],
      totalMember: json['total_member'],
      activeTotalMember: json['active_total_member'],
      directMember: json['direct_member'],
      activeDirectMember: json['active_direct_member'],
      selfSale: json['self_sale'],
      teamSale: json['team_sale'],
      directSale: json['direct_sale'],
      incomeDirect: json['income_direct'],
      incomeRank: json['income_rank'],
      incomeFct: json['income_fct'],
      incomeFctReferral: json['income_fct_referral'],
      incomeMtp: json['income_mtp'],
      incomeSip: json['income_sip'],
      incomeLevel: json['income_level'],
      incomeTotal: json['income_total'],
      balCommission: json['bal_commission'],
      balTransaction: json['bal_transaction'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customer_id': customerId,
    'username': username,
    'total_member': totalMember,
    'active_total_member': activeTotalMember,
    'direct_member': directMember,
    'active_direct_member': activeDirectMember,
    'self_sale': selfSale,
    'team_sale': teamSale,
    'direct_sale': directSale,
    'income_direct': incomeDirect,
    'income_rank': incomeRank,
    'income_fct': incomeFct,
    'income_fct_referral': incomeFctReferral,
    'income_mtp': incomeMtp,
    'income_sip': incomeSip,
    'income_level': incomeLevel,
    'income_total': incomeTotal,
    'bal_commission': balCommission,
    'bal_transaction': balTransaction,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}



///----------Buy Packages
class BuyPackageModel {
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

  BuyPackageModel({
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
  });

  factory BuyPackageModel.fromJson(Map<String, dynamic> json) {
    return BuyPackageModel(
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
    );
  }

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
  };
}
