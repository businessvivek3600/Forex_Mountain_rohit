
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

class DashRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  DashRepo({required this.dioClient, required this.sharedPreferences});

  static const String tag = 'DashRepo';

  final String url = MyAppConstants.baseUrl;

  Future<ApiResponse> getDashboardData() async {
    try {
      // Print or log request info
      debugPrint('🔗 API URL: $url${MyAppConstants.dashboard}');

      final response = await dioClient.post(url + MyAppConstants.dashboard,token: true);

      // Log the response
      debugPrint('✅ RESPONSE DATA: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBankData() async {
    try {
      // Print or log request info
      debugPrint('🔗 API URL: $url${MyAppConstants.bankDetail}');

      final response = await dioClient.post(url + MyAppConstants.bankDetail,token: true);

      // Log the response
      debugPrint('✅ RESPONSE DATA: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}