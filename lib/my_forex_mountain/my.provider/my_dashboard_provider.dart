import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_company_info_model.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_dash_repo.dart';

import '../../database/model/response/base/api_response.dart';
import '../../database/model/response/company_info_model.dart';
import '../../utils/api_checker.dart';
import '../my.model/my_bank_model.dart';
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

  BankDetailsModel? _bankDetails;
  BankDetailsModel? get bankDetails => _bankDetails;

  bool _isLoadingBank = false;
  bool get isLoadingBank => _isLoadingBank;

  MyCompanyInfo? _companyInfo;
  MyCompanyInfo? get companyInfo => _companyInfo;


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
print(resBody);
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

///___________________GET BANK DETAILS___________________
  Future<void> getBankDetails() async {
    _isLoadingBank = true;
    notifyListeners();

    ApiResponse response = await dashRepo.getBankData();

    if (response.response != null && response.response?.statusCode == 200) {
      try {
        _bankDetails = BankDetailsModel.fromJson(response.response!.data['data']);
      } catch (e) {
        debugPrint('⚠️ Error parsing bank data: $e');
      }
    } else {
      _errorMessage = response.error.toString();
      debugPrint('❌ API Error: $_errorMessage');
    }
    _isLoadingBank = false;
    notifyListeners();
  }

  ///___________________GET COMPANY INFO___________________
  Future<void> getCompanyInfo(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    ApiResponse response = await dashRepo.getCompanyInfo();
    if (response.response != null && response.response?.statusCode == 200) {
      try {
        final data = response.response!.data['data']['company_info'];
        _companyInfo = MyCompanyInfo.fromJson(data);
        notifyListeners();
      } catch (e) {
        debugPrint("CompanyInfo parsing error: $e");
      }
    } else {
      ApiChecker.checkApi(context, response);
    }
    _isLoadingBank = false;
    notifyListeners();
  }

}

