import 'dart:io';

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
          '📤 Wallet API [${MyAppConstants.walletFundHistory}] Request Body: $map');

      Response response = await dioClient.post(
        url + MyAppConstants.walletFundHistory,
        token: true,
        data: map,
      );

      print(
          '✅ Wallet API [${MyAppConstants.walletFundHistory}] Response: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(
          '❌ Error fetching from [${MyAppConstants.walletFundHistory}]: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> submitFundRequestWithImage({
    required String transactionNumber,
    required String paymentType,
    required String amount,
    required File transactionFile,
  }) async {
    try {
      // Create a MultipartFile from the File
      final multipartFile = await MultipartFile.fromFile(
        transactionFile.path,
        filename: transactionFile.path.split('/').last,
      );

      // Build FormData
      final formData = {
        'transaction_number': transactionNumber,
        'payment_type': paymentType,
        'amount': amount,
        'transaction_file': multipartFile,
      };
      // Post with DioClient using the regular `post` method (not postMultipart)
      final response = await dioClient.postMultipart(
        url + MyAppConstants.walletFundRequest,
        data: formData,
        addToken: true,
      );

      print('✅ API Response [${response.statusCode}]: ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ API Error: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getWalletToTransaction(Map<String, String> map) async {
    try {
      print('\n📤 [POST] Transfer To Wallet');
      print('➡️ URL: ${url + MyAppConstants.transferToWallet}');
      print('📝 Body: $map\n');

      Response response = await dioClient.post(
        url + MyAppConstants.transferToWallet,
        token: true,
        data: map,
      );

      print('✅ API Response [${response.statusCode}]: ${response.data}\n');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ API Error: ${ApiErrorHandler.getMessage(e)}\n');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
