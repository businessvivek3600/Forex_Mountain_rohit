import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  Future<bool> get isConnected async {
    // Check connectivity and return the result directly
    final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    bool isOnline = true;
    print('NetworkInfo ---> isConnected $isOnline');
    return isOnline;
  }

  void checkConnectivity(BuildContext context) {
    bool _firstTime = true;

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result ) {
      bool isOnline = result != ConnectivityResult.none;
      print('You are ${isOnline ? 'Online' : 'Offline'}');

      if (!_firstTime) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isOnline ? Colors.green : Colors.red,
          duration: Duration(seconds: isOnline ? 3 : 6000),
          content: Text(
            isOnline ? "You are connected" : "You don't have internet connection",
            textAlign: TextAlign.center,
          ),
        ));
      }

      _firstTime = false;
    });

    // Call the method to check connectivity
    isConnected.then((connected) {
      print('NetworkInfo ---> checkConnectivity  $connected');
    });
  }

  static Future<bool> _updateConnectivityStatus() async {
    bool _isConnected = false;
    try {
      final List<InternetAddress> _result = await InternetAddress.lookup('google.com');
      if (_result.isNotEmpty && _result[0].rawAddress.isNotEmpty) {
        _isConnected = true;
      }
    } catch (e) {
      _isConnected = false;
    }
    return _isConnected;
  }
}
