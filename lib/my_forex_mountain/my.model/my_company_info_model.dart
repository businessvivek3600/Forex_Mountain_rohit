class MyCompanyInfo {
  final String? companyId;
  final String? companyName;
  final String? email;
  final String? address;
  final String? mobile;
  final String? website;
  final String? businessPlan;
  final String? embedPopup;
  final String? embedContent;
  final String? username;
  final String? isLogin;
  final String? isSignup;
  final String? isBuyPack;
  final String? isStakingProfit;
  final String? aMinimumWithdraw;
  final String? aMinimumTransfer;
  final String? tradingDay;
  final String? tradingOff;
  final String? wTrading;
  final String? wCommission;
  final String? tTrading;
  final String? tCommission;
  final String? minimumWithdraw;
  final String? minimumTransfer;
  final String? adminCharge;
  final String? transferCharge;
  final String? popupImg;
  final String? popupImage;
  final String? chatDisabled;
  final String? coin1InUsd;
  final String? runCronSale;
  final String? runCronClient;
  final String? runCronFctReturn;
  final String? tTransaction;
  final String? isFct;
  final String? isMtp;
  final String? isSip;
  final String? bank;
  final String? accountNo;
  final String? bankCode;
  final String? upiId;
  final String? usdt;
  final String? usdtImage;

  MyCompanyInfo({
    this.companyId,
    this.companyName,
    this.email,
    this.address,
    this.mobile,
    this.website,
    this.businessPlan,
    this.embedPopup,
    this.embedContent,
    this.username,
    this.isLogin,
    this.isSignup,
    this.isBuyPack,
    this.isStakingProfit,
    this.aMinimumWithdraw,
    this.aMinimumTransfer,
    this.tradingDay,
    this.tradingOff,
    this.wTrading,
    this.wCommission,
    this.tTrading,
    this.tCommission,
    this.minimumWithdraw,
    this.minimumTransfer,
    this.adminCharge,
    this.transferCharge,
    this.popupImg,
    this.popupImage,
    this.chatDisabled,
    this.coin1InUsd,
    this.runCronSale,
    this.runCronClient,
    this.runCronFctReturn,
    this.tTransaction,
    this.isFct,
    this.isMtp,
    this.isSip,
    this.bank,
    this.accountNo,
    this.bankCode,
    this.upiId,
    this.usdt,
    this.usdtImage,
  });

  factory MyCompanyInfo.fromJson(Map<String, dynamic> json) {
    return MyCompanyInfo(
      companyId: json['company_id'],
      companyName: json['company_name'],
      email: json['email'],
      address: json['address'],
      mobile: json['mobile'],
      website: json['website'],
      businessPlan: json['business_plan'],
      embedPopup: json['embed_popup'],
      embedContent: json['embed_content'],
      username: json['username'],
      isLogin: json['is_login'],
      isSignup: json['is_signup'],
      isBuyPack: json['is_buy_pack'],
      isStakingProfit: json['is_staking_profit'],
      aMinimumWithdraw: json['a_minimum_withdraw'],
      aMinimumTransfer: json['a_minimum_transfer'],
      tradingDay: json['trading_day'],
      tradingOff: json['trading_off'],
      wTrading: json['w_trading'],
      wCommission: json['w_commission'],
      tTrading: json['t_trading'],
      tCommission: json['t_commission'],
      minimumWithdraw: json['minimum_withdraw'],
      minimumTransfer: json['minimum_transfer'],
      adminCharge: json['admin_charge'],
      transferCharge: json['transfer_charge'],
      popupImg: json['popup_img'],
      popupImage: json['popup_image'],
      chatDisabled: json['chat_disabled'],
      coin1InUsd: json['coin_1_in_usd'],
      runCronSale: json['run_cron_sale'],
      runCronClient: json['run_cron_client'],
      runCronFctReturn: json['run_cron_fct_return'],
      tTransaction: json['t_transaction'],
      isFct: json['is_fct'],
      isMtp: json['is_mtp'],
      isSip: json['is_sip'],
      bank: json['bank'],
      accountNo: json['account_no'],
      bankCode: json['bank_code'],
      upiId: json['upi_id'],
      usdt: json['usdt'],
      usdtImage: json['usdt_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'company_name': companyName,
      'email': email,
      'address': address,
      'mobile': mobile,
      'website': website,
      'business_plan': businessPlan,
      'embed_popup': embedPopup,
      'embed_content': embedContent,
      'username': username,
      'is_login': isLogin,
      'is_signup': isSignup,
      'is_buy_pack': isBuyPack,
      'is_staking_profit': isStakingProfit,
      'a_minimum_withdraw': aMinimumWithdraw,
      'a_minimum_transfer': aMinimumTransfer,
      'trading_day': tradingDay,
      'trading_off': tradingOff,
      'w_trading': wTrading,
      'w_commission': wCommission,
      't_trading': tTrading,
      't_commission': tCommission,
      'minimum_withdraw': minimumWithdraw,
      'minimum_transfer': minimumTransfer,
      'admin_charge': adminCharge,
      'transfer_charge': transferCharge,
      'popup_img': popupImg,
      'popup_image': popupImage,
      'chat_disabled': chatDisabled,
      'coin_1_in_usd': coin1InUsd,
      'run_cron_sale': runCronSale,
      'run_cron_client': runCronClient,
      'run_cron_fct_return': runCronFctReturn,
      't_transaction': tTransaction,
      'is_fct': isFct,
      'is_mtp': isMtp,
      'is_sip': isSip,
      'bank': bank,
      'account_no': accountNo,
      'bank_code': bankCode,
      'upi_id': upiId,
      'usdt': usdt,
      'usdt_image': usdtImage,
    };
  }
}
