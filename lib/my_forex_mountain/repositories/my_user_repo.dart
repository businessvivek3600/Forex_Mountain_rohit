

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/model/response/base/api_response.dart';
import '../my.constant/my_app_constant.dart';

class NewUserRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  NewUserRepo({required this.dioClient, required this.sharedPreferences});
  final String url = MyAppConstants.baseUrl;


  Future<ApiResponse> submitKycForm({
    required String countryCode,
    required String docType,
    required String docNumber,
    required File uploadFirstProof,
    required File uploadSecondProof,
  }) async {
    try {
      final multipartDoc = await MultipartFile.fromFile(
        uploadFirstProof.path,
        filename: uploadFirstProof.path.split('/').last,
      );
      final multipartSelfie = await MultipartFile.fromFile(
        uploadSecondProof.path,
        filename: uploadSecondProof.path.split('/').last,
      );
// 📌 Debug Print
      print('\n📤 [POST] KYC Submission Request');
      print('➡️ Endpoint: ${url + MyAppConstants.addKyc}');
      print('📦 Payload:');
      print('  country_code: $countryCode');
      print('  doc_type: $docType');
      print('  doc_number: $docNumber');
      print('  upload_first_proof: ${uploadFirstProof.path.split('/').last}');
      print('  upload_second_proof: ${uploadSecondProof.path.split('/').last}\n');
      final formData = {
        'country_code': countryCode,
        'doc_type': docType,
        'doc_number': docNumber,
        'upload_first_proof': multipartDoc,
        'upload_second_proof': multipartSelfie,
      };

      final response = await dioClient.postMultipart(
        url + MyAppConstants.addKyc,
        data: formData,
        addToken: true,
      );

      print('✅ KYC API Response [${response.statusCode}]: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ KYC API Error: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getKycData() async {
    try {
      final response = await dioClient.post(url + MyAppConstants.getKyc, token: true);

      // ✅ Print full KYC response data
      print('KYC API Response Status Code: ${response.statusCode}');
      print('KYC API Response Body: ${response.data}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('KYC API Error: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


}