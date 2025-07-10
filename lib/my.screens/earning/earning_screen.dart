import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/color.dart';
import '../../utils/picture_utils.dart';
import '../../utils/text.dart';
import '../../widgets/glass_card.dart';
import 'widget/glass_card_tile.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Iconsax.element_4, color: Colors.amber),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: bodyLargeText('EARNING', context, fontSize: 20),
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
                  // Lifetime Earnings card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lifetime Earnings',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '\$0.00',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Image.asset(
                            'assets/images/earning.png', // Replace with your image
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.amber),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {},
                                child: const Text('Fund/Request'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.amber),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {},
                                child: const Text('Withdraw'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GlassCardTile(
                    icon: Iconsax.wallet,
                    label: "Payout",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.money_send,
                    label: "Direct Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.crown,
                    label: "Rank Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.bitcoin_card,
                    label: "FCT Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.trend_up,
                    label: "MTP Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.activity,
                    label: "SIP Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.user_add,
                    label: "FCT Referral Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),

                  GlassCardTile(
                    icon: Iconsax.hierarchy,
                    label: "Level Bonus",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),
                  GlassCardTile(
                    icon: Iconsax.receipt_2,
                    label: "Withdraw Request",
                    onTap: () {
                      // Navigate or handle tap
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
