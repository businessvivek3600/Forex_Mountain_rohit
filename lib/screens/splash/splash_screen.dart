import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:forex_mountain/database/my_notification_setup.dart';
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, this.controller}) : super(key: key);
  static const String routeName = '/SplashScreen';
  final VideoPlayerController? controller;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String tag = 'Splash Screen';
  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  int duration = 0;
  int position = 0;
  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    initController(); // <-- This initializes _controller

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PlatformSelectionScreen()),
      );
    });
  }

  void initController() {
    _controller = VideoPlayerController.asset('assets/videos/1_1.mp4')
      ..initialize().then((_) {
        _controller.play();
        duration = _controller.value.duration.inMilliseconds;
      });
    _controller.addListener(_listner);
  }

  void _listner() {
    setState(() {});
    if (_controller.value.hasError) {
      errorLog('video error: ${_controller.value.errorDescription}', tag,
          'initState');
    }
    if (_controller.value.isInitialized) {
      duration = _controller.value.duration.inMilliseconds;
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    _controller.removeListener(_listner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  Stack buildBody() {
    return Stack(
      children: [
        Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: mainColor,
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller))
              : Container(),
        ),
      ],
    );
  }

}
