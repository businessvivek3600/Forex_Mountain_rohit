import 'dart:convert';

import '/utils/default_logger.dart';

class CompanyInfoModel {
  String? companyId;
  String? companyName;
  String? email;
  String? address;
  String? mobile;
  String? website;
  String? businessPlan;
  String? pdf;
  String? ppt;
  String? video;
  String? username;
  String? news;
  String? btcAdminPer;
  String? cUsdttAdminPer;
  String? cUsdtbAdminPer;
  String? cBankAdminPer;
  String? cMinimumWithdraw;
  String? cMinimumTransfer;
  String? cTransactionPer;
  String? ngCMinimumTransfer;
  String? ngCTransactionPer;
  String? wCommission;
  String? tCommission;
  String? tCash;
  String? fCWCoinpayment;
  String? fCWCard;
  String? fCWNgcash;
  String? euroToUsdt;
  String? usdToEuro;
  String? popupImg;
  List<Map<String, dynamic>>? popupImage;
  String? runCronVal;
  String? runCronDeactiveClient;
  String? autoDeductAmgn;
  String? status;
  String? webIsLogin;
  String? webIsSignup;
  String? webIsSubscription;
  String? webIsCashWallet;
  String? webIsCommissionWallet;
  String? webIsVoucher;
  String? webIsEvent;
  String? webChatDisabled;
  String? mobileIsLogin;
  String? mobileIsSignup;
  String? mobileIsSubscription;
  String? mobileIsCashWallet;
  String? mobileIsCommissionWallet;
  String? mobileIsVoucher;
  String? mobileIsEvent;
  String? mobileChatDisabled;
  String? mobileAppDisabled;
  String? android_version;
  String? ios_version;
  String? test_android;
  String? test_ios;
  String? popup_url;

  CompanyInfoModel({
    this.companyId,
    this.companyName,
    this.email,
    this.address,
    this.mobile,
    this.website,
    this.businessPlan,
    this.pdf,
    this.ppt,
    this.video,
    this.username,
    this.news,
    this.btcAdminPer,
    this.cUsdttAdminPer,
    this.cUsdtbAdminPer,
    this.cBankAdminPer,
    this.cMinimumWithdraw,
    this.cMinimumTransfer,
    this.cTransactionPer,
    this.ngCMinimumTransfer,
    this.ngCTransactionPer,
    this.wCommission,
    this.tCommission,
    this.tCash,
    this.fCWCoinpayment,
    this.fCWCard,
    this.fCWNgcash,
    this.euroToUsdt,
    this.usdToEuro,
    this.popupImg,
    this.popupImage,
    this.runCronVal,
    this.runCronDeactiveClient,
    this.autoDeductAmgn,
    this.status,
    this.webIsLogin,
    this.webIsSignup,
    this.webIsSubscription,
    this.webIsCashWallet,
    this.webIsCommissionWallet,
    this.webIsVoucher,
    this.webIsEvent,
    this.webChatDisabled,
    this.mobileIsLogin,
    this.mobileIsSignup,
    this.mobileIsSubscription,
    this.mobileIsCashWallet,
    this.mobileIsCommissionWallet,
    this.mobileIsVoucher,
    this.mobileIsEvent,
    this.mobileChatDisabled,
    this.mobileAppDisabled,
    this.android_version,
    this.ios_version,
    this.test_android,
    this.test_ios,
    this.popup_url,
  });

  CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    companyName = json['company_name'];
    email = json['email'];
    address = json['address'];
    mobile = json['mobile'];
    website = json['website'];
    businessPlan = json['business_plan'];
    pdf = json['pdf'];
    ppt = json['ppt'];
    video = json['video'];
    username = json['username'];
    news = json['news'];
    btcAdminPer = json['btc_admin_per'];
    cUsdttAdminPer = json['c_usdtt_admin_per'];
    cUsdtbAdminPer = json['c_usdtb_admin_per'];
    cBankAdminPer = json['c_bank_admin_per'];
    cMinimumWithdraw = json['c_minimum_withdraw'];
    cMinimumTransfer = json['c_minimum_transfer'];
    cTransactionPer = json['c_transaction_per'];
    ngCMinimumTransfer = json['ng_c_minimum_transfer'];
    ngCTransactionPer = json['ng_c_transaction_per'];
    wCommission = json['w_commission'];
    tCommission = json['t_commission'];
    tCash = json['t_cash'];
    fCWCoinpayment = json['f_c_w_coinpayment'];
    fCWCard = json['f_c_w_card'];
    fCWNgcash = json['f_c_w_ngcash'];
    euroToUsdt = json['euro_to_usdt'];
    usdToEuro = json['usd_to_euro'];
    popupImg = json['popup_img'];
    try {
      if (json['popup_image'] != null) {
        var data = json['popup_image'];

        if (data is String) {
          popupImage = [
            {
              "file_name": data,
            }
          ];
        } else {
          List<Map<String, dynamic>> popup = [];
          jsonDecode(json['popup_image']).forEach((e) {
            // infoLog('CompanyInfoModel.fromJson  popup-img $e');
            popup.add(e);
          });
          popupImage = popup;
        }
      }
    } catch (e) {
      errorLog('CompanyInfoModel.fromJson $e');
    }
    runCronVal = json['run_cron_val'];
    runCronDeactiveClient = json['run_cron_deactive_client'];
    autoDeductAmgn = json['auto_deduct_amgn'];
    status = json['status'];
    webIsLogin = json['web_is_login'];
    webIsSignup = json['web_is_signup'];
    webIsSubscription = json['web_is_subscription'];
    webIsCashWallet = json['web_is_cash_wallet'];
    webIsCommissionWallet = json['web_is_commission_wallet'];
    webIsVoucher = json['web_is_voucher'];
    webIsEvent = json['web_is_event'];
    webChatDisabled = json['web_chat_disabled'];
    mobileIsLogin = json['mobile_is_login'];
    mobileIsSignup = json['mobile_is_signup'];
    mobileIsSubscription = json['mobile_is_subscription'];
    mobileIsCashWallet = json['mobile_is_cash_wallet'];
    mobileIsCommissionWallet = json['mobile_is_commission_wallet'];
    mobileIsVoucher = json['mobile_is_voucher'];
    mobileIsEvent = json['mobile_is_event'];
    mobileChatDisabled = json['mobile_chat_disabled'];
    mobileAppDisabled = json['mobile_app_disabled'];
    android_version = json['android_version'];
    ios_version = json['ios_version'];
    test_android = json['test_android'];
    test_ios = json['test_ios'];
    popup_url = json['popup_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['email'] = email;
    data['address'] = address;
    data['mobile'] = mobile;
    data['website'] = website;
    data['business_plan'] = businessPlan;
    data['pdf'] = pdf;
    data['ppt'] = ppt;
    data['video'] = video;
    data['username'] = username;
    data['news'] = news;
    data['btc_admin_per'] = btcAdminPer;
    data['c_usdtt_admin_per'] = cUsdttAdminPer;
    data['c_usdtb_admin_per'] = cUsdtbAdminPer;
    data['c_bank_admin_per'] = cBankAdminPer;
    data['c_minimum_withdraw'] = cMinimumWithdraw;
    data['c_minimum_transfer'] = cMinimumTransfer;
    data['c_transaction_per'] = cTransactionPer;
    data['ng_c_minimum_transfer'] = ngCMinimumTransfer;
    data['ng_c_transaction_per'] = ngCTransactionPer;
    data['w_commission'] = wCommission;
    data['t_commission'] = tCommission;
    data['t_cash'] = tCash;
    data['f_c_w_coinpayment'] = fCWCoinpayment;
    data['f_c_w_card'] = fCWCard;
    data['f_c_w_ngcash'] = fCWNgcash;
    data['euro_to_usdt'] = euroToUsdt;
    data['usd_to_euro'] = usdToEuro;
    data['popup_img'] = popupImg;
    data['popup_image'] = popupImage;
    data['run_cron_val'] = runCronVal;
    data['run_cron_deactive_client'] = runCronDeactiveClient;
    data['auto_deduct_amgn'] = autoDeductAmgn;
    data['status'] = status;
    data['web_is_login'] = webIsLogin;
    data['web_is_signup'] = webIsSignup;
    data['web_is_subscription'] = webIsSubscription;
    data['web_is_cash_wallet'] = webIsCashWallet;
    data['web_is_commission_wallet'] = webIsCommissionWallet;
    data['web_is_voucher'] = webIsVoucher;
    data['web_is_event'] = webIsEvent;
    data['web_chat_disabled'] = webChatDisabled;
    data['mobile_is_login'] = mobileIsLogin;
    data['mobile_is_signup'] = mobileIsSignup;
    data['mobile_is_subscription'] = mobileIsSubscription;
    data['mobile_is_cash_wallet'] = mobileIsCashWallet;
    data['mobile_is_commission_wallet'] = mobileIsCommissionWallet;
    data['mobile_is_voucher'] = mobileIsVoucher;
    data['mobile_is_event'] = mobileIsEvent;
    data['mobile_chat_disabled'] = mobileChatDisabled;
    data['mobile_app_disabled'] = mobileAppDisabled;
    data['android_version'] = android_version;
    data['ios_version'] = ios_version;
    data['test_android'] = test_android;
    data['test_ios'] = test_ios;
    data['popup_url'] = popup_url;
    return data;
  }
}
