import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/transparent_container.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../screens/dashboard/main_page.dart';
import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.provider/my_mlm_provider.dart';
import 'buy_packages.dart';

class PackagesScreen extends StatefulWidget {
  PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MyMlmProvider>(context, listen: false)
          .fetchPackagesData(context);
    });
  }

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
          iconTheme: const IconThemeData(color: Colors.amber),
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '📦 My Packages',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text(
                        "Buy",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                        onPressed: () {
                          final packagesModel = Provider.of<MyMlmProvider>(context, listen: false).packagesModel;

                          if (packagesModel?.data?.packages != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BuyPackageScreen(
                                  myPackages: packagesModel!.data!.packages,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please wait, loading packages...")),
                            );
                          }
                        }

                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer<MyMlmProvider>(builder: (context, provider, child) {
                    if (provider.isLoadingPackages) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (_, index) => const ShimmerPackageItem(),
                      );
                    }

                    final buyPackages =
                        provider.packagesModel?.data?.buyPackage ?? [];

                    if (buyPackages.isEmpty) {
                      return const Center(
                        child: Text("No data found"),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: buyPackages.length,
                      itemBuilder: (context, index) {
                        final order = buyPackages[index];

                        final String statusText;
                        final Color statusColor;

                        switch (order.status) {
                          case "1":
                            statusText = "Running";
                            statusColor = Colors.greenAccent.shade400;
                            break;
                          case "2":
                            statusText = "Pending";
                            statusColor = Colors.orangeAccent;
                            break;
                          case "3":
                            statusText = "Closed";
                            statusColor = Colors.grey;
                            break;
                          default:
                            statusText = "Unknown";
                            statusColor = Colors.blueGrey;
                        }

                        return GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🧾 Header: Order & Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Order #${order.invoice}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.2),
                                      border: Border.all(
                                          color: statusColor, width: 1.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),

                              // 💼 Package name & Amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.packageName ?? "Unnamed Package",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "\$${order.packageAmount ?? "--"}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // 📄 Info rows
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _InfoText(
                                      title: "Created",
                                      value: order.createdAt ?? "-",
                                    ),
                                  ),
                                  Expanded(
                                    child: _InfoText(
                                      title: "Payment Type",
                                      value: order.paymentType ?? "-",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _InfoText(
                                      title: "Next Reward",
                                      value: order.nextReward ?? "-",
                                    ),
                                  ),
                                  const Spacer(), // leave right half empty now
                                ],
                              ),
                              if (order.status == "1")
                                const SizedBox(height: 16),

                              // ⏬ Withdraw button
                              if (order.status == "1")
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                    onPressed: () {
                                      // You can adjust the values dynamically based on your order object
                                      final rawAmount = double.tryParse(order.packageAmount ?? "0") ?? 0.0;
                                      final etfPercentage = double.tryParse(order.etfPer ?? "0") ?? 0.0;

                                      final etfAmount = (rawAmount * etfPercentage / 100);
                                      final netAmount = rawAmount - etfAmount;

                                      showWithdrawDialog(
                                        context,
                                        amount:rawAmount.toString(),
                                        etfCharge: etfAmount.toString(),
                                        netAmount: netAmount.toString(),
                                        onConfirm: () {
                                          Provider.of<MyMlmProvider>(context, listen: false)
                                              .withdrawPackageByInvoiceId(context, order.invoiceId.toString() ?? "");
                                        },

                                      );
                                    },

                                    icon: const Icon(Icons.arrow_downward,
                                        size: 18),
                                    label: const Text("Withdraw"),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> showWithdrawDialog(BuildContext context,
      {required String amount,
        required String etfCharge,
        required String netAmount,
        required VoidCallback onConfirm}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Confirmation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Iconsax.warning_2,color: Colors.amber,)
                  ],
                ),
                const Divider(height: 24,color: Colors.grey,),
                const Text(
                  "Are you sure to withdraw this package?",
                  style: TextStyle(fontSize: 14,color: Colors.white70),
                ),
                const SizedBox(height: 16),
                _DialogRow(label: "Amount", value: amount),
                _DialogRow(label: "ETF charge", value: etfCharge),
                _DialogRow(label: "Net Amount", value: netAmount),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // YES
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Confirm"),
                    ),
                    // NO
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black12,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cancel"),
                    ),

                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
class _DialogRow extends StatelessWidget {
  final String label;
  final String value;
  const _DialogRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
          Text("\$$value", style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.white)),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String title;
  final String value;
  const _InfoText({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Column(
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
      ),
    );
  }
}

class ShimmerPackageItem extends StatelessWidget {
  const ShimmerPackageItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
void showCustomToast(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    ),
  );
}
