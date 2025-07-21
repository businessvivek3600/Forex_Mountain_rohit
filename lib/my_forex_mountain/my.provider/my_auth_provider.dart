import 'package:flutter/cupertino.dart';

import '../my.model/login_request_model.dart';
import '../my.model/my_customer_model.dart';
import '../my.model/sign_request_model.dart';
import '../repositories/my_auth_repo.dart';

class NewAuthProvider with ChangeNotifier {
  final NewAuthRepo authRepository;
  bool _isLoading = false;
  String? _token;
  String? _errorMessage;
  MyCustomerModel? _customer;
  MyCustomerModel? get customer => _customer;
  NewAuthProvider({required this.authRepository});
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get errorMessage => _errorMessage;
  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final loginRequest = LoginRequestModel(
        username: username,
        password: password,
      );
      final response = await authRepository.login(loginRequest);
      final data = response.response?.data;
      if (data['customer'] != null) {
        _customer = MyCustomerModel.fromJson(data['customer']);
        _token = _customer?.loginToken;
        authRepository.saveUserToken(_token!);
        debugPrint('👤 Logged in user: ${_customer?.username}');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String customerMobile, confirmPassword, customerEmail,
      firstName, lastname, password, sponsor, userName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final signUpRequest = SignupModel(
        customerMobile: customerMobile,
        confirmPassword: confirmPassword,
        customerEmail: customerEmail,
        firstName: firstName,
        lastName: lastname,
        password: password,
        sponsorUsername: sponsor,
        username: userName,
      );

      // Debug request data
      final requestBody = signUpRequest.toJson();
      debugPrint("🔗 Signup URL: ${authRepository.url}"); // Make sure you define `signUpUrl` in repo
      debugPrint("📦 Request Body: $requestBody");

      final response = await authRepository.signUp(signUpRequest);

      debugPrint("✅ Status Code: ${response.response?.statusCode}");
      debugPrint("📥 Response Body: ${response.response?.data}");
    } catch (e) {
      debugPrint("❌ Signup Error: $e");
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void logout() {
    _token = null;
    notifyListeners();
  }
}
