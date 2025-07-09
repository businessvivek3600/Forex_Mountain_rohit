import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/color.dart';
import '../../utils/picture_utils.dart';
import '../../utils/text.dart';
import 'widget/wallet_tab_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.element_4, color: Colors.amber),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: bodyLargeText('WALLET', context, fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    WalletTabButton(
                      label: 'Transaction',
                      isSelected: _selectedTabIndex == 0,
                      onTap: () => setState(() => _selectedTabIndex = 0),
                      context: context,
                    ),
                    const SizedBox(width: 16),
                    WalletTabButton(
                      label: 'Maturity',
                      isSelected: _selectedTabIndex == 1,
                      onTap: () => setState(() => _selectedTabIndex = 1),
                      context: context,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Example content based on tab
                _selectedTabIndex == 0
                    ? const Text('Transaction Wallet Content', style: TextStyle(color: Colors.white))
                    : const Text('Maturity Wallet Content', style: TextStyle(color: Colors.white)),

              ],
            )),
          ),
        ),
      ),
    );
  }
}
