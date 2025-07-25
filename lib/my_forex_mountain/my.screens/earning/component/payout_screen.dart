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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MyEarningProvider>(context, listen: false);
      provider.resetPayouts();
      provider.fetchPayoutData(context);
    });

    _scrollController.addListener(() {
      final provider = Provider.of<MyEarningProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        provider.fetchPayoutData(context,loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          iconTheme: const IconThemeData(color: Colors.amber),
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
                  if (provider.payouts.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No data found",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      provider.resetPayouts();
                      await provider.fetchPayoutData(context);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
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
    final bool isPaid = entry.status == '1';

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isPaid ? Colors.greenAccent : Colors.redAccent,
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Date Row
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

          const SizedBox(height: 8),

          /// Amount + Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '\$${double.tryParse(entry.amount)?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  isPaid ? 'Paid' : 'Unpaid',
                  style: TextStyle(
                    color: isPaid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

