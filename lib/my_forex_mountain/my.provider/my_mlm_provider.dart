import 'package:flutter/cupertino.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_mlm_repo.dart';

import '../my.model/my_generation_model.dart';
import '../my.model/my_packages_model.dart';
import '../my.model/my_team_view_model.dart';
import '../my.screens/drawer/packages/packages.dart';
import '../my.screens/functions/my_function.dart';

class MyMlmProvider extends ChangeNotifier {
  final MyMLMRepo mlmRepo;

  MyMlmProvider({required this.mlmRepo});

  bool _isFirstLoad = false;
  bool _isPaginating = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;
  List<MyTeamMember> _teamMembers = [];
  List<MyTeamMember> _directMembers = [];

  bool get isFirstLoad => _isFirstLoad;
  bool get isPaginating => _isPaginating;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  List<MyTeamMember> get teamMembers => _teamMembers;
  List<MyTeamMember> get directMembers => _directMembers;
  void resetTeam() {
    _teamMembers = [];
    _directMembers = [];
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();
  }

  Future<void> fetchMyTeamData(BuildContext context,
      {bool loadMore = false}) async {
    if (loadMore && (_isPaginating || !_hasMore)) return;
    if (!loadMore && _isFirstLoad) return;
    if (loadMore) {
      _isPaginating = true;
    } else {
      _isFirstLoad = true;
    }
    _errorMessage = null;
    notifyListeners();
    try {
      final map = {
        'page': _currentPage.toString(),
      };
      final apiResponse = await mlmRepo.getMyTeamData(map);
      await handleSessionExpired(context, apiResponse.response?.data);
      if (apiResponse.response?.statusCode == 200) {
        final responseData = apiResponse.response?.data;
        final List<dynamic> result = responseData?['data'] ?? [];
        final newList = result.map((e) => MyTeamMember.fromJson(e)).toList();
        if (loadMore) {
          _teamMembers.addAll(newList);
        } else {
          _teamMembers = newList;
        }
        _hasMore = newList.isNotEmpty;
        if (_hasMore) _currentPage++;
      } else {
        _errorMessage = 'Failed to fetch Team Member';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isFirstLoad = false;
      _isPaginating = false;
      notifyListeners();
    }
  }

  Future<void> fetchDirectMemberData(BuildContext context,
      {bool loadMore = false}) async {
    if (loadMore && (_isPaginating || !_hasMore)) return;
    if (!loadMore && _isFirstLoad) return;
    if (loadMore) {
      _isPaginating = true;
    } else {
      _isFirstLoad = true;
    }
    _errorMessage = null;
    notifyListeners();
    try {
      final map = {
        'page': _currentPage.toString(),
      };
      final apiResponse = await mlmRepo.getDirectMemberData(map);
      await handleSessionExpired(context, apiResponse.response?.data);
      if (apiResponse.response?.statusCode == 200) {
        final responseData = apiResponse.response?.data;
        final List<dynamic> result = responseData?['data'] ?? [];
        final newList = result.map((e) => MyTeamMember.fromJson(e)).toList();
        if (loadMore) {
          _directMembers.addAll(newList);
        } else {
          _directMembers = newList;
        }
        _hasMore = newList.isNotEmpty;
        if (_hasMore) _currentPage++;
      } else {
        _errorMessage = 'Failed to fetch Team Member';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isFirstLoad = false;
      _isPaginating = false;
      notifyListeners();
    }
  }

  ///GENERATION DATA
  GenerationalTreeResponse? _generationData;
  GenerationalTreeResponse? get generationData => _generationData;

  bool _isLoadingGeneration = false;
  bool get isLoadingGeneration => _isLoadingGeneration;

  String? _generationError;
  String? get generationError => _generationError;

  Future<void> fetchGenerationData(BuildContext context,
      {String customerId = ''}) async {
    _isLoadingGeneration = true;
    _generationError = null;
    notifyListeners();

    try {
      final map = {'customer_id': customerId};
      final apiResponse = await mlmRepo.getGenerationData(map);
      await handleSessionExpired(context, apiResponse.response?.data);

      if (apiResponse.response?.statusCode == 200) {
        final responseData = apiResponse.response?.data;

        _generationData = GenerationalTreeResponse.fromJson(responseData);
      } else {
        _generationError = 'Failed to fetch generation data';
      }
    } catch (e) {
      _generationError = 'Error: $e';
    } finally {
      _isLoadingGeneration = false;
      notifyListeners();
    }
  }

  ///packages----------------------------
  bool _isLoadingPackages = false;
  bool get isLoadingPackages => _isLoadingPackages;

  String? _packageError;
  String? get packageError => _packageError;

  MyPackagesModel? _packagesModel;
  MyPackagesModel? get packagesModel => _packagesModel;

  Future<void> fetchPackagesData(BuildContext context) async {
    _isLoadingPackages = true;
    _packageError = null;
    notifyListeners(); // optionally notify before

    try {
      final apiResponse = await mlmRepo.getPackageData();
      await handleSessionExpired(context, apiResponse.response?.data);

      final responseData = apiResponse.response?.data;

      /// 🔍 Print the full raw response to console
      print('API Response: $responseData');

      if (apiResponse.response?.statusCode == 200) {
        _packagesModel = MyPackagesModel.fromJson(responseData);
      } else {
        _packageError = 'Failed to fetch package data';
      }
    } catch (e, stacktrace) {
      _packageError = 'Error: $e';
      print('Error occurred: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      _isLoadingPackages = false;
      notifyListeners();
    }
  }
  Future<void> withdrawPackageByInvoiceId(
      BuildContext context, String invoiceId) async {
    try {
      final response = await mlmRepo.withdrawPackage({"invoice_id": invoiceId});
      final responseData = response.response?.data;

      if (response.response?.statusCode == 200 &&
          responseData['status'] == true) {
        showCustomToast(context, responseData['message'] ?? "Withdraw successful");
        fetchPackagesData(context); // 🔁 Refresh the list
      } else {
        showCustomToast(context, responseData['message'] ?? "Withdraw failed", isError: true);
      }
    } catch (e) {
      showCustomToast(context, 'Withdraw error: $e', isError: true);
    }
  }
  Future<void> purchasePackage(
      BuildContext context, {
        required String planId,
        required String amount,
        String? duration,
      }) async {
    try {
      final Map<String, String> payload = {
        "plan_id": planId,
        "amount": amount,
      };

      if (duration != null) {
        payload["duration"] = duration;
      }

      final response = await mlmRepo.purchasePackage(payload);
      final responseData = response.response?.data;

      if (response.response?.statusCode == 200 &&
          responseData['status'] == true) {
        showCustomToast(context, responseData['message'] ?? "Purchase successful");
        fetchPackagesData(context); // Refresh list if needed
        Navigator.of(context).pop(); // Optional: close BuyPackage screen
      } else {
        showCustomToast(context, responseData['message'] ?? "Purchase failed", isError: true);
      }
    } catch (e) {
      showCustomToast(context, 'Purchase error: $e', isError: true);
    }
  }


}
