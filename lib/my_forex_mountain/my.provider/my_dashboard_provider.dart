import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_dash_repo.dart';

import '../my.model/my_dashboard_model.dart';

class MyDashboardProvider with ChangeNotifier {
  final DashRepo dashRepo;
  MyDashboardProvider({required this.dashRepo});
  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboardData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardModel?  get dashboardData => _dashboardData;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> getDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await dashRepo.getDashboardData();

    if (response.response != null && response.response?.statusCode == 200) {
      final resBody = response.response?.data;

      try {
        final data = resBody['data'];
        _dashboardData = DashboardModel.fromJson(data);
      } catch (e) {
        _errorMessage = 'Parsing error: ${e.toString()}';
        debugPrint('❌ JSON Parsing error: $e');
      }
    } else {
      _errorMessage = response.error.toString();
      debugPrint('❌ API Error: $_errorMessage');
    }

    _isLoading = false;
    notifyListeners();
  }


}