import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/color.dart';
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
        title: const Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: HomeDashboard(),
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

    return GridView.builder(
      itemCount: cardItems.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
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
    );
  }
}

class _CardData {
  final String title;
  final IconData icon;
  final String amount;

  _CardData(this.title, this.icon, this.amount);
}
