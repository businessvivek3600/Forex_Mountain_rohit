import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '/constants/app_constants.dart';
import '/utils/default_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  late Dio dio;
  late String token;
  String? _userToken;


  DioClient(
    this.baseUrl,
    Dio? dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    token = AppConstants.authorizationToken;
    // print("DioClient x-api-key Token $token");
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(milliseconds: 30000)
      ..options.receiveTimeout = const Duration(milliseconds: 30000)
      ..httpClientAdapter
      ..options.headers = {
        'content-type': 'multipart/form-data',
        'x-api-key': token,
      }
      ..options.responseType = ResponseType.json;
    dio.interceptors.add(loggingInterceptor);
  }

  void updateHeader(String? token, {String? contentType}) {
    token = token ?? this.token;
    this.token = token;
    dio.options.headers = {
      'Content-Type': contentType ?? 'application/json; charset=UTF-8',
      'x-api-key': token,
    };
  }

  void updateUserToken(String? userToken) {
    _userToken = userToken ?? _userToken;
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (err) {
      throw SocketException(err.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool token = false,
  }) async {
    try {
      FormData formData = FormData();
      formData.fields.addAll((data ?? <String, dynamic>{})
          .entries
          .toList()
          .map((e) => MapEntry(e.key, e.value)));
      if (token) {
        formData.fields.add(MapEntry('login_token', _userToken ?? ''));
      }
      infoLog('FieldData', uri, formData.fields.toString());
      var response = await dio.post(
        uri,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (e) {
      throw FormatException("Unable to process the data $e");
    } catch (e) {
      errorLog('post cache error $e');
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
  Future<Response> postMultipart(
      String uri, {
        required Map<String, dynamic> data,
        bool addToken = false,
      }) async {
    try {
      // Create FormData instance
      FormData formData = FormData();

      // Add fields and files
      data.forEach((key, value) {
        if (value is MultipartFile) {
          formData.files.add(MapEntry(key, value));
        } else if (value is List<MultipartFile>) {
          for (var file in value) {
            formData.files.add(MapEntry(key, file));
          }
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add token if required
      if (addToken) {
        formData.fields.add(MapEntry('login_token', _userToken ?? ''));
      }

      infoLog('Multipart Fields', uri, formData.fields.toString());
      infoLog('Multipart Files', uri,
          formData.files.map((f) => '${f.key}: ${f.value.filename}').join(', '));

      // Use Dio for sending the request
      Dio dio = Dio();
      dio.options.baseUrl = baseUrl;
      dio.options.headers = {
        'Content-Type': 'multipart/form-data',
        'x-api-key': AppConstants.authorizationToken,
      };

      Response response = await dio.post(uri, data: formData);

      return response;
    } on DioError catch (e) {
      errorLog('DioError', e.message, e.response?.data.toString() ?? '');
      rethrow;
    } catch (e) {
      errorLog('Exception', e.toString(), '');
      rethrow;
    }
  }




}
