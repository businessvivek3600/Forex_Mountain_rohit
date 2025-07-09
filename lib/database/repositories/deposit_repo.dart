import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';
import '../dio/dio/dio_client.dart';
import '../dio/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';

class DepositRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  DepositRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getDepositRequest() async {
    try {
      Response response = await dioClient.post(AppConstants.depositRequest, token: true);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> putDepositRequest({
    required Map<String,dynamic> data,
  }) async {
    try {
      // Using the updated postMultipart method from DioClient
      Response response = await dioClient.postMultipart(
        AppConstants.putDepositRequest,
        data: data,
        addToken: true, // Adds the login_token field
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}


