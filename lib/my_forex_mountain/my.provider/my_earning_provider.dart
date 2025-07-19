import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/repositories/my_earning_repo.dart';

import '../my.model/my_payout_model.dart';
import '../my.model/my_withdraw_invoice.dart';
import '../my.model/my_withdraw_model.dart';


class MyEarningProvider with ChangeNotifier {
  final MyEarningRepo earningRepo;
  MyEarningProvider({required this.earningRepo});

  bool _isFirstLoad = false;
  bool _isPaginating = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _currentSlug;
  String? _errorMessage;
  List<dynamic> _earnings = [];

  bool get isFirstLoad => _isFirstLoad;
  bool get isPaginating => _isPaginating;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  List<dynamic> get earnings => _earnings;

  void resetEarnings(String slug) {
    _earnings = [];
    _currentPage = 1;
    _hasMore = true;
    _currentSlug = slug;
    notifyListeners();
  }

  ///Payout variable
  List<MyPayoutModel> _payouts = [];
  bool _isFirstLoadPayout = false;
  bool _isPaginatingPayout = false;
  bool _hasMorePayout = true;
  int _currentPayoutPage = 1;
  String? _payoutErrorMessage;

  List<MyPayoutModel> get payouts => _payouts;
  bool get isFirstLoadPayout => _isFirstLoadPayout;
  bool get isPaginatingPayout => _isPaginatingPayout;
  bool get hasMorePayout => _hasMorePayout;
  String? get payoutErrorMessage => _payoutErrorMessage;

  void resetPayouts() {
    _payouts = [];
    _currentPayoutPage = 1;
    _hasMorePayout = true;
    notifyListeners();
  }
///Withdraw List variable
  List<MyWithdrawRequestModel> _withdrawRequests = [];
  bool _isFirstLoadWithdraw = false;
  bool _isPaginatingWithdraw = false;
  bool _hasMoreWithdraw = true;
  int _currentWithdrawPage = 1;
  String? _withdrawErrorMessage;

  List<MyWithdrawRequestModel> get withdrawRequests => _withdrawRequests;
  bool get isFirstLoadWithdraw => _isFirstLoadWithdraw;
  bool get isPaginatingWithdraw => _isPaginatingWithdraw;
  bool get hasMoreWithdraw => _hasMoreWithdraw;
  String? get withdrawErrorMessage => _withdrawErrorMessage;

  void resetWithdrawRequests() {
    _withdrawRequests = [];
    _currentWithdrawPage = 1;
    _hasMoreWithdraw = true;
    notifyListeners();
  }

///Invoice Data Fetching
  InvDetail? _invoiceDetail;
  bool _isLoadingInvoice = false;
  String? _invoiceError;

  InvDetail? get invoiceDetail => _invoiceDetail;
  bool get isLoadingInvoice => _isLoadingInvoice;
  String? get invoiceError => _invoiceError;

  ///----------------------Bonus and Earnings Data Fetching----------------------///
  Future<void> fetchEarningsData({bool loadMore = false}) async {
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
        'slug': _currentSlug ?? '',
      };

      final response = await earningRepo.getCEarningData(map);

      if (response.response?.statusCode == 200) {
        final responseData = response.response?.data;

        if (responseData != null &&
            responseData['data'] != null &&
            responseData['data']['result'] != null) {
          final List<dynamic> result = responseData['data']['result'];

          if (loadMore) {
            _earnings.addAll(result);
          } else {
            _earnings = result;
          }

          _hasMore = result.isNotEmpty;
          if (_hasMore) _currentPage++;
        } else {
          _hasMore = false;
        }
      } else {
        _errorMessage = 'Failed to fetch earnings';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isFirstLoad = false;
      _isPaginating = false;
      notifyListeners();
    }
  }
  ///----------------------Payout Data Fetching----------------------///
  Future<void> fetchPayoutData({bool loadMore = false}) async {
    if (loadMore && (_isPaginatingPayout || !_hasMorePayout)) return;
    if (!loadMore && _isFirstLoadPayout) return;

    if (loadMore) {
      _isPaginatingPayout = true;
    } else {
      _isFirstLoadPayout = true;
    }

    _payoutErrorMessage = null;
    notifyListeners();

    try {
      final map = {
        'page': _currentPayoutPage.toString(),
      };

      final response = await earningRepo.getPayOut(map);

      if (response.response?.statusCode == 200) {
        final responseData = response.response?.data;
        final List<dynamic> result = responseData?['data']?['payout'] ?? [];

        final newList = result.map((e) => MyPayoutModel.fromJson(e)).toList();

        if (loadMore) {
          _payouts.addAll(newList);
        } else {
          _payouts = newList;
        }

        _hasMorePayout = newList.isNotEmpty;
        if (_hasMorePayout) _currentPayoutPage++;
      } else {
        _payoutErrorMessage = 'Failed to fetch payout';
      }
    } catch (e) {
      _payoutErrorMessage = 'Error: $e';
    } finally {
      _isFirstLoadPayout = false;
      _isPaginatingPayout = false;
      notifyListeners();
    }
  }


  ///----------------------Withdraw Request Data Fetching----------------------///
  Future<void> fetchWithdrawRequests({bool loadMore = false}) async {
    if (loadMore && (_isPaginatingWithdraw || !_hasMoreWithdraw)) return;
    if (!loadMore && _isFirstLoadWithdraw) return;

    if (loadMore) {
      _isPaginatingWithdraw = true;
    } else {
      _isFirstLoadWithdraw = true;
    }

    _withdrawErrorMessage = null;
    notifyListeners();

    try {
      final map = {
        'page': _currentWithdrawPage.toString(),
      };

      final response = await earningRepo.getWithdrawList(map);

      if (response.response?.statusCode == 200) {
        final List<dynamic> result = response.response?.data['data'] ?? [];
        final newList = result.map((e) => MyWithdrawRequestModel.fromJson(e)).toList();

        if (loadMore) {
          _withdrawRequests.addAll(newList);
        } else {
          _withdrawRequests = newList;
        }

        _hasMoreWithdraw = newList.isNotEmpty;
        if (_hasMoreWithdraw) _currentWithdrawPage++;
      } else {
        _withdrawErrorMessage = 'Failed to fetch withdraw list';
      }
    } catch (e) {
      _withdrawErrorMessage = 'Error: $e';
    } finally {
      _isFirstLoadWithdraw = false;
      _isPaginatingWithdraw = false;
      notifyListeners();
    }
  }
  ///----------------------Invoice Data Fetching----------------------///
  Future<void> fetchInvoice(String id) async {
    _isLoadingInvoice = true;
    _invoiceError = null;
    notifyListeners();

    try {
      final resp = await earningRepo.getWithdrawInvoice({'id': id});
      if (resp.response?.statusCode == 200) {
        final data = resp.response?.data;
        final invJson = data?['inv'];
        if (invJson != null) {
          _invoiceDetail = InvDetail.fromJson(invJson);
        } else {
          _invoiceError = 'No invoice data returned';
        }
      } else {
        _invoiceError = 'Invoice request failed';
      }
    } catch (e) {
      _invoiceError = 'Error fetching invoice: $e';
    } finally {
      _isLoadingInvoice = false;
      notifyListeners();
    }
  }
}




