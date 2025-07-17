import 'package:flutter/material.dart';
import 'package:forex_mountain/constants/assets_constants.dart';

import 'my.screens/drawer/my_login_screen.dart';
import 'my.screens/main_screen.dart';
import 'utils/picture_utils.dart';
import 'utils/sizedbox_utils.dart';

class PlatformSelectionScreen extends StatefulWidget {
  const PlatformSelectionScreen({super.key});

  @override
  State<PlatformSelectionScreen> createState() =>
      _PlatformSelectionScreenState();
}

class _PlatformSelectionScreenState extends State<PlatformSelectionScreen> {
  @override
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
                  // TODO: Navigate or perform action
                },
              ),
              const SizedBox(height: 20),
              _buildCustomButton(
                context,
                title: "Economic",
                icon: Icons.attach_money,
                onPressed: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginScreen(),));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 26, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        side: const BorderSide(color: Colors.white70, width: 1),
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
