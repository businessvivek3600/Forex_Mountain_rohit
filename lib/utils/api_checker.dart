import 'package:flutter/material.dart';
import '/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

import '../database/model/response/base/api_response.dart';
import '../providers/auth_provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if (apiResponse.error is! String &&
        apiResponse.error.errors[0].message == 'Unauthorized.') {
      // Provider.of<ProfileProvider>(context,listen: false).clearHomeAddress();
      // Provider.of<ProfileProvider>(context,listen: false).clearOfficeAddress();
      Provider.of<AuthProvider>(context, listen: false).clearSharedData();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_errorMessage, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));
    }
  }
}
