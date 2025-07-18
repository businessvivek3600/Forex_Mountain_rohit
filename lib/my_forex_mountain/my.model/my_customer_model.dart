class MyCustomerModel {
  final String id;
  final String customerId;
  final String username;
  final String? directSponserUsername;
  final String dposition;
  final String? sponserUsername;
  final String position;
  final String salesActive;
  final String salesActiveDate;
  final String createdAt;
  final String customerName;
  final String firstName;
  final String lastName;
  final String fatherName;
  final String customerShortAddress;
  final String customerAddress1;
  final String customerAddress2;
  final String city;
  final String state;
  final String country;
  final String countryText;
  final String zip;
  final String countryCode;
  final String customerMobile;
  final String? forgetOtp;
  final String customerEmail;
  final String? oldEmail;
  final String? cemailMOtp;
  final String? cemailMOtpTime;
  final String? image;
  final String password;
  final String step;
  final String company;
  final String gender;
  final String dateOfBirth;
  final String? directSponserName;
  final String? sponserName;
  final String block;
  final String blockNote;
  final String verifyEmail;
  final String? verifyEmailNote;
  final String? emailVerificationCode;
  final String verifyEmailC;
  final String? emailVerificationCodeC;
  final String emailReset;
  final String emailResetCode;
  final String kyc;
  final String? kycNote;
  final String kycDocType;
  final String kycDocNo;
  final String? kycUpdated;
  final String? withdrawEOtp;
  final String? withdrawEOtpTime;
  final String? bankEOtp;
  final String? bankEOtpTime;
  final String authReset;
  final String? authResetCode;
  final String isIsAuth;
  final String? isIsAuthNote;
  final String isAuth;
  final String? googleAuthCode;
  final String isLogin;
  final String isAppLogin;
  final String? deviceId;
  final String loginIpAddress;
  final String loginTime;
  final String logoutTime;
  final String appLoginTime;
  final String appLogoutTime;
  final String appLoginAttempt;
  final String loginAttempt;
  final String loginToken;
  final String isDisabled;
  final String? disabledTime;
  final String wdCommission;
  final String trCommission;
  final String wdTrading;
  final String trTrading;
  final String updatedAt;
  final String fctMaster;
  final String? fctMasterId;
  final String fctMP;
  final String fctMasterUpdated;

  const MyCustomerModel({
    required this.id,
    required this.customerId,
    required this.username,
    required this.directSponserUsername,
    required this.dposition,
    required this.sponserUsername,
    required this.position,
    required this.salesActive,
    required this.salesActiveDate,
    required this.createdAt,
    required this.customerName,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.customerShortAddress,
    required this.customerAddress1,
    required this.customerAddress2,
    required this.city,
    required this.state,
    required this.country,
    required this.countryText,
    required this.zip,
    required this.countryCode,
    required this.customerMobile,
    required this.forgetOtp,
    required this.customerEmail,
    required this.oldEmail,
    required this.cemailMOtp,
    required this.cemailMOtpTime,
    required this.image,
    required this.password,
    required this.step,
    required this.company,
    required this.gender,
    required this.dateOfBirth,
    required this.directSponserName,
    required this.sponserName,
    required this.block,
    required this.blockNote,
    required this.verifyEmail,
    required this.verifyEmailNote,
    required this.emailVerificationCode,
    required this.verifyEmailC,
    required this.emailVerificationCodeC,
    required this.emailReset,
    required this.emailResetCode,
    required this.kyc,
    required this.kycNote,
    required this.kycDocType,
    required this.kycDocNo,
    required this.kycUpdated,
    required this.withdrawEOtp,
    required this.withdrawEOtpTime,
    required this.bankEOtp,
    required this.bankEOtpTime,
    required this.authReset,
    required this.authResetCode,
    required this.isIsAuth,
    required this.isIsAuthNote,
    required this.isAuth,
    required this.googleAuthCode,
    required this.isLogin,
    required this.isAppLogin,
    required this.deviceId,
    required this.loginIpAddress,
    required this.loginTime,
    required this.logoutTime,
    required this.appLoginTime,
    required this.appLogoutTime,
    required this.appLoginAttempt,
    required this.loginAttempt,
    required this.loginToken,
    required this.isDisabled,
    required this.disabledTime,
    required this.wdCommission,
    required this.trCommission,
    required this.wdTrading,
    required this.trTrading,
    required this.updatedAt,
    required this.fctMaster,
    required this.fctMasterId,
    required this.fctMP,
    required this.fctMasterUpdated,
  });

  factory MyCustomerModel.fromJson(Map<String, dynamic> json) {
    return MyCustomerModel(
      id: json['id'] ?? '',
      customerId: json['customer_id'] ?? '',
      username: json['username'] ?? '',
      directSponserUsername: json['direct_sponser_username'],
      dposition: json['dposition'] ?? '',
      sponserUsername: json['sponser_username'],
      position: json['position'] ?? '',
      salesActive: json['sales_active'] ?? '',
      salesActiveDate: json['sales_active_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      customerName: json['customer_name'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      customerShortAddress: json['customer_short_address'] ?? '',
      customerAddress1: json['customer_address_1'] ?? '',
      customerAddress2: json['customer_address_2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      countryText: json['country_text'] ?? '',
      zip: json['zip'] ?? '',
      countryCode: json['country_code'] ?? '',
      customerMobile: json['customer_mobile'] ?? '',
      forgetOtp: json['forget_otp'],
      customerEmail: json['customer_email'] ?? '',
      oldEmail: json['old_email'],
      cemailMOtp: json['cemail_m_otp'],
      cemailMOtpTime: json['cemail_m_otp_time'],
      image: json['image'],
      password: json['password'] ?? '',
      step: json['step'] ?? '',
      company: json['company'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      directSponserName: json['direct_sponser_name'],
      sponserName: json['sponser_name'],
      block: json['block'] ?? '',
      blockNote: json['block_note'] ?? '',
      verifyEmail: json['verify_email'] ?? '',
      verifyEmailNote: json['verify_email_note'],
      emailVerificationCode: json['email_verification_code'],
      verifyEmailC: json['verify_email_c'] ?? '',
      emailVerificationCodeC: json['email_verification_code_c'],
      emailReset: json['email_reset'] ?? '',
      emailResetCode: json['email_reset_code'] ?? '',
      kyc: json['kyc'] ?? '',
      kycNote: json['kyc_note'],
      kycDocType: json['kyc_doc_type'] ?? '',
      kycDocNo: json['kyc_doc_no'] ?? '',
      kycUpdated: json['kyc_updated'],
      withdrawEOtp: json['withdraw_e_otp'],
      withdrawEOtpTime: json['withdraw_e_otp_time'],
      bankEOtp: json['bank_e_otp'],
      bankEOtpTime: json['bank_e_otp_time'],
      authReset: json['auth_reset'] ?? '',
      authResetCode: json['auth_reset_code'],
      isIsAuth: json['is_is_auth'] ?? '',
      isIsAuthNote: json['is_is_auth_note'],
      isAuth: json['is_auth'] ?? '',
      googleAuthCode: json['google_auth_code'],
      isLogin: json['is_login'] ?? '',
      isAppLogin: json['is_app_login'] ?? '',
      deviceId: json['device_id'],
      loginIpAddress: json['login_ip_address'] ?? '',
      loginTime: json['login_time'] ?? '',
      logoutTime: json['logout_time'] ?? '',
      appLoginTime: json['app_login_time'] ?? '',
      appLogoutTime: json['app_logout_time'] ?? '',
      appLoginAttempt: json['app_login_attempt'] ?? '',
      loginAttempt: json['login_attempt'] ?? '',
      loginToken: json['login_token'] ?? '',
      isDisabled: json['is_disabled'] ?? '',
      disabledTime: json['disabled_time'],
      wdCommission: json['wd_commission'] ?? '',
      trCommission: json['tr_commission'] ?? '',
      wdTrading: json['wd_trading'] ?? '',
      trTrading: json['tr_trading'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      fctMaster: json['fct_master'] ?? '',
      fctMasterId: json['fct_master_id'],
      fctMP: json['fct_m_p'] ?? '',
      fctMasterUpdated: json['fct_master_updated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'username': username,
      'direct_sponser_username': directSponserUsername,
      'dposition': dposition,
      'sponser_username': sponserUsername,
      'position': position,
      'sales_active': salesActive,
      'sales_active_date': salesActiveDate,
      'created_at': createdAt,
      'customer_name': customerName,
      'first_name': firstName,
      'last_name': lastName,
      'father_name': fatherName,
      'customer_short_address': customerShortAddress,
      'customer_address_1': customerAddress1,
      'customer_address_2': customerAddress2,
      'city': city,
      'state': state,
      'country': country,
      'country_text': countryText,
      'zip': zip,
      'country_code': countryCode,
      'customer_mobile': customerMobile,
      'forget_otp': forgetOtp,
      'customer_email': customerEmail,
      'old_email': oldEmail,
      'cemail_m_otp': cemailMOtp,
      'cemail_m_otp_time': cemailMOtpTime,
      'image': image,
      'password': password,
      'step': step,
      'company': company,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'direct_sponser_name': directSponserName,
      'sponser_name': sponserName,
      'block': block,
      'block_note': blockNote,
      'verify_email': verifyEmail,
      'verify_email_note': verifyEmailNote,
      'email_verification_code': emailVerificationCode,
      'verify_email_c': verifyEmailC,
      'email_verification_code_c': emailVerificationCodeC,
      'email_reset': emailReset,
      'email_reset_code': emailResetCode,
      'kyc': kyc,
      'kyc_note': kycNote,
      'kyc_doc_type': kycDocType,
      'kyc_doc_no': kycDocNo,
      'kyc_updated': kycUpdated,
      'withdraw_e_otp': withdrawEOtp,
      'withdraw_e_otp_time': withdrawEOtpTime,
      'bank_e_otp': bankEOtp,
      'bank_e_otp_time': bankEOtpTime,
      'auth_reset': authReset,
      'auth_reset_code': authResetCode,
      'is_is_auth': isIsAuth,
      'is_is_auth_note': isIsAuthNote,
      'is_auth': isAuth,
      'google_auth_code': googleAuthCode,
      'is_login': isLogin,
      'is_app_login': isAppLogin,
      'device_id': deviceId,
      'login_ip_address': loginIpAddress,
      'login_time': loginTime,
      'logout_time': logoutTime,
      'app_login_time': appLoginTime,
      'app_logout_time': appLogoutTime,
      'app_login_attempt': appLoginAttempt,
      'login_attempt': loginAttempt,
      'login_token': loginToken,
      'is_disabled': isDisabled,
      'disabled_time': disabledTime,
      'wd_commission': wdCommission,
      'tr_commission': trCommission,
      'wd_trading': wdTrading,
      'tr_trading': trTrading,
      'updated_at': updatedAt,
      'fct_master': fctMaster,
      'fct_master_id': fctMasterId,
      'fct_m_p': fctMP,
      'fct_master_updated': fctMasterUpdated,
    };
  }
}

