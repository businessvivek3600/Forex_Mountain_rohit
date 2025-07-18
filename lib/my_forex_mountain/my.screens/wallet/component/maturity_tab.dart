// screens/wallet/widget/maturity_tab.dart
import 'package:flutter/material.dart';
import 'transfer_to_wallet.dart';
import 'withdraw_screen.dart';
import 'package:iconsax/iconsax.dart';

import '../../../widgets/transparent_container.dart';
import '../model/wallet_transaction.dart';

class MaturityTab extends StatelessWidget {
  final List<WalletTransaction> transactions;

  const MaturityTab({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        children: [
          TransparentContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Maturity Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 6),
                const Text(
                  '\$474.38',
                  style: TextStyle(
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const WithdrawScreen(),));
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
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TransferToWallet(),));

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
          ...transactions.map(_buildTransactionCard).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(WalletTransaction tx) {
    return TransparentContainer(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(tx.date,
                      style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                ],
              ),
              Row(
                children: [
                  const Icon(Iconsax.wallet_3, color: Colors.amberAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(tx.balance,
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Iconsax.document_text, color: Colors.cyanAccent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(tx.description,
                    style: const TextStyle(color: Colors.white, fontSize: 14.5)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.arrow_down_14, color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 6),
                  Text('In: ${tx.amountIn}',
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 13.5)),
                ],
              ),
              Row(
                children: [
                  const Icon(Iconsax.arrow_up_14, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 6),
                  Text('Out: ${tx.amountOut}',
                      style: const TextStyle(color: Colors.redAccent, fontSize: 13.5)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
