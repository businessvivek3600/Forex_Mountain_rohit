import 'package:flutter/material.dart';

import '../../utils/color.dart';
import 'earning/earning_screen.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';
import 'wallet/wallet_screen.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const EarningScreen(),
    const WalletScreen(),
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: mainColor900,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            final  isSelected = _currentIndex == index;

            final icons = [
              [Icons.home_outlined, Icons.home_rounded, 'Home'],
              [Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Earnings'],
              [
                Icons.account_balance_wallet_outlined,
                Icons.account_balance_wallet_rounded,
                'Wallet'
              ],
              [Icons.person_outline, Icons.person_rounded, 'Profile'],
            ];

            return GestureDetector(
              onTap: () => setState(() => _currentIndex = index),
              behavior: HitTestBehavior.translucent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isSelected
                      ? GradientIcon(
                          icon: icons[index][1] as IconData,
                          gradientColors: textGradiantColors,
                          size: 26)
                      : Icon(icons[index][0] as IconData,
                          size: 24, color: Colors.grey[500]),
                  const SizedBox(height: 4),
                  isSelected
                      ? GradientText(
                          text: icons[index][2] as String,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                          gradientColors: textGradiantColors,
                        )
                      : Text(
                          icons[index][2] as String,
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500]),
                        ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final List<Color> gradientColors;

  const GradientIcon({
    super.key,
    required this.icon,
    this.size = 24,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: gradientColors,
        ).createShader(bounds);
      },
      child: Icon(icon, size: size),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> gradientColors;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(colors: gradientColors).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
