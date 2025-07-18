import 'package:flutter/foundation.dart';
import '../my.model/login_request_model.dart';
import '../my.model/my_customer_model.dart';
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

      _token = data['token'];

      if (data['customer'] != null) {
        _customer = MyCustomerModel.fromJson(data['customer']);
        debugPrint('👤 Logged in user: ${_customer?.username}');
      }
    } catch (e) {
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
