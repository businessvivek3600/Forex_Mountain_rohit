import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/model/response/base/api_response.dart';
import '../my.constant/my_app_constant.dart';

class MyWalletRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  MyWalletRepo({required this.dioClient, required this.sharedPreferences});

  final String url = MyAppConstants.baseUrl;

  /// Common function to fetch wallet data from any endpoint
  Future<ApiResponse> getWalletData(
      String endpoint, Map<String, String> map) async {
    try {
           Response response = await dioClient.post(
        url + endpoint,
        token: true,
        data: map,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(
          '❌ Error fetching from [$endpoint]: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getFundRequestData(Map<String, String> map) async {
    try {
      print(
          '📤 Wallet API [${MyAppConstants.walletFundRequest}] Request Body: $map');

      Response response = await dioClient.post(
        url + MyAppConstants.walletFundRequest,
        token: true,
        data: map,
      );

      print(
          '✅ Wallet API [${MyAppConstants.walletFundRequest}] Response: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(
          '❌ Error fetching from [${MyAppConstants.walletFundRequest}]: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
