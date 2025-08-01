import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:forex_mountain/constants/assets_constants.dart';
import 'package:forex_mountain/my_forex_mountain/my.provider/my_auth_provider.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../platform_selection.dart';
import '../../utils/my_logger.dart';
import '/utils/app_lock_authentication.dart';
import '/database/repositories/settings_repo.dart';
import '/providers/auth_provider.dart';
import '/screens/auth/login_screen.dart';
import '/screens/auth/sign_up_screen.dart';
import '/screens/dashboard/main_page.dart';
import '/sl_container.dart';
import '/utils/color.dart';
import '/utils/default_logger.dart';
import '/utils/network_info.dart';
import 'package:video_player/video_player.dart';
import '../../database/functions.dart';
import 'constants/app_constants.dart';
import 'database/my_notification_setup.dart';
import 'my_forex_mountain/my.screens/main_screen.dart';
import 'my_forex_mountain/my.screens/my.auth/my_login_screen.dart';
import 'utils/picture_utils.dart';
import 'utils/sizedbox_utils.dart';

class PlatformSelectionScreen extends StatefulWidget {
  const PlatformSelectionScreen({super.key});

  @override
  State<PlatformSelectionScreen> createState() =>
      _PlatformSelectionScreenState();
}

class _PlatformSelectionScreenState extends State<PlatformSelectionScreen> {
  static const String tag = 'Platform Selection';
  StreamSubscription<Map>? streamSubscription;

  @override
  void initState() {
    super.initState();
    _initializePlatformScreen();
  }

  void _initializePlatformScreen() {
    // Init network & auth data
    sl.get<NetworkInfo>().checkConnectivity(context);
    sl.get<AuthProvider>().getSignUpInitialData();
    _listenDynamicLinks();
    final authProvider = Provider.of<NewAuthProvider>(context, listen: false);
    authProvider.initAuth();

  }

  Future<void> _listenDynamicLinks() async {
    await FlutterBranchSdk.init();
    streamSubscription = FlutterBranchSdk.initSession().listen((data) async {
      var authProvider = sl.get<AuthProvider>();
      bool isLogin = authProvider.isLoggedIn();
      var user = await authProvider.getUser();
      try {
        if (data['~referring_link'] != null || data['+non_branch_link'] != null) {
          Uri uri = Uri.parse(data['~referring_link'] ?? data['+non_branch_link']);
          var queryParams = uri.queryParameters;

          if ((uri.path == SignUpScreen.routeName || uri.path == '/refCode') && !isLogin) {
            String? sponsor = queryParams['sponsor'];
            String? placement = queryParams['placement'];
            Get.to(SignUpScreen(sponsor: sponsor, placement: placement));
          } else if (_authorizedRoutes(uri.path) && isLogin) {
            selectNotificationStream.add(jsonEncode(queryParams));
          }
        }
      } catch (e) {
        logger.e('listenDynamicLinks - error: ', error: e, tag: '$tag listenDynamicLinks');
      }
    });
  }

  bool _authorizedRoutes(String path) {
    List<String> authorizedRoutes = [
      '/dashboard', '/subscription', '/eventTickets', '/notification',
      '/inbox', '/support', '/teamView', '/commissionWallet', '/voucher',
      '/cardPayment', '/gallery', '/cashWallet', '/companyTradeIdeas',
      '/forgotPassword', '/updateApp', '/ytLive'
    ];
    return authorizedRoutes.contains(path);
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }


  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              height100(height * 0.1),
              buildHeader(height, context),
              height100(height * 0.05),
              _buildCustomButton(
                context,
                title: "Education",
                icon: Icons.school,
                onPressed: () {
                  sl.get<NetworkInfo>().checkConnectivity(context);
                  sl.get<AuthProvider>().getSignUpInitialData();

                  // Wait for a delay (e.g., 3 seconds or 2960 milliseconds as in your video)
                  Future.delayed(const Duration(milliseconds: 1000), () {
                    _checkLoginAndNavigate();
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildCustomButton(
                context,
                title: "Economic",
                icon: Icons.attach_money,
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final isLoggedIn = prefs.getBool(SPConstants.isLogin) ?? false;

                    if (isLoggedIn) {
                      // User is already logged in, navigate to MainPage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MyMainPage()),
                      );
                    } else {
                      // Not logged in, go to login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MyLoginScreen()),
                      );
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
  _checkLoginAndNavigate() async {
    var authProvider = sl.get<AuthProvider>();
    bool isLogin = authProvider.isLoggedIn();

    if (!isLogin) {
      Get.offAll(const LoginScreen());
    } else {
      var user = await authProvider.getUser();
      if (user != null) {
        authProvider.userData = user;
        authProvider.authRepo.saveUserToken(
            authProvider.authRepo.getUserToken());
        bool isBiometric = sl.get<SettingsRepo>().getBiometric();
        if (isBiometric) {
          AppLockAuthentication.authenticate().then((value) {
            if (value[0] == AuthStatus.available) {
              if (value[1] == AuthStatus.success) {
                Get.offAll(MainPage());
              } else {
                exitTheApp();
              }
            } else {
              Get.offAll(MainPage());
            }
          });
        } else {
          Get.offAll(MainPage());
        }
      } else {
        logOut('PlatformSelection');
        Get.offAll(const LoginScreen());
      }
    }

    // Optionally, you can still listen to dynamic links if needed.
    _listenDynamicLinks(); // Or call your appropriate dynamic links handler.
  }


  Widget _buildCustomButton(BuildContext context,
      {required String title,
        required IconData icon,
        required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.withOpacity(0.2), Colors.orangeAccent.withOpacity(0.2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Column buildHeader(double height, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: assetImages(
          Assets.appWebLogo,
            width: double.maxFinite,
            height: height * 0.1,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
