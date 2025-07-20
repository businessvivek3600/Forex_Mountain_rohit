import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_wallet_model.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_wallet_repo.dart';

import '../../database/model/response/base/api_response.dart';
import '../my.model/my_fund_request.dart';
import '../my.model/my_withdraw_model.dart';

class MyWalletProvider extends ChangeNotifier {
  final MyWalletRepo walletRepo;

  MyWalletProvider({required this.walletRepo});

  bool _isFirstLoad = false;
  bool _isPaginating = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  bool get isFirstLoad => _isFirstLoad;
  bool get isPaginating => _isPaginating;
  bool get hasMoreData => _hasMoreData;
  String _walletBalance = '0.00';
  String get walletBalance => _walletBalance;

  String? _error;
  String? get error => _error;

  List<MyWalletData> _walletTransactionList = [];
  List<MyWalletData> get walletTransactionList => _walletTransactionList;

  Future<void> resetAndFetchWalletData({required String endpoint}) async {
    _walletTransactionList = [];
    _currentPage = 1;
    _hasMoreData = true;
    await fetchWalletData(endpoint: endpoint);
  }

  Future<void> fetchWalletData({
    required String endpoint,
    bool loadMore = false,
  }) async {
    if (loadMore && (_isPaginating || !_hasMoreData)) return;

    if (loadMore) {
      _isPaginating = true;
    } else {
      _isFirstLoad = true;
    }

    _error = null;
    notifyListeners();

    final map = {
      'page': _currentPage.toString(),
    };

    ApiResponse apiResponse = await walletRepo.getWalletData(endpoint, map);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      try {
        _walletBalance = apiResponse.response!.data['wallet_balance']?.toString() ?? '0.00';

        final data = apiResponse.response!.data['transactions'] ?? [];

        final newList = List<MyWalletData>.from(
          data.map((json) => MyWalletData.fromJson(json)),
        );

        if (loadMore) {
          _walletTransactionList.addAll(newList);
        } else {
          _walletTransactionList = newList;
        }

        _hasMoreData = newList.isNotEmpty;
        if (_hasMoreData) _currentPage++;
      } catch (e) {
        _error = 'Failed to parse wallet data';
        print('⚠️ Parsing Error: $e');
      }
    } else {
      _error = apiResponse.error.toString();
    }

    _isFirstLoad = false;
    _isPaginating = false;
    notifyListeners();
  }

  /// FundRequest data history

  List<MyFundRequestModel> _fundRequestList = [];
  List<MyFundRequestModel> get fundRequestList => _fundRequestList;

  bool _isFundRequestLoading = false;
  bool get isFundRequestLoading => _isFundRequestLoading;

  bool _isFundPaginating = false;
  bool get isFundPaginating => _isFundPaginating;

  bool _hasMoreFundData = true;
  bool get hasMoreFundData => _hasMoreFundData;

  int _fundRequestPage = 1;

  Future<void> resetAndFetchFundRequests() async {
    _fundRequestList = [];
    _fundRequestPage = 1;
    _hasMoreFundData = true;
    await fetchFundRequests();
  }

  Future<void> fetchFundRequests({bool loadMore = false}) async {
    if (loadMore && (_isFundPaginating || !_hasMoreFundData)) return;

    if (loadMore) {
      _isFundPaginating = true;
    } else {
      _isFundRequestLoading = true;
    }

    notifyListeners();

    final map = {
      'page': _fundRequestPage.toString(),
    };

    ApiResponse response = await walletRepo.getFundRequestData(map);

    if (response.response != null &&
        response.response!.statusCode == 200 &&
        response.response!.data != null) {
      try {
        final List data = response.response!.data['fund_requests'] ?? [];
        final List<MyFundRequestModel> newList = data
            .map((json) => MyFundRequestModel.fromJson(json))
            .toList();

        if (loadMore) {
          _fundRequestList.addAll(newList);
        } else {
          _fundRequestList = newList;
        }

        _hasMoreFundData = newList.isNotEmpty;
        if (_hasMoreFundData) _fundRequestPage++;
      } catch (e) {
        _error = 'Failed to parse fund requests';
        print('⚠️ Fund request parsing error: $e');
      }
    } else {
      _error = response.error.toString();
    }

    _isFundRequestLoading = false;
    _isFundPaginating = false;
    notifyListeners();
  }

  Future<void> fundRequest({
    required String transactionNumber,
    required String paymentType,
    required String amount,
    required File transactionFile,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isFundRequestLoading = true;
    notifyListeners();

    final response = await walletRepo.submitFundRequestWithImage(
      transactionNumber: transactionNumber,
      paymentType: paymentType,
      amount: amount,
      transactionFile: transactionFile,
    );

    _isFundRequestLoading = false;

    if (response.response != null && response.response!.statusCode == 200) {
      onSuccess();
    } else {
      onError(response.error ?? 'Something went wrong!');
    }

    notifyListeners();
  }

  ///-----------------------Transaction to wallet
  Future<void> transferToTransactionWallet({
    required String amount,
    required String walletType,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    if (double.tryParse(amount) == null || double.parse(amount) < 10) {
      onError("Minimum transfer amount is \$10");
      return;
    }

    final map = {
      'amount': amount,
      'wallet_type': walletType,
    };

    try {
      ApiResponse response = await walletRepo.getWalletToTransaction(map);

      if (response.response != null && response.response!.statusCode == 200) {
        final res = response.response!.data;

        if (res['status'] == true) {
          onSuccess();
        } else {
          onError(res['message'] ?? 'Transfer failed');
        }
      } else {
        onError(response.error ?? 'Something went wrong!');
      }
    } catch (e) {
      onError('Unexpected error occurred');
    }

    notifyListeners();
  }


}
