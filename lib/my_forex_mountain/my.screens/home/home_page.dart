import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:forex_mountain/utils/sizedbox_utils.dart';
import 'package:forex_mountain/widgets/customDrawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/assets_constants.dart';
import '../../../database/functions.dart';
import '../../../screens/dashboard/main_page.dart';
import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../utils/toasts.dart';
import '../../my.provider/my_dashboard_provider.dart';
import '../../widgets/glass_card.dart';
import '../drawer/custom_drawer.dart';
import '../drawer/packages/packages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    // Delay to ensure context is available
    Future.delayed(Duration.zero, () {
      final dashboardProvider =
          Provider.of<MyDashboardProvider>(context, listen: false);
      dashboardProvider.getDashboardData();
      dashboardProvider.getBankDetails(

      );
      dashboardProvider.getCompanyInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: bodyLargeText('DASHBOARD', context, fontSize: 20),
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
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: HomeDashboard(),
          ),
        ),
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyDashboardProvider>(
        builder: (context, dashboardProvider, _) {
          final dashboardData = dashboardProvider.dashboardData;

          // Show shimmer while loading
          if (dashboardData == null) {
            return _buildShimmerPlaceholder();
          }
      final memberSale = dashboardProvider.dashboardData?.memberSale;
      final customer = dashboardProvider.dashboardData?.customer;

      final incomeSip = double.tryParse(memberSale?.incomeSip ?? '0') ?? 0;
      final incomeMaturity =
          double.tryParse(memberSale?.balCommission ?? '0') ?? 0;
      final incomeTransaction =
          double.tryParse(memberSale?.balTransaction ?? '0') ?? 0;
      final incomeRank = double.tryParse(memberSale?.incomeRank ?? '0') ?? 0;
      final incomeFct = double.tryParse(memberSale?.incomeFct ?? '0') ?? 0;
      final incomeMtp = double.tryParse(memberSale?.incomeMtp ?? '0') ?? 0;
      final incomeSelfBusiness =
          double.tryParse(memberSale?.selfSale ?? '0') ?? 0;
      final incomeTeamBusiness =
          double.tryParse(memberSale?.teamSale ?? '0') ?? 0;
      final lifeTimeEarnings =
          double.tryParse(memberSale?.incomeTotal ?? '0') ?? 0;

      final List<_CardData> cardItems = [
        _CardData("Maturity Wallet", Iconsax.wallet_check, "\$${incomeMaturity.toStringAsFixed(2)}"),
        _CardData("Transaction Wallet", Iconsax.wallet_3, "\$${incomeTransaction.toStringAsFixed(2)}"),
        _CardData("Rank Income", Iconsax.medal_star, "\$${incomeRank.toStringAsFixed(2)}"),
        _CardData("FCT Income", Iconsax.graph, "\$${incomeFct.toStringAsFixed(2)}"),
        _CardData("MTP Income", Iconsax.trend_up, "\$${incomeMtp.toStringAsFixed(2)}"),
        _CardData("SIP Income", Iconsax.chart_2, "\$${incomeSip.toStringAsFixed(2)}"),
      ];


      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            height20(),
            GridView.builder(
              shrinkWrap: true,
              itemCount: cardItems.length,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final item = cardItems[index];
                final rawAmount =
                    double.tryParse(item.amount.replaceAll('\$', '')) ?? 0;

// Determine max income among all for scaling (or set a static max)
                final maxIncome = [
                  incomeMaturity,
                  incomeTransaction,
                  incomeRank,
                  incomeFct,
                  incomeMtp,
                  incomeSip,
                  incomeSelfBusiness,
                ].reduce((a, b) => a > b ? a : b);

// Calculate progress safely
                final progress = maxIncome > 0
                    ? (rawAmount / maxIncome).clamp(0.0, 1.0)
                    : 0.0;
                return GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item.icon, size: 28, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        item.amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.15),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildTeamBuildingReferralLink(context, customer!.username),
            const SizedBox(height: 16),

            /// Lifetime Earnings card
            // GlassCard(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Lifetime Earnings',
            //         style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         '\$${lifeTimeEarnings.toStringAsFixed(2)}', // Example usage again
            //         style: const TextStyle(
            //             fontSize: 24,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.white),
            //       ),
            //       const SizedBox(height: 16),
            //       Center(
            //         child: Image.asset(
            //           'assets/images/earning.png',
            //           height: 100,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: OutlinedButton(
            //               style: OutlinedButton.styleFrom(
            //                 side: const BorderSide(color: Colors.amber),
            //                 foregroundColor: Colors.white,
            //                 padding: const EdgeInsets.symmetric(vertical: 12),
            //               ),
            //               onPressed: () {},
            //               child: const Text('Fund/Request'),
            //             ),
            //           ),
            //           const SizedBox(width: 12),
            //           Expanded(
            //             child: OutlinedButton(
            //               style: OutlinedButton.styleFrom(
            //                 side: const BorderSide(color: Colors.amber),
            //                 foregroundColor: Colors.white,
            //                 padding: const EdgeInsets.symmetric(vertical: 12),
            //               ),
            //               onPressed: () {},
            //               child: const Text('Withdraw'),
            //             ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 16),

            /// Additional balance cards
            Column(
              children: [
                _buildBalanceCard(
                  context,
                  'Self Business',
                  '\$${incomeSelfBusiness.toStringAsFixed(2)}',
                  Iconsax.building,
                ),
                const SizedBox(height: 12),
                _buildBalanceCard(
                  context,
                  'Team Business',
                  '\$${incomeTeamBusiness.toStringAsFixed(2)}',
                  Iconsax.people,
                ),
                const SizedBox(height: 12),
                _buildBalanceCard(
                  context,
                  'Total Members',
                  "${memberSale?.activeTotalMember}/${memberSale?.totalMember}" ?? '0',
                  Iconsax.user_cirlce_add,
                ),
                const SizedBox(height: 12),
                _buildBalanceCard(
                  context,
                  'Direct Members',
                  "${memberSale?.directMember}/${memberSale?.activeDirectMember}" ?? '0',
                  Iconsax.user_octagon,
                ),
              ],
            ),

          ],
        ),
      );
    });
  }

  Widget _buildBalanceCard(
      BuildContext context, String title, String amount, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: Colors.amber, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamBuildingReferralLink(BuildContext context, String sponsor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UiCategoryTitleContainer(
              child: bodyLargeText('Share your referral link', context),
            ),
            width5(),
            GestureDetector(
              onTap: () => Share.share(createDeepLink(sponsor: sponsor)),
              child: SizedBox(
                width: 30,
                height: 30,
                child: assetSvg(Assets.share, color: Colors.white),
              ),
            ),
          ],
        ),
        height10(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                        child: capText(
                          "https://my.forexmountains.com/signup/",
                          context,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(const ClipboardData(
                              text: "https://my.forexmountains.com/signup/"));
                          Toasts.showFToast(
                            context,
                            'Link copied to clipboard.',
                            icon: Icons.copy,
                            bgColor: appLogoColor.withOpacity(0.9),
                          );
                        },
                        icon: const Icon(Icons.copy,
                            color: Colors.white, size: 15),
                      )
                    ],
                  ),
                ),
              ),
              width10(),
              GestureDetector(
                onTap: () =>
                    sendWhatsapp(text: "https://my.forexmountains.com/signup/"),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: assetSvg(Assets.whatsappColored, fit: BoxFit.cover),
                ),
              ),
              width10(),
              GestureDetector(
                onTap: () =>
                    sendTelegram(text: 'https://my.forexmountains.com/signup/'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: assetSvg(Assets.telegramColored, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
Widget _buildShimmerPlaceholder() {
  return SingleChildScrollView(
    child: Column(
      children: [
        height20(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (_, __) => GlassCard(
            child: Shimmer.fromColors(
              baseColor: Colors.white10,
              highlightColor: Colors.white24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, width: 80, color: Colors.white),
                  const Spacer(),
                  Container(height: 18, width: 100, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 4, width: double.infinity, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GlassCard(
          child: Shimmer.fromColors(
            baseColor: Colors.white10,
            highlightColor: Colors.white24,
            child: Container(height: 180, width: double.infinity, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          3,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Shimmer.fromColors(
                baseColor: Colors.white10,
                highlightColor: Colors.white24,
                child: Row(
                  children: [
                    Container(width: 48, height: 48, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(height: 14, width: 100, color: Colors.white),
                          const SizedBox(height: 4),
                          Container(height: 16, width: 150, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(height: 4, width: double.infinity, color: Colors.white),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CardData {
  final String title;
  final IconData icon;
  final String amount;

  _CardData(this.title, this.icon, this.amount);
}
