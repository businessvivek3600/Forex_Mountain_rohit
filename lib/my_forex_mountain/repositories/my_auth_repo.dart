import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';
import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/functions.dart';
import '../../database/model/response/base/api_response.dart';
import '../../utils/default_logger.dart';

import '../../utils/my_logger.dart';
import '../my.constant/my_app_constant.dart';
import '../my.model/MYforgot_password_response.dart';
import '../my.model/login_request_model.dart';
import '../my.model/sign_request_model.dart';

class NewAuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  NewAuthRepo({
    required this.dioClient,
    required this.sharedPreferences,
  });

  static const String tag = 'AuthRepo';
  final String baseUrl = MyAppConstants.baseUrl;

  /// Save token to shared preferences
  Future<void> saveUserToken(String token) async {
    dioClient.updateUserToken(token);
    try {
      await sharedPreferences.setString(SPConstants.userToken, token);
      await setIsLogin(true); // ✅ Set login true when token is saved
    } catch (e) {
      rethrow;
    }
  }

  /// Save isLogin status to shared preferences
  Future<void> setIsLogin(bool value) async {
    await sharedPreferences.setBool(SPConstants.isLogin, value);
  }

  String getUserToken() {
    return sharedPreferences.getString(SPConstants.userToken) ?? '';
  }

  /// Get login status
  bool isLoggedIn() {
    return sharedPreferences.getBool(SPConstants.isLogin) ?? false;
  }
  Future<void> clearAuthData() async {
    try {
      await sharedPreferences.remove(SPConstants.userToken);
      await sharedPreferences.setBool(SPConstants.isLogin, false);
      dioClient.updateUserToken('');
    } catch (e) {
      debugPrint('❌ Error clearing auth data: $e');
      rethrow;
    }
  }

  /// Login
  Future<ApiResponse> login(LoginRequestModel loginBody) async {
    try {
      final fcmToken = await getDeviceToken(username: loginBody.username);
      loginBody.device_id = fcmToken;
      loginBody.device_name = await getDeviceName();

      final response = await dioClient.post(
        '$baseUrl${MyAppConstants.login}',
        data: loginBody.toJson(),
      );
      // ✅ If success, set isLogin = true
      if (response.data['is_login'] == 1) {
        await setIsLogin(true);
      }

      return ApiResponse.withSuccess(response);
    } catch (e) {
      await setIsLogin(false);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Signup
  Future<ApiResponse> signUp(SignupModel signupBody) async {
    try {
      debugPrint('🔗 API URL: $baseUrl${MyAppConstants.signup}');
      debugPrint('📦 POST BODY: ${signupBody.toJson()}');

      final response = await dioClient.post(
        '$baseUrl${MyAppConstants.signup}',
        data: signupBody.toJson(),
      );

      debugPrint('✅ SIGNUP RESPONSE: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Forgot Password
  Future<ApiResponse>forgotPassword(String email ) async {
    try {
      debugPrint('🔗 API URL: $baseUrl${MyAppConstants.forgetPassword}');
      debugPrint('📦 POST BODY: ${email}');

      final response = await dioClient.post(
        '$baseUrl${MyAppConstants.forgetPassword}',
        data: {
          'email' : email
        },
      );

      debugPrint('✅ ForgotPassword RESPONSE: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> logout() async {
    try {
      debugPrint('🔗 API URL: $baseUrl${MyAppConstants.logout}');
      final response = await dioClient.post(
        '$baseUrl${MyAppConstants.logout}',token: true,

      );

      debugPrint('✅ ForgotPassword RESPONSE: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
