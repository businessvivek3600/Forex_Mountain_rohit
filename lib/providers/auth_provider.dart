import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:forex_mountain/utils/my_logger.dart';
import '/utils/default_logger.dart';
import '/utils/sp_utils.dart';
import '/database/functions.dart';
import '/database/model/response/additional/signup_country_model.dart';
import '/database/model/response/base/user_model.dart';
import '/database/model/response/company_info_model.dart';
import '/database/model/response/states_model.dart';
import '/database/repositories/fcm_subscription_repo.dart';
import '/myapp.dart';
import '/providers/dashboard_provider.dart';
import '/screens/auth/login_screen.dart';
import '/sl_container.dart';
import '/utils/app_default_loading.dart';
import '/utils/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../database/model/body/login_model.dart';
import '../database/model/body/register_model.dart';
import '../database/model/response/additional/mcc_content_models.dart';
import '../database/model/response/base/api_response.dart';
import '../database/model/response/base/error_response.dart';
import '../database/repositories/auth_repo.dart';
import '../utils/api_checker.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepo authRepo;
  final FCMSubscriptionRepo fcmSubscriptionRepo;
  AuthProvider({required this.fcmSubscriptionRepo, required this.authRepo});

  UserData userData = UserData();
  CompanyInfoModel? companyInfo;
  MWC_Content mwc_content = MWC_Content();
  List<Cancellation> link_pages = [];
  String? default_referral_id;
  String? privacy;
  String? term;
  String userFrom = '';
  String? cancellation_policy;
  List<SignUpCountry> countriesList = [];
  List<String> restrictTexts = [];
  bool isLoading = false;
  bool _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  /// Holds the domain key-value pairs from the API (e.g., {"1": "Default", "2": "https://..."})
  Map<String, String> domainMap = {};

  /// Returns just the list of domain values for UI display
  List<String> get domainList => domainMap.values.toList();

  /// Holds the currently selected domain
  String? selectedDomain;

  /// Updates the selected domain
  void updateSelectedDomain(String value) {
    // Reverse lookup the key using the selected value
    selectedDomain = domainMap.entries
        .firstWhere((entry) => entry.value == value)
        .key;
    notifyListeners();
  }

  updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
  Future<void> loadUserData() async {
    userData = await authRepo.getUser() ?? UserData();


    notifyListeners();
  }

  bool get isRemember => _isRemember;

  void updateRemember(bool value) {
    _isRemember = value;
    notifyListeners();
  }
  String getUserFrom() {
    userFrom = authRepo.getUserFrom();
    notifyListeners();
    return userFrom;

  }
  Future registration(RegisterModel register) async {
    isLoading = true;
    notifyListeners();
    showLoading();
    ApiResponse apiResponse = await authRepo.registration(register);
    Get.back();
    isLoading = true;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      Map map = apiResponse.response?.data;
      bool status = false;
      String message = '';
      try {
        message = map["message"];
      } catch (e) {}
      try {
        status = map["status"];
      } catch (e) {}
      status
          ? Toasts.showSuccessNormalToast(message.split('.').first)
          : Toasts.showErrorNormalToast(message.split('.').first);
      if (status) {
        Future.delayed(const Duration(milliseconds: 2000),
            () => Get.offAll(const LoginScreen()));
      }
      notifyListeners();
    } else {
      if (apiResponse.error is String) {
        // print('string ' + apiResponse.error.toString());
      } else {}
      notifyListeners();
    }
  }

  Future updateProfile(Map<String, dynamic> data) async {
    isLoading = true;
    notifyListeners();
    if (isOnline) {
      showLoading();
      ApiResponse apiResponse = await authRepo.updateProfile(data);
      isLoading = true;
      notifyListeners();
      Get.back();
      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        Map map = apiResponse.response?.data;
        bool status = false;
        String message = '';
        try {
          message = map["message"];
        } catch (e) {}
        try {
          status = map["status"];
        } catch (e) {}
        try {
          var isLoggedIn = map["is_logged_in"];
          if (isLoggedIn == 0) {
            logOut('user data not found in updateProfile');
          }
        } catch (e) {}
        try {
          if (status) {
            // await userInfo();
          }
        } catch (e) {}
        status
            ? Toasts.showSuccessNormalToast(message.split('.').first)
            : Toasts.showErrorNormalToast(message.split('.').first);
        if (status) {
          await userInfo().then((value) => Future.delayed(
              const Duration(milliseconds: 1000), () => Get.back()));
        }
        notifyListeners();
      } else {
        String errorMessage;
        if (apiResponse.error is String) {
          // print('string ' + apiResponse.error.toString());
          errorMessage = apiResponse.error.toString();
        } else {
          ErrorResponse errorResponse = apiResponse.error;
          errorMessage = errorResponse.errors[0].message;
        }
        notifyListeners();
      }
    } else {
      Toasts.showWarningNormalToast('You are offline');
    }
  }

  Future<void> getSignUpInitialData() async {
    String? _default_referral_id;
    String? _privacy;
    String? logo;
    String? _term;
    String? _cancellation_policy;
    List<SignUpCountry> _countries = [];
    Map? map;
    bool isCacheExist =
        await APICacheManager().isAPICacheKeyExist(AppConstants.config);

    if (isOnline) {
      ApiResponse apiResponse = await authRepo.getSignUpInitialData();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        map = apiResponse.response!.data;
        // ✅ Debug: Print full response data

        if (map!['url_list'] != null) {
          domainMap = Map<String, String>.from(map['url_list']);
        }
        bool status = false;
        try {
          status = map["status"];
        } catch (e) {}
        try {
          if (status) {
            var cacheModel = APICacheDBModel(
                key: AppConstants.config, syncData: jsonEncode(map));
            await APICacheManager().addCacheData(cacheModel);
          }
        } catch (e) {
          print('getSignUpInitialData online hit could not be generated \n $e');
        }
      } else {
        String errorMessage = "";
        if (apiResponse.error is String) {
          print(apiResponse.error.toString());
          errorMessage = apiResponse.error.toString();
        } else {
          ErrorResponse errorResponse = apiResponse.error;
          print(
              'error message from countries ${errorResponse.errors[0].message}');
          errorMessage = errorResponse.errors[0].message;
        }
        notifyListeners();
      }
    } else if (!isOnline && isCacheExist) {
      try {
        bool isCacheExist =
            await APICacheManager().isAPICacheKeyExist(AppConstants.config);
        if (isCacheExist) {
          var data = (await APICacheManager().getCacheData(AppConstants.config))
              .syncData;
          map = jsonDecode(data);
          // print('getSignUpInitialData offline data ${map}');
        }
      } catch (e) {
        print('getSignUpInitialData cache hit failed!');
      }
    } else {
      print(
          'getSignUpInitialData1 some thing went wrong isCacheExist->$isCacheExist');
    }
    if (map != null) {
      try {
        if (map['company_info'] != null) {
          companyInfo = CompanyInfoModel.fromJson(map['company_info']);
        }
        notifyListeners();
      } catch (e) {
        print('company info error on getSignUpInitialData $e');
      }
      try {
        if (map['mwc_content'] != null && map['mwc_content'] != false) {
          mwc_content = MWC_Content.fromJson(map['mwc_content']);
        }
        notifyListeners();
      } catch (e) {
        print('mwc_content error on getSignUpInitialData $e');
      }
      try {
        if (map['link_pages'] != null && map['link_pages'] != false) {
          link_pages.clear();
          map['link_pages']
              .forEach((e) => link_pages.add(Cancellation.fromJson(e)));
        }

        notifyListeners();
      } catch (e) {
        errorLog(
            'link_pages error on getSignUpInitialData $e', 'Auth Provider');
      }
      try {
        if (map['countries'] != null && map['countries'].isNotEmpty) {
          map['countries']
              .forEach((e) => _countries.add(SignUpCountry.fromJson(e)));
        }
        _default_referral_id = map['referal_id'];
        _privacy = map['privacy'];
        logo = map['logo'];
        _term = map['term'];
        _cancellation_policy = map['cancellation_policy'];
        sl.get<DashBoardProvider>().platinumMemberImage =
            map['platinum_img_badge'];
        if (map['restrict_text'] != null && map['restrict_text'].isNotEmpty) {
          map['restrict_text'].forEach((e) => restrictTexts.add(e));
        }
        notifyListeners();
      } catch (e) {
        print('Get signup initial data error $e');
      }
    }
    default_referral_id = _default_referral_id;
    privacy = _privacy;
    term = _term;
    sl.get<DashBoardProvider>().logoUrl = logo;
    sl.get<DashBoardProvider>().companyInfo = companyInfo;
    cancellation_policy = _cancellation_policy;
    countriesList = _countries;
    notifyListeners();
  }



  Future<bool> login(LoginModel loginBody) async {
    bool loggedIn = false;

    if (isOnline) {
      showLoading(dismissable: false, useRootNavigator: true);
      log('loginBody ${loginBody.toJson()}');
      ApiResponse apiResponse = await authRepo.login(loginBody);

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        print("response ${apiResponse.response!.data}");
        Map map = apiResponse.response!.data;

        UserData? _userData;
        String? loginToken;
        String message = '';
        bool status = false;
        String _userFrom = '';

        try {
          status = map["status"];
          message = map["message"];
          loginToken = map["login_token"];
          _userFrom = map["user_from"];
        } catch (e) {}

        if (status) {
          try {
            _userData = UserData.fromJson(map['userData']);
            var cacheModel = APICacheDBModel(
                key: SPConstants.user, syncData: jsonEncode(map['userData']));
            await APICacheManager().addCacheData(cacheModel);

            await fcmSubscriptionRepo.subscribeToTopic(SPConstants.topic_all);
            await fcmSubscriptionRepo.subscribeToTopic(SPConstants.topic_forex);
            await fcmSubscriptionRepo.subscribeToTopic(SPConstants.topic_event);

            if (status && loginToken != null && loginToken.isNotEmpty) {
              authRepo.saveUserToken(loginToken);
              authRepo.saveUser(_userData);

              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.setString(SPConstants.userFrom, _userFrom);
              authRepo.saveUserFrom(_userFrom);
              // Verify if userFrom was saved successfully
              if (preferences.containsKey(SPConstants.userFrom)) {
                print('userFrom is saved in SharedPreferences');
                String? userFromValue = preferences.getString(SPConstants.userFrom);
                print('Saved userFrom value: $userFromValue');
              } else {
                print('userFrom is not saved in SharedPreferences');
              }
            }
          } catch (e) {
            print('User could not be generated ${_userData?.toJson()} \n $e');
          }
        }

        Get.back();
        print('login response $map status $status');
        if (!status) {
          Fluttertoast.showToast(msg: message, backgroundColor: Colors.red);
        }
        loggedIn = status;
      } else {
        if (apiResponse.error is String) {
          logger.e(apiResponse.error.toString(),
              tag: 'login', error: apiResponse.error);
        } else {
          ErrorResponse errorResponse = apiResponse.error;
          logger.e(' ${errorResponse.errors[0].message}',
              tag: 'login', error: errorResponse.errors);
        }
        Toasts.showErrorNormalToast('Something went wrong!');
      }
    } else {
      Toasts.showWarningNormalToast('You are offline');
    }
    return loggedIn;
  }


  bool loadingStates = false;
  List<States> states = [];
  Future<void> getStates(String countryId) async {
    bool cacheExist =
        await APICacheManager().isAPICacheKeyExist(AppConstants.getStates);
    loadingStates = true;
    Map? map;

    notifyListeners();
    if (isOnline) {
      ApiResponse apiResponse =
          await authRepo.getStates({'country_id': countryId});
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        bool status = false;
        map = apiResponse.response!.data;
        try {
          status = map!["status"];
        } catch (e) {}
        try {
          if (status) {
            var cacheModel = await APICacheDBModel(
                key: AppConstants.getStates, syncData: jsonEncode(map));
            await APICacheManager().addCacheData(cacheModel);
                    }
        } catch (e) {
          print('states could not be generated  $e');
        }
      }
    } else if (!isOnline && cacheExist) {
      var data = (await APICacheManager().getCacheData(AppConstants.getStates))
          .syncData;
      try {
        map = jsonDecode(data);
      } catch (e) {}
    } else {
      Toasts.showWarningNormalToast('You are offline');
    }
    try {
      if (map != null) {
        if (map['states'] != null && map['states'].isNotEmpty) {
          states.clear();
          map['states'].forEach((e) => states.add(States.fromJson(e)));
        }
      } else {
        Toasts.showErrorNormalToast('States not found!');
      }
    } catch (e) {}
    loadingStates = false;
    notifyListeners();
  }

  Future<UserData?> userInfo() async {
    bool isCacheExist =
        await APICacheManager().isAPICacheKeyExist(SPConstants.user);
    UserData? _userData;
    String? loginToken;

    print('user data exist userInfo $isCacheExist ');
    if (!isCacheExist) {
      print('user data not exist ');
      Get.offAll(const LoginScreen());
      return _userData;
    } else if (isOnline) {
      ApiResponse apiResponse = await authRepo.userInfo();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        Map map = apiResponse.response!.data;
        bool status = false;
        try {
          status = map["status"];
        } catch (e) {}
        try {
          loginToken = map["login_token"];
        } catch (e) {}
        if (map['userData'] == null) {
          logOut('user data not found in userInfo');
          return null;
        }
        try {
          _userData = UserData.fromJson(map['userData']);
          var cacheModel = APICacheDBModel(
              key: SPConstants.user, syncData: jsonEncode(map['userData']));
          await APICacheManager().addCacheData(cacheModel);
          userData = _userData;
        } catch (e) {
          // print('user could not be generated ${_userData?.toJson()} \n $e');
        }
        if (status && loginToken != null && loginToken.isNotEmpty) {
          authRepo.saveUserToken(loginToken);
          authRepo.saveUser(userData);
        }
        notifyListeners();
        return Future.delayed(
            const Duration(milliseconds: 2000), () => _userData);
      } else {
        String errorMessage = "";
        if (apiResponse.error is String) {
          print(apiResponse.error.toString());
          errorMessage = apiResponse.error.toString();
        } else {
          ErrorResponse errorResponse = apiResponse.error;
          print('error message from login ${errorResponse.errors[0].message}');
          errorMessage = errorResponse.errors[0].message;
        }
        Toasts.showErrorNormalToast('Some thing went wrong!');
        notifyListeners();
        return _userData;
      }
    } else {
      print('userinfo cache hit');
      try {
        var cacheModel =
            (await APICacheManager().getCacheData(SPConstants.user)).syncData;
        // print('cacheModel -> ${jsonDecode(cacheModel)}');
        _userData = UserData.fromJson(jsonDecode(cacheModel));
        userData = _userData;
        loginToken = (await SharedPreferences.getInstance())
            .getString(SPConstants.userToken);
        authRepo.saveUserToken(loginToken!);
        authRepo.saveUser(userData);
      } catch (e) {
        // print('user could not be generated ${_userData?.toJson()} \n $e');
      }
    }
    return _userData;
  }

  //commission withdrawal
  String bankdetail_id = '';
  String usdtt_address = '';
  String usdtb_address = '';
  String account_holder_name = '';
  String account_number = '';
  String ifsc_code = '';
  String bank = '';
  String address = '';
  bool loadingCommissionWithdrawal = false;
  Future<void> commissionWithdrawal() async {
    loadingCommissionWithdrawal = true;
    notifyListeners();
    bool isCacheExist =
        await APICacheManager().isAPICacheKeyExist(AppConstants.paymentMethod);
    Map? map;

    if (isOnline) {
      ApiResponse apiResponse = await authRepo.commissionWithdrawal();
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        map = apiResponse.response!.data;
        try {
          if (map!['is_logged_in'] != 1) {
            logOut('commissionWithdrawal');
          }
        } catch (e) {}
        try {
          var cacheModel = APICacheDBModel(
              key: AppConstants.paymentMethod, syncData: jsonEncode(map));
          await APICacheManager().addCacheData(cacheModel);
                } catch (e) {}
      } else {
        String errorMessage = "";
        print(apiResponse.error.toString());
        if (apiResponse.error is String) {
          errorMessage = apiResponse.error.toString();
        } else {
          ErrorResponse errorResponse = apiResponse.error;
          errorMessage = errorResponse.errors[0].message;
        }
        Toasts.showErrorNormalToast('Some thing went wrong!');
      }
    } else if (!isOnline && isCacheExist) {
      try {
        var cacheModel =
            (await APICacheManager().getCacheData(AppConstants.paymentMethod))
                .syncData;
        map = jsonDecode(cacheModel);
      } catch (e) {}
    } else {
      print('commissionWithdrawal error  ');
    }
    try {
      if (map != null) {
        bankdetail_id = map['bankdetail_id'] ?? '';
        usdtt_address = map['usdtt_address'] ?? '';
        usdtb_address = map['usdtb_address'] ?? '';
        account_holder_name = map['account_holder_name'] ?? '';
        account_number = map['account_number'] ?? '';
        ifsc_code = map['ifsc_code'] ?? '';
        bank = map['bank'] ?? '';
        address = map['address'] ?? '';
        notifyListeners();
      }
    } catch (e) {}
    loadingCommissionWithdrawal = false;
    notifyListeners();
  }

  Future<UserData?> updateUser(Map<String, dynamic> data) async {
    UserData? _userData;
    // print(data);
    try {
      if (data['username'] == null) {
        logOut('user data not found in updateUser');
        return null;
      }
      _userData = UserData.fromJson(data);
      var cacheModel =
          APICacheDBModel(key: SPConstants.user, syncData: jsonEncode(data));
      await APICacheManager().addCacheData(cacheModel);
      userData = _userData;
      notifyListeners();
    } catch (e) {
      // print(
      //     'updateUser user could not be generated ${_userData?.toJson()} \n $e');
    }
    return _userData;
  }

  Future authToken(String authToken) async {
    await authRepo.saveUserToken(authToken);
    notifyListeners();
  }

  Future<void> updateToken(BuildContext context) async {
    ApiResponse apiResponse = await authRepo.updateToken();
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  //forgot password -verification
  bool otpSent = false;
  setOtpSent(bool val) {
    otpSent = val;
    notifyListeners();
  }

  Future<bool> getForgotPassEmailOtp(String text) async {
    bool status = false;
    try {
      if (isOnline) {
        showLoading();
        late ApiResponse apiResponse;
        try {
          apiResponse = await authRepo.getForgotPassEmailOtp({'email': text});
        } catch (e) {}
        Get.back();
        if (apiResponse.response != null &&
            apiResponse.response!.statusCode == 200) {
          Map map = apiResponse.response!.data;
          String message = '';
          try {
            status = map["status"];
            if (map['is_logged_in'] == 0) {}
          } catch (e) {}
          try {
            message = map["message"];
          } catch (e) {}
          // Toasts.showNormalToast(message.split('.').first, error: !status);
          status
              ? Toasts.showSuccessNormalToast(message.split('.').first)
              : Toasts.showErrorNormalToast(message.split('.').first);
        } else {
          Toasts.showErrorNormalToast('Some thing went wrong!');
        }
      } else {
        Toasts.showWarningNormalToast('You are offline');
      }
    } catch (e) {
      print('withdrawSubmit failed ${e}');
    }
    return status;
  }

  Future<bool> forgetPasswordSubmit({
    required String email,
    required String otp,
    required String newPass,
    required String confirmPass,
  }) async {
    bool status = false;
    try {
      if (isOnline) {
        showLoading();
        late ApiResponse apiResponse;
        try {
          apiResponse = await authRepo.forgetPasswordSubmit({
            'email': email,
            'otp': otp,
            'password': newPass,
            'confirm_password': confirmPass
          });
        } catch (e) {}
        Get.back();
        if (apiResponse.response != null &&
            apiResponse.response!.statusCode == 200) {
          Map map = apiResponse.response!.data;
          String message = '';
          try {
            status = map["status"];
            if (map['is_logged_in'] == 0) {}
          } catch (e) {}
          try {
            message = map["message"];
          } catch (e) {}
          // Toasts.showNormalToast(message.split('.').first, error: !status);

          status
              ? Toasts.showSuccessNormalToast(message.split('.').first)
              : Toasts.showErrorNormalToast(message.split('.').first);
          if (status) {
            Future.delayed(
                const Duration(milliseconds: 1000),
                () => ForexMountains.navigatorKey.currentState
                    ?.pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (route) => false));
          }
        }
      } else {
        Toasts.showWarningNormalToast('You are offline');
      }
    } catch (e) {
      print('withdrawSubmit failed ${e}');
    }
    return status;
  }

  //commission withdrawals email-verification
  Future<void> getCommissionWithdrawalsEmailOtp() async {
    try {
      if (isOnline) {
        showLoading();
        late ApiResponse apiResponse;
        try {
          apiResponse = await authRepo.getCommissionWithdrawalsEmailOtp();
        } catch (e) {}
        Get.back();
        if (apiResponse.response != null &&
            apiResponse.response!.statusCode == 200) {
          Map map = apiResponse.response!.data;
          bool status = false;
          String message = '';
          try {
            status = map["status"];
            if (map['is_logged_in'] == 0) {}
          } catch (e) {}
          try {
            message = map["message"];
          } catch (e) {}
          // Toasts.showNormalToast(message.split('.').first, error: !status);

          status
              ? Toasts.showSuccessNormalToast(message.split('.').first)
              : Toasts.showErrorNormalToast(message.split('.').first);
        }
      } else {
        Toasts.showWarningNormalToast('You are offline');
      }
    } catch (e) {
      print('withdrawSubmit failed ${e}');
    }
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<UserData?> getUser() async {
    return await authRepo.getUser();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  clear() {
    states.clear();
    authRepo.handleSubscription(userData);
    userData = UserData();
    bankdetail_id = '';
    usdtt_address = '';
    usdtb_address = '';
    account_holder_name = '';
    account_number = '';
    ifsc_code = '';
    bank = '';
    address = '';
    loadingCommissionWithdrawal = false;
  }

  void updateCommissionWithdrawal(String text, String text2, String text3,
      String text4, String text5, String text6, String text7, String text8) {}

  Future<Map<String, dynamic>> getSavedCredentials() async {
    Map<String, dynamic> list = {};
    var sp = sl.get<SpUtil>();
    try {
      var data = await sp.getData(SPConstants.savedCredentials);
      if (data != null && data.isNotEmpty) {
        list = data;
      }
      successLog('getSavedCredentials success  ${list}', 'Auth Provider');
    } catch (e) {
      errorLog('getSavedCredentials error $e', 'Auth Provider');
      return list;
    }
    return list;
  }

  Future<void> saveCredentials(String text, String text2) async {
    Map<String, dynamic> list =
        await sl.get<AuthProvider>().getSavedCredentials();
    list.addAll({text: text2});
    var sp = sl.get<SpUtil>();
    await sp.setData(SPConstants.savedCredentials, list);
  }

  Future<Map<String, dynamic>> removeCredentials(String key) async {
    Map<String, dynamic> list =
        await sl.get<AuthProvider>().getSavedCredentials();
    list.remove(key);
    var sp = sl.get<SpUtil>();
    await sp.setData(SPConstants.savedCredentials, list);
    return list;
  }

  Future<void> updateCredential(String key, String pass) async {
    Map<String, dynamic> list =
        await sl.get<AuthProvider>().getSavedCredentials();
    list.update(key, (value) => pass);
    var sp = sl.get<SpUtil>();
    await sp.setData(SPConstants.savedCredentials, list);
  }

// verify coupon
  bool loadingVerifyEmail = false;
  Future<void> verifyemail() async {
    FocusScope.of(Get.context!).unfocus();
    try {
      if (isOnline) {
        loadingVerifyEmail = true;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 3000));
        ApiResponse apiResponse =
            await authRepo.verifyEmail({'username': userData.username ?? ''});
        infoLog('verify Email online hit  ${apiResponse.response?.data}');
        // Get.back();
        if (apiResponse.response != null &&
            apiResponse.response!.statusCode == 200) {
          Map map = apiResponse.response!.data;
          String message = '';
          bool status = false;
          try {
            status = map["status"];
            if (map['is_logged_in'] == 0) {
              logOut('verify Email');
            }
          } catch (e) {}
          try {
            message = map["message"] ?? '';
          } catch (e) {}

          if (status) {
            Toasts.showSuccessNormalToast(message);
          } else {
            Toasts.showErrorNormalToast(message);
          }
        }
      } else {
        Toasts.showWarningNormalToast('You are offline');
      }
    } catch (e) {
      print('verify Email failed ${e}');
    }
    loadingVerifyEmail = false;
    notifyListeners();
  }








}
