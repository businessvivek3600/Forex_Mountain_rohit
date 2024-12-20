import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdProvider {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Retrieves the device ID based on the platform.
  Future<String> getDeviceId() async {
    try {
      if (kIsWeb) {
        return await _getWebDeviceId();
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            return await _getAndroidDeviceId();
          case TargetPlatform.iOS:
            return await _getIosDeviceId();
          case TargetPlatform.windows:
            return await _getWindowsDeviceId();
          case TargetPlatform.macOS:
            return await _getMacOsDeviceId();
          case TargetPlatform.linux:
            return await _getLinuxDeviceId();
          case TargetPlatform.fuchsia:
            return 'Fuchsia devices are currently unsupported';
          default:
            return 'Unsupported platform';
        }
      }
    } on PlatformException {
      return 'Failed to retrieve device ID';
    }
  }

  /// Android: Retrieves the unique device ID (e.g., Android ID).
  Future<String> _getAndroidDeviceId() async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    return androidInfo.id ??
        androidInfo.hardware ??
        'Unknown Android Device ID';
  }

  /// iOS: Retrieves the unique device ID (e.g., Identifier for Vendor).
  Future<String> _getIosDeviceId() async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor ?? 'Unknown iOS Device ID';
  }

  /// Web: Retrieves a browser-specific identifier, if available.
  Future<String> _getWebDeviceId() async {
    final webInfo = await _deviceInfoPlugin.webBrowserInfo;
    return webInfo.userAgent ?? 'Unknown Web Device ID';
  }

  /// Windows: Retrieves the device ID on Windows.
  Future<String> _getWindowsDeviceId() async {
    final windowsInfo = await _deviceInfoPlugin.windowsInfo;
    return windowsInfo.deviceId ?? 'Unknown Windows Device ID';
  }

  /// macOS: Retrieves the device ID on macOS.
  Future<String> _getMacOsDeviceId() async {
    final macInfo = await _deviceInfoPlugin.macOsInfo;
    return macInfo.systemGUID ?? 'Unknown macOS Device ID';
  }

  /// Linux: Retrieves the device ID on Linux.
  Future<String> _getLinuxDeviceId() async {
    final linuxInfo = await _deviceInfoPlugin.linuxInfo;
    return linuxInfo.machineId ?? 'Unknown Linux Device ID';
  }
}


  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String? identifier;

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;

        identifier = build.device; // UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; // UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    return identifier;
  }

