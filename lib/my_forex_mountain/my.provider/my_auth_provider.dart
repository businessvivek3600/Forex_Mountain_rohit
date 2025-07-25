import 'package:flutter/material.dart';
import '../../database/model/response/base/api_response.dart';
import '../my.model/login_request_model.dart';
import '../my.model/my_customer_model.dart';
import '../my.model/sign_request_model.dart';
import '../my.model/MYforgot_password_response.dart';
import '../repositories/my_auth_repo.dart';

class NewAuthProvider with ChangeNotifier {
  final NewAuthRepo authRepository;

  NewAuthProvider({required this.authRepository});

  bool _isLoading = false;
  String? _token;
  String? _errorMessage;
  MyCustomerModel? _customer;
  ForgotPasswordResponse? _forgotResponse;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  MyCustomerModel? get customer => _customer;
  ForgotPasswordResponse? get forgotResponse => _forgotResponse;


  void initAuth() {
    final token = authRepository.getUserToken();
    if (token.isNotEmpty) {
      _token = token;
      authRepository.saveUserToken(token);
      notifyListeners();
    }
  }


  Future<void> logout() async {
    _token = null;
    _customer = null;
    await authRepository.clearAuthData();
    notifyListeners();
  }




  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final loginRequest = LoginRequestModel(username: username, password: password);
      final response = await authRepository.login(loginRequest);
      final data = response.response?.data;
      if (data['customer'] != null) {
        authRepository.saveUserToken(_token = data['token'] ?? '');
        _customer = MyCustomerModel.fromJson(data['customer']);
        _token = _customer?.loginToken;
          authRepository.saveUserToken(token!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<bool> signUp(
      String customerMobile,
      String confirmPassword,
      String customerEmail,
      String firstName,
      String lastName,
      String password,
      String sponsor,
      String userName,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final signUpRequest = SignupModel(
        customerMobile: customerMobile,
        confirmPassword: confirmPassword,
        customerEmail: customerEmail,
        firstName: firstName,
        lastName: lastName,
        password: password,
        sponsorUsername: sponsor,
        username: userName,
      );

      final response = await authRepository.signUp(signUpRequest);
      final data = response.response?.data;

      if (data['status'] == true) {
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Signup failed';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call API through repository
   final response = await authRepository.forgotPassword(email);

      // Handle API success
      if (response.response != null && response.response?.data['status'] == true) {
        // Optionally map to model
        _forgotResponse = ForgotPasswordResponse.fromJson(response.response!.data);
        return true;
      } else {
        // Error from server
        _errorMessage = response.response?.data['error'] ?? response.error ?? 'Something went wrong';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _forgotResponse = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
