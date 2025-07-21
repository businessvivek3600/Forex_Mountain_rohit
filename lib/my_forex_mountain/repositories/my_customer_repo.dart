


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/dio/dio/dio_client.dart';
import '../../database/dio/exception/api_error_handler.dart';
import '../../database/model/response/base/api_response.dart';
import '../my.constant/my_app_constant.dart';

class MyCustomerRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  MyCustomerRepo({required this.dioClient, required this.sharedPreferences});

  static const String tag = 'AuthRepo';

  final String url = MyAppConstants.baseUrl;





}