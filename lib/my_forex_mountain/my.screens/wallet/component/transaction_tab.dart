// screens/wallet/widget/transaction_tab.dart
import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_wallet_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../my.constant/my_app_constant.dart';
import '../../../my.provider/my_wallet_provider.dart';
import '../../../widgets/transparent_container.dart';
import '../widget/common_transaction_tab.dart';
import '../widget/transaction_card_shimmer.dart';
import 'add_fund_screen.dart';
import 'fund_request_history.dart';
import '../model/fund_history_entry.dart';
import '../model/wallet_transaction.dart';

class TransactionTab extends StatefulWidget {
  const TransactionTab({super.key});

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  late ScrollController _scrollController;
  final String endpoint = MyAppConstants.walletTransaction;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(() {
      Provider.of<MyWalletProvider>(context, listen: false)
          .resetAndFetchWalletData(context,endpoint: endpoint);
    });
  }

  void _onScroll() {
    final provider = Provider.of<MyWalletProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      provider.fetchWalletData(context:context,endpoint: endpoint, loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWalletProvider>(
      builder: (context, walletProvider, child) {
        if (walletProvider.isFirstLoad) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: 6,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: buildShimmerTransactionCard(),
            ),
          );
        } else if (walletProvider.error != null) {
          return Center(child: Text(walletProvider.error!));
        }

        final transactionList = walletProvider.walletTransactionList;
        final walletBalance = double.tryParse(walletProvider.walletBalance) ?? 0.0;

        return ListView(
          controller: _scrollController,
          children: [
            // Balance Container
            TransparentContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${walletBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddFundScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Iconsax.add_square5),
                          label: const Text('Add Fund'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FundHistoryScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Iconsax.activity),
                          label: const Text('Fund History'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Show "No data" if no fund and empty list
            if (walletBalance == 0.0 && transactionList.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/no_reload.json', // Ensure it's in pubspec.yaml
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No data available.',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...transactionList.map((item) => buildTransactionCard(item)).toList(),

            if (walletProvider.hasMoreData)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
