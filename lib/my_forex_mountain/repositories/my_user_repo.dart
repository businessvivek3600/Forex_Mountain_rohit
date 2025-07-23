

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/model/response/base/api_response.dart';
import '../my.constant/my_app_constant.dart';
import '../my.model/my_bank_model.dart';

class NewUserRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  NewUserRepo({required this.dioClient, required this.sharedPreferences});
  final String url = MyAppConstants.baseUrl;

/// Fetch SUBMIT KYC AND UPDATE KYC
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
  /// Fetch KYC data
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

  /// Fetch Bank Details
  Future<ApiResponse> submitBankDetailsForm({
    required BankDetailsModel bankDetails,
    File? phonePayQrImage,
    File? googlePayQrImage,
  }) async {
    try {
      final formDataMap = <String, dynamic>{};

      // Conditionally add fields only if they are not null
      if (bankDetails.bank != null) {
        formDataMap.addAll({
          if (bankDetails.bank!.bank != null) 'bank': bankDetails.bank!.bank,
          if (bankDetails.bank!.branch != null) 'branch': bankDetails.bank!.branch,
          if (bankDetails.bank!.ibnCode != null) 'ibn_code': bankDetails.bank!.ibnCode,
          if (bankDetails.bank!.swiftCode != null) 'swift_code': bankDetails.bank!.swiftCode,
          if (bankDetails.bank!.ifscCode != null) 'ifsc_code': bankDetails.bank!.ifscCode,
          if (bankDetails.bank!.accountHolderName != null) 'account_holder_name': bankDetails.bank!.accountHolderName,
          if (bankDetails.bank!.accountNumber != null) 'account_number': bankDetails.bank!.accountNumber,
        });
      }

      if (bankDetails.usdtTrc?.usdtAddress != null) {
        formDataMap['usdt_address'] = bankDetails.usdtTrc!.usdtAddress!;
      }

      if (bankDetails.usdtBep?.obdAddress != null) {
        formDataMap['obd_address'] = bankDetails.usdtBep!.obdAddress!;
      }

      if (bankDetails.phonePay != null) {
        formDataMap.addAll({
          if (bankDetails.phonePay!.phonePayNo != null) 'phone_pay_no': bankDetails.phonePay!.phonePayNo,
          if (bankDetails.phonePay!.phonePayId != null) 'phone_pay_id': bankDetails.phonePay!.phonePayId,
        });
      }

      if (bankDetails.googlePay != null) {
        formDataMap.addAll({
          if (bankDetails.googlePay!.googlePayNo != null) 'google_pay_no': bankDetails.googlePay!.googlePayNo,
          if (bankDetails.googlePay!.googlePayId != null) 'google_pay_id': bankDetails.googlePay!.googlePayId,
        });
      }

      // Add token
      formDataMap['login_token'] = sharedPreferences.getString("login_token");

      // Build FormData
      final formData = FormData.fromMap(formDataMap);

      // Conditionally add images
      if (phonePayQrImage != null) {
        formData.files.add(MapEntry(
          'phone_pay_qr',
          await MultipartFile.fromFile(phonePayQrImage.path),
        ));
      }

      if (googlePayQrImage != null) {
        formData.files.add(MapEntry(
          'google_pay_qr',
          await MultipartFile.fromFile(googlePayQrImage.path),
        ));
      }
      // Log the field data
      print('📝 Form Fields:');
      formDataMap.forEach((key, value) {
        print('  $key: $value');
      });



      if (phonePayQrImage != null) {
        final fileName = phonePayQrImage.path.split('/').last;
        print('📎 Attached file (Phone Pay QR): $fileName');
        formData.files.add(MapEntry(
          'phone_pay_qr',
          await MultipartFile.fromFile(phonePayQrImage.path),
        ));
      }

      if (googlePayQrImage != null) {
        final fileName = googlePayQrImage.path.split('/').last;
        print('📎 Attached file (Google Pay QR): $fileName');
        formData.files.add(MapEntry(
          'google_pay_qr',
          await MultipartFile.fromFile(googlePayQrImage.path),
        ));
      }
      final response = await dioClient.postMultipart(
        MyAppConstants.baseUrl + MyAppConstants.editBank,
        data: formDataMap,
        addToken: true,
      );

      print('✅ Bank Details API Response [${response.statusCode}]: ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('❌ Bank Details API Error: ${ApiErrorHandler.getMessage(e)}');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
///CHANGE PASSWORD
  Future<ApiResponse> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await dioClient.post(
        url + MyAppConstants.changePassword,
        data: {
          "old_password": oldPassword,
          "spassword": newPassword,
          "repassword": confirmPassword,
        },
        token: true,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}



