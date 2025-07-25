import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.screens/drawer/custom_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';

import '../../my.provider/my_dashboard_provider.dart';
import '../../widgets/glass_card.dart';

import 'component/my_bonus_screen.dart';
import 'component/payout_screen.dart';
import 'component/withdraw_request_history.dart';
import 'widget/glass_card_tile.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDashboardProvider>(
        builder: (context, dashboardProvider, _) {
          final memberSale = dashboardProvider.dashboardData?.memberSale;
          final lifeTimeEarnings = double.tryParse(memberSale?.incomeTotal ?? '0') ?? 0;
        return Scaffold(
          key: _scaffoldKey, // Add the key
          backgroundColor: mainColor,
          drawer: const CustomAppDrawer(),
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Iconsax.element_4, color: Colors.amber),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            title: bodyLargeText('EARNINGS', context, fontSize: 20),
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
                         Text(
                              '\$${lifeTimeEarnings.toStringAsFixed(2)}',
                              style: const TextStyle(
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
                            // const SizedBox(height: 16),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: OutlinedButton(
                            //         style: OutlinedButton.styleFrom(
                            //           side: const BorderSide(color: Colors.amber),
                            //           foregroundColor: Colors.white,
                            //           padding:
                            //               const EdgeInsets.symmetric(vertical: 12),
                            //         ),
                            //         onPressed: () {
                            //         },
                            //         child: const Text('Fund/Request'),
                            //       ),
                            //     ),
                            //     const SizedBox(width: 12),
                            //     Expanded(
                            //       child: OutlinedButton(
                            //         style: OutlinedButton.styleFrom(
                            //           side: const BorderSide(color: Colors.amber),
                            //           foregroundColor: Colors.white,
                            //           padding:
                            //               const EdgeInsets.symmetric(vertical: 12),
                            //         ),
                            //         onPressed: () {},
                            //         child: const Text('Withdraw'),
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GlassCardTile(
                        icon: Iconsax.wallet,
                        label: "Payout",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PayoutScreen(),
                            ),
                          );
                        },
                      ),

                      GlassCardTile(
                        icon: Iconsax.money_send,
                        label: "Direct Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'Direct Bonus',
                                notePrefix: 'Direct Bonus',

                              ),
                            ),
                          );
                        },
                      ),
                      GlassCardTile(
                        icon: Iconsax.crown,
                        label: "Rank Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'Rank Bonus',
                                notePrefix: 'Rank Bonus',

                              ),
                            ),
                          );
                        },
                      ),

                      GlassCardTile(
                        icon: Iconsax.bitcoin_card,
                        label: "FCT Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'FCT Bonus',
                                notePrefix: 'FCT Bonus',

                              ),
                            ),
                          );
                        },
                      ),
                      GlassCardTile(
                        icon: Iconsax.trend_up,
                        label: "MTP Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'MTP Bonus',
                                notePrefix: 'MTP Bonus',

                              ),
                            ),
                          );
                        },
                      ),

                      GlassCardTile(
                        icon: Iconsax.activity,
                        label: "SIP Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'SIP Bonus',
                                notePrefix: 'SIP Bonus',

                              ),
                            ),
                          );
                        },
                      ),
                      GlassCardTile(
                        icon: Iconsax.user_add,
                        label: "FCT Referral Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'FCT Referral Bonus',
                                notePrefix: 'FCT Referral Bonus',
                              ),
                            ),
                          );
                        },
                      ),

                      GlassCardTile(
                        icon: Iconsax.hierarchy,
                        label: "Level Bonus",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BonusScreen(
                                title: 'Level Bonus',
                                notePrefix: 'Level Bonus',

                              ),
                            ),
                          );
                        },
                      ),
                      GlassCardTile(
                        icon: Iconsax.receipt_2,
                        label: "Withdraw Request",
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawRequestScreen(

                         )

                          ));
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
    );
  }
}
