

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/login_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';
import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/functions.dart';
import '../../database/model/response/base/api_response.dart';
import '../../utils/default_logger.dart';
import '../my.constant/my_app_constant.dart';
import '../my.model/sign_request_model.dart';


class NewAuthRepo {
  final DioClient dioClient;
final SharedPreferences sharedPreferences;
  NewAuthRepo({required this.dioClient, required this.sharedPreferences});

static const String tag = 'AuthRepo';

final String url = MyAppConstants.baseUrl;

  Future<void> saveUserToken(String token) async {
    dioClient.updateUserToken(token);
    try {
      await sharedPreferences.setString(SPConstants.userToken, token);
    } catch (e) {
      rethrow;
    }
  }

  ///:Login
  Future<ApiResponse> login(LoginRequestModel loginBody) async {
    try {
      final fcmToken = await getDeviceToken(username: loginBody.username);
      loginBody.device_id = fcmToken;
      loginBody.device_name = await getDeviceName();

      final response = await dioClient.post(
        url + MyAppConstants.login,
        data: loginBody.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Signup
  Future<ApiResponse> signUp(SignupModel signupBody) async {
    try {
      debugPrint('🔗 API URL: $url${MyAppConstants.signup}');
      debugPrint('📦 POST BODY: ${signupBody.toJson()}');

      final response = await dioClient.post(
        url + MyAppConstants.signup,
        data: signupBody.toJson(),
      );

      debugPrint('✅ SIGNUP RESPONSE: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}

