import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:forex_mountain/widgets/transparent_container.dart';

import '../../../screens/dashboard/main_page.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import 'buy_packages.dart';

class PackagesScreen extends StatelessWidget {
  final List<MtpPackage> packages = [
    MtpPackage(amount: '15,733.00', imagePath: 'assets/images/pack-2.png'),
    MtpPackage(amount: '4,000.00', imagePath: 'assets/images/pack-2.png'),
    MtpPackage(amount: '10,000.00', imagePath: 'assets/images/pack-2.png'),
    MtpPackage(amount: '2,500.00', imagePath: 'assets/images/pack-2.png'),
  ];

  final List<PackageOrder> orders = [
    PackageOrder(
      orderId: '1555',
      amount: 15733,
      createdDate: '2025-06-05 23:26:33',
      nextReward: '2025-08-05 (\$786.65)',
      status: 'Running',
    ),
    PackageOrder(
      orderId: '1557',
      amount: 4000,
      createdDate: '2025-06-06 22:15:32',
      nextReward: '2025-08-06 (\$200)',
      status: 'Running',
    ),
  ];
  PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: userAppBgImageProvider(context),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: bodyLargeText('Packages', context, fontSize: 20),
          elevation: 0,
          actions: [

            IconButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BuyPackageScreen()),
              );
            }, icon:const Icon(Icons.add_shopping_cart, color: Colors.amber),),
            const SizedBox(width: 20,),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true, // ✅ important!
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: packages.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.03,
                    ),
                    itemBuilder: (context, index) {
                      return _buildMtpCard(packages[index]);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Table Section
                  const UiCategoryTitleContainer(
                    child: Row(
                      children: [
                        Text(
                          'Your Packages',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true, // ✅ important!
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order ID and Amount
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Order #${order.orderId}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text("\$${order.amount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Info Grid: 2-column layout
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start, // Ensures top alignment
                                children: [
                                  // Left Column
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const _InfoText(title: "Info", value: "MTP Plan"),
                                      const SizedBox(height: 6),
                                      _InfoText(title: "Created", value: order.createdDate),
                                    ],
                                  ),
                                  // Right Column
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const _InfoText(title: "Payment", value: "Transaction Wallet"),
                                      const SizedBox(height: 6),
                                      _InfoText(title: "Next Reward", value: order.nextReward),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Status and Withdraw button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      order.status,
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(Icons.arrow_downward, size: 16),
                                    label: const Text("Withdraw"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      ;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMtpCard(MtpPackage pkg) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Package Amount : ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '\$${pkg.amount}',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              pkg.imagePath,
              width: 60,
              height: 60 ,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class MtpPackage {
  final String amount;
  final String imagePath;

  MtpPackage({required this.amount, required this.imagePath});
}

class PackageOrder {
  final String orderId;
  final double amount;
  final String createdDate;
  final String nextReward;
  final String status;

  PackageOrder({
    required this.orderId,
    required this.amount,
    required this.createdDate,
    required this.nextReward,
    required this.status,
  });
}
class _InfoText extends StatelessWidget {
  final String title;
  final String value;

  const _InfoText({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
