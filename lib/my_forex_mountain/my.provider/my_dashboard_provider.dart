import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_company_info_model.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_dash_repo.dart';

import '../../utils/api_checker.dart';
import '../my.model/my_bank_model.dart';
import '../my.model/my_dashboard_model.dart';
import '../my.model/my_support_model.dart';
import '../my.screens/functions/my_function.dart';

class MyDashboardProvider with ChangeNotifier {
  final DashRepo dashRepo;
  MyDashboardProvider({required this.dashRepo});
  bool _isLoading = false;
  String? _errorMessage;
  DashboardModel? _dashboardData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DashboardModel? get dashboardData => _dashboardData;

  BankDetailsModel? _bankDetails;
  BankDetailsModel? get bankDetails => _bankDetails;

  bool _isLoadingBank = false;
  bool get isLoadingBank => _isLoadingBank;

  MyCompanyInfo? _companyInfo;
  MyCompanyInfo? get companyInfo => _companyInfo;

  ///Support
  TicketListResponse? _ticketListResponse;
  TicketListResponse? get ticketListResponse => _ticketListResponse;
  int currentPage = 1;

  bool _isLoadingSupport = false;
  bool get isLoadingSupport => _isLoadingSupport;


  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> getDashboardData(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await dashRepo.getDashboardData();

    await handleSessionExpired(context, response.response?.data);

    if (response.response != null && response.response?.statusCode == 200) {
      final resBody = response.response?.data;
      try {
        final data = resBody['data'];
        if (data == null) {
          _dashboardData = null;
          _errorMessage = "No data available.";
          debugPrint("⚠️ Dashboard data is null.");
        } else {
          _dashboardData = DashboardModel.fromJson(data);
        }
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
  Future<void> getBankDetails(BuildContext context) async {
    _isLoadingBank = true;
    notifyListeners();
    final response = await dashRepo.getBankData();

    await handleSessionExpired(context, response.response?.data);

    if (response.response != null && response.response?.statusCode == 200) {
      try {
        _bankDetails =
            BankDetailsModel.fromJson(response.response!.data['data']);
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
    final response = await dashRepo.getCompanyInfo();
    await handleSessionExpired(context, response.response?.data);
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

  /// ___________________support
  Future<void> getSupportData(BuildContext context) async {
    _isLoadingSupport = true;
    _errorMessage = null;
    notifyListeners();
 final map = {
   'page' : currentPage.toString()
 };
    final response = await dashRepo.getSupportData(map);

    await handleSessionExpired(context, response.response?.data);

    if (response.response != null && response.response?.statusCode == 200) {
      try {
        final resBody = response.response!.data;
        _ticketListResponse = TicketListResponse.fromJson(resBody);
      } catch (e) {
        _errorMessage = 'Support data parsing error: ${e.toString()}';
        debugPrint('❌ Parsing error in support data: $e');
      }
    } else {
      _errorMessage = response.error.toString();
      debugPrint('❌ API Error in support data: $_errorMessage');
    }

    _isLoadingSupport = false;
    notifyListeners();
  }

  Future<bool> createSupportTicket({
    required BuildContext context,
    required String subject,
    required String departmentId,
    required String message,
  }) async {
    setLoading(true);

    final map = {
      "subject": subject,
      "department": departmentId.toString(),
      "message": message,
    };

    final response = await dashRepo.createSupportTicket(map);
    await handleSessionExpired(context, response.response?.data);

    setLoading(false);

    if (response.response != null && response.response?.statusCode == 200) {
      return true;
    } else {
      setError(response.error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create ticket: ${response.error}")),
      );
      return false;
    }
  }

}
