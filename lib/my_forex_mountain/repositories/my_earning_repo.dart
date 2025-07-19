

import 'package:dio/dio.dart';
import 'package:forex_mountain/my_forex_mountain/my.constant/my_app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';
import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/model/response/base/api_response.dart';

class MyEarningRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  MyEarningRepo({required this.dioClient, required this.sharedPreferences});
  final String url = MyAppConstants.baseUrl;


  ///:getEarningData
  Future<ApiResponse> getCEarningData(Map<String, String> map) async {
    try {

      Response response = await dioClient.post(
        url + MyAppConstants.earning,
        token: true,
        data: map,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ Error fetching earnings: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  ///:getPayoutData
  Future<ApiResponse> getPayOut(Map<String, String> map) async {
    try {

      Response response = await dioClient.post(
        url + MyAppConstants.payout,
        token: true,
        data: map,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ Error fetching earnings: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  ///:getPayoutData
  Future<ApiResponse> getWithdrawList(Map<String, String> map) async {
    try {

      Response response = await dioClient.post(
        url + MyAppConstants.withdrawList,
        token: true,
        data: map,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ Error fetching earnings: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getWithdrawInvoice(Map<String, String> map) async {
    try {
      print('📤 Withdraw Invoice Request Body: $map'); // 🟦 Request debug

      Response response = await dioClient.post(
        url + MyAppConstants.withdrawInvoice,
        token: true,
        data: map,
      );

      print('✅ Withdraw Invoice Response: ${response.data}'); // 🟩 Response debug

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ Error fetching invoice: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}