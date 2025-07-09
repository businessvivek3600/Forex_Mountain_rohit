import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forex_mountain/utils/sizedbox_utils.dart';
import 'package:share_plus/share_plus.dart';
import '../../constants/assets_constants.dart';
import '../../database/functions.dart';
import '../../screens/dashboard/main_page.dart';
import '../../utils/color.dart';
import '../../utils/picture_utils.dart';
import '../../utils/text.dart';
import '../../utils/toasts.dart';
import '../../widgets/glass_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_CardData> cardItems = [
    _CardData("Maturity Wallet", Icons.account_balance, "\$0.00"),
    _CardData("Transaction Wallet", Icons.wallet, "\$1,600.00"),
    _CardData("Rank Income", Icons.military_tech, "\$0.00"),
    _CardData("FCT Income", Icons.generating_tokens, "\$0.00"),
    _CardData("MTP Income", Icons.trending_up, "\$0.00"),
    _CardData("SIP Income", Icons.stacked_line_chart, "\$0.00"),
    _CardData("Self Business", Icons.business_center, "\$0.00"),
    _CardData("Team Business", Icons.groups, "\$0.00"),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title:   bodyLargeText('DASHBOARD', context,fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body:Container(
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
    final List<_CardData> cardItems = [
      _CardData("Maturity Wallet", Icons.account_balance, "\$0.00"),
      _CardData("Transaction Wallet", Icons.wallet, "\$1,600.00"),
      _CardData("Rank Income", Icons.military_tech, "\$0.00"),
      _CardData("FCT Income", Icons.generating_tokens, "\$0.00"),
      _CardData("MTP Income", Icons.trending_up, "\$0.00"),
      _CardData("SIP Income", Icons.stacked_line_chart, "\$0.00"),
      _CardData("Self Business", Icons.business_center, "\$0.00"),
      _CardData("Team Business", Icons.groups, "\$0.00"),
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
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(item.icon, size: 28, color: Colors.white),
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
                        value: 0.7,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildTeamBuildingReferralLink(context),
          const SizedBox(height: 16),
          // Lifetime Earnings card
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lifetime Earnings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  '\$0.00',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
        ],
      ),
    );
  }
  Widget _buildTeamBuildingReferralLink(
      BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UiCategoryTitleContainer(
                child: bodyLargeText('Share your referral link', context)),
            width5(),
            GestureDetector(
                onTap: () => Share.share(createDeepLink(
                    sponsor: "01061978")),
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: assetSvg(Assets.share, color: Colors.white))),
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
                        onPressed: () async => await Clipboard.setData(ClipboardData(
                            text: "https://my.forexmountains.com/signup/"))
                            .then((_) => Toasts.showFToast(
                            context, 'Link copied to clipboard.',
                            icon: Icons.copy,
                            bgColor: appLogoColor.withOpacity(0.9))),
                        icon: const Icon(Icons.copy,
                            color: Colors.white, size: 15),
                      )
                    ],
                  ),
                ),
              ),
              width10(),
              GestureDetector(
                  onTap:  () =>
                      sendWhatsapp(text: "https://my.forexmountains.com/signup/"),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: assetSvg(Assets.whatsappColored, fit: BoxFit.cover),
                  )),
              width10(),
              GestureDetector(
                  onTap:  () =>
                      sendTelegram(text: 'https://my.forexmountains.com/signup/'),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      width: 40,
                      height: 40,
                      child:
                      assetSvg(Assets.telegramColored, fit: BoxFit.cover),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardData {
  final String title;
  final IconData icon;
  final String amount;

  _CardData(this.title, this.icon, this.amount);
}
