import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_wallet_model.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../my.constant/my_app_constant.dart';
import '../../../my.model/my_withdraw_model.dart';
import '../../../my.provider/my_wallet_provider.dart';
import '../widget/common_transaction_tab.dart';
import '../widget/transaction_card_shimmer.dart';
import 'transfer_to_wallet.dart';
import 'withdraw_screen.dart';
import 'package:iconsax/iconsax.dart';

import '../../../widgets/transparent_container.dart';
import '../model/wallet_transaction.dart';

class MaturityTab extends StatefulWidget {
  const MaturityTab({super.key});

  @override
  State<MaturityTab> createState() => _MaturityTabState();
}

class _MaturityTabState extends State<MaturityTab> {
  late ScrollController _scrollController;
  final String endpoint = MyAppConstants.walletMaturity;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.microtask(() {
      Provider.of<MyWalletProvider>(context, listen: false)
          .resetAndFetchWalletData( context,endpoint: endpoint);
    });
  }

  void _onScroll() {
    final provider = Provider.of<MyWalletProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      provider.fetchWalletData(context: context,endpoint: endpoint, loadMore: true);
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

        final balance = double.tryParse(walletProvider.walletBalance ?? '0') ?? 0.0;
        final hasTransactionData = walletProvider.walletTransactionList.isNotEmpty;

        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 16),
          children: [
            TransparentContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Maturity Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${balance.toStringAsFixed(2)}',
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
                            backgroundColor: Colors.deepPurpleAccent.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WithdrawScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Iconsax.wallet_check),
                          label: const Text('Withdraw'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                           onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => TransferToWallet()),
                            );

                            if (result == true) {
                              // ✅ Reload maturity data here
                             await  Provider.of<MyWalletProvider>(context, listen: false)
                                  .resetAndFetchWalletData(endpoint: endpoint,context); // or call your provider method
                              setState(() {});
                            }

                          },
                          icon: const Icon(Iconsax.import),
                          label: const Text('Transfer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Show no data if both balance and transactions are empty
            if (balance == 0.0 && !hasTransactionData)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/lottie/no_reload.json', // Ensure it's in your assets
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No data available.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            else ...[
              if (hasTransactionData)
                ...walletProvider.walletTransactionList
                    .map((item) => buildTransactionCard(item))
                    .toList()
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('No transactions found.',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),

              if (walletProvider.hasMoreData)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ],
        );
      },
    );
  }
}
