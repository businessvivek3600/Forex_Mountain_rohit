import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_fund_request.dart';
import 'package:forex_mountain/my_forex_mountain/my.screens/wallet/widget/transaction_card_shimmer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.provider/my_wallet_provider.dart';
import '../../../widgets/transparent_container.dart';

class FundHistoryScreen extends StatefulWidget {
  const FundHistoryScreen({super.key});

  @override
  State<FundHistoryScreen> createState() => _FundHistoryScreenState();
}

class _FundHistoryScreenState extends State<FundHistoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(() {
      Provider.of<MyWalletProvider>(context, listen: false)
          .resetAndFetchFundRequests(context);
    });
  }

  void _onScroll() {
    final provider = Provider.of<MyWalletProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        provider.hasMoreFundData) {
      provider.fetchFundRequests(context, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          title: bodyLargeText('Fund Request', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<MyWalletProvider>(
              builder: (context, provider, _) {
                if (provider.isFundRequestLoading &&
                    provider.fundRequestList.isEmpty) {
                  return ListView.builder(
                    itemCount: 6,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (_, __) => buildShimmerTransactionCard(),
                  );
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }

                if (!provider.isFundRequestLoading && provider.fundRequestList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/no_reload.json', // make sure it's declared in pubspec.yaml
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No fund requests available.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }


                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.fundRequestList.length +
                      (provider.hasMoreFundData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < provider.fundRequestList.length) {
                      return buildFundHistoryCard(
                          provider.fundRequestList[index]);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFundHistoryCard(MyFundRequestModel entry) {
    Color statusColor;
    switch (entry.status) {
      case '1':
        statusColor = Colors.greenAccent;
        break;
      case '2':
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.orangeAccent;
    }

    return TransparentContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      onTap: () {
        if (entry.transactionFile.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(
                        top: 40, left: 16, right: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        entry.transactionFile,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                        const Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.redAccent)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close,
                          color: Colors.redAccent.shade100, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Date & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar,
                      color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.createdAt,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: Request ID
          Row(
            children: [
              const Icon(Iconsax.code, color: Colors.cyanAccent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Request ID: ${entry.orderId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 3: Payment Type & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.card,
                      color: Colors.amberAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.paymentType,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Iconsax.dollar_circle,
                      color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.totalAmount,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
