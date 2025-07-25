import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/glass_card.dart';
import '../my.auth/my_login_screen.dart';
import 'package:iconsax/iconsax.dart';

import 'dart:ui';

// make sure the path is correct

Future<bool> handleSessionExpired(BuildContext context, dynamic responseData) async {
  final isLogin = responseData?['is_login'];

  if (isLogin == 0) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4), // backdrop dim
      builder: (_) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 24),
        child: GlassCard(
          borderRadius: 20,
          blurSigma: 12,
          padding: EdgeInsets.all(24),
          gradientColors: [
            Color.fromRGBO(255, 255, 255, 0.2),
            Color.fromRGBO(255, 0, 0, 0.1),
          ],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.warning_2, size: 48, color: Colors.redAccent),
              SizedBox(height: 16),
              Text(
                "Session Expired",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "You will be redirected to the login screen shortly.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      ),
    );

    // Delay for 2 seconds and redirect to login
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.of(context, rootNavigator: true).pop(); // Close dialog

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyLoginScreen()),
            (route) => false,
      );
    });

    return true;
  }

  return false;
}
