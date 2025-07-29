


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

  Future<ApiResponse> getMyTeamData(Map<String, String> map) async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.myTeam, token: true, data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDirectMemberData(Map<String, String> map) async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.directTeam, token: true,data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getGenerationData(Map<String, String> map) async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.generationData, token: true,data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getPackageData() async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.packages, token: true);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> withdrawPackage(Map<String, String> map) async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.packageWithdraw, token: true,data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> purchasePackage(Map<String, String> map) async {
    try {
      final response =
      await dioClient.post(url + MyAppConstants.purchasePackage, token: true,data: map);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}