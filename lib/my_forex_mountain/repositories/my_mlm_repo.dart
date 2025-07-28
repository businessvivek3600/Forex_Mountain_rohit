


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/model/response/base/api_response.dart';
import '../my.constant/my_app_constant.dart';

class MyMLMRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  MyMLMRepo({required this.dioClient, required this.sharedPreferences});

  static const String tag = 'MLM REPo';

  final String url = MyAppConstants.baseUrl;

  Future<ApiResponse> getMyTeamData() async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.myTeam, token: true);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDirectMemberData() async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.directTeam, token: true);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}