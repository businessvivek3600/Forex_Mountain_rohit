import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../utils/color.dart';
import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.model/my_payout_model.dart';
import '../../../my.provider/my_earning_provider.dart';
import '../../../widgets/transparent_container.dart';

class PayoutScreen extends StatefulWidget {
  PayoutScreen({super.key});

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MyEarningProvider>(context, listen: false);
    provider.resetPayouts();
    provider.fetchPayoutData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        provider.fetchPayoutData(loadMore: true);
      }
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
          title: bodyLargeText('Payout', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body:
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Consumer<MyEarningProvider>(
                builder: (_, provider, __) {
                  if (provider.isFirstLoadPayout) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.payoutErrorMessage != null) {
                    return Center(child: Text(provider.payoutErrorMessage!));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      provider.resetPayouts();
                      await provider.fetchPayoutData();
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.payouts.length +
                          (provider.hasMorePayout ? 1 : 0), // +1 for loader
                      itemBuilder: (context, index) {
                        if (index == provider.payouts.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return buildPayoutCard(provider.payouts[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),

    );
  }

  Widget buildPayoutCard(MyPayoutModel entry) {
    Color statusColor;
    Color bgColor;

    switch (entry.status.toLowerCase()) {
      case '1':
        statusColor = Colors.greenAccent;
        bgColor = Colors.orange.withOpacity(0.2);
        break;
      case '0':
        statusColor = Colors.redAccent;
        bgColor = Colors.red.withOpacity(0.2);
        break;
      default:
        statusColor = Colors.greenAccent;
        bgColor = Colors.green.withOpacity(0.2);
    }

    return TransparentContainer(
      margin: const EdgeInsets.only(top: 16),
      borderWidth: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date row
          Row(
            children: [
              const Icon(Iconsax.calendar, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                entry.date,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Amount & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  bodyLargeText(
                    '\$${double.tryParse(entry.amount)?.toStringAsFixed(2) ?? '0.00'}',
                    context,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Optional details

        ],
      ),
    );
  }
}

class PayoutEntry {
  final String date;
  final String amount;
  final String status;
  final String details;

  PayoutEntry({
    required this.date,
    required this.amount,
    required this.status,
    required this.details,
  });
}
