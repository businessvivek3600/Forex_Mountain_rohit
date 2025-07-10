import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/color.dart';
import '../../utils/picture_utils.dart';
import '../../utils/text.dart';
import '../../widgets/transparent_container.dart';
import 'component/fund_request_history.dart';
import 'component/maturity_tab.dart';
import 'component/transaction_tab.dart';
import 'model/fund_history_entry.dart';
import 'model/wallet_transaction.dart';
import 'widget/wallet_tab_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedTabIndex = 0;
  final List<WalletTransaction> transactions = [
    WalletTransaction(
      date: "2025-05-09 16:34:17",
      description: "You have purchased package #JPXPKGRPKG",
      amountIn: "\$0.00",
      amountOut: "\$50.00",
      balance: "\$1744.00",
    ),
    WalletTransaction(
      date: "2025-05-09 16:34:14",
      description: "You have purchased package #RVQ1L297IA",
      amountIn: "\$0.00",
      amountOut: "\$50.00",
      balance: "\$1794.00",
    ),
    WalletTransaction(
      date: "2025-05-09 16:32:08",
      description:
          "Fund Request Approved by Admin, Request id is #ACQ8WF4YJ4XD",
      amountIn: "\$50.00",
      amountOut: "\$0.00",
      balance: "\$1844.00",
    ),
    // Add more entries here...
  ];

  final List<WalletTransaction> maturityTransactions = [
    WalletTransaction(date: "2025-07-09 01:00:00", description: "Received amount from payout on 2025-07-08", amountIn: "\$5.00", amountOut: "\$0.00", balance: "\$474.38"),
    WalletTransaction(date: "2025-06-28 01:00:01", description: "Received amount from payout on 2025-06-27", amountIn: "\$20.00", amountOut: "\$0.00", balance: "\$469.38"),
    WalletTransaction(date: "2025-06-23 01:00:00", description: "Received amount from payout on 2025-06-22", amountIn: "\$66.65", amountOut: "\$0.00", balance: "\$449.38"),
    WalletTransaction(date: "2025-06-09 01:00:00", description: "Received amount from payout on 2025-06-08", amountIn: "\$5.00", amountOut: "\$0.00", balance: "\$382.73"),
    WalletTransaction(date: "2025-06-01 01:00:01", description: "Received amount from payout on 2025-05-31", amountIn: "\$40.00", amountOut: "\$0.00", balance: "\$377.73"),
    WalletTransaction(date: "2025-05-28 01:00:00", description: "Received amount from payout on 2025-05-27", amountIn: "\$20.00", amountOut: "\$0.00", balance: "\$337.73"),
    WalletTransaction(date: "2025-05-23 01:00:00", description: "Received amount from payout on 2025-05-22", amountIn: "\$66.65", amountOut: "\$0.00", balance: "\$317.73"),
    WalletTransaction(date: "2025-05-07 01:00:00", description: "Received amount from payout on 2025-05-06", amountIn: "\$20.00", amountOut: "\$0.00", balance: "\$251.08"),
    WalletTransaction(date: "2025-05-06 18:44:03", description: "Withdraw amount", amountIn: "\$0.00", amountOut: "\$20.00", balance: "\$231.08"),
    WalletTransaction(date: "2025-04-28 01:00:01", description: "Received amount from payout on 2025-04-27", amountIn: "\$20.00", amountOut: "\$0.00", balance: "\$251.08"),
  ];

  final List<FundHistoryEntry> fundHistoryData = [
    FundHistoryEntry(
      requestId: "P19PC8KFGK2G",
      date: "2025-02-20 23:40:48",
      paymentType: "USDT",
      fundAmount: "\$1333.00",
      status: "Completed",
    ),
    FundHistoryEntry(
      requestId: "OK11DHU978MR",
      date: "2025-02-20 23:40:50",
      paymentType: "USDT",
      fundAmount: "\$1333.00",
      status: "Canceled",
    ),
    // Add more entries...
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child:  Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.element_4, color: Colors.amber),
              onPressed: () {
                // Handle menu button press
              },
            ),
            title: bodyLargeText('WALLET', context, fontSize: 20),
            backgroundColor: Colors.black,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.06),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: TabBar(
                  isScrollable: false,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  labelColor: Colors.amberAccent,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: "Transaction"),
                    Tab(text: "Maturity"),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBarView(
                  children: [
                    TransactionTab(
                      transactions: transactions,
                      fundHistoryData: fundHistoryData,
                    ),
                    MaturityTab(transactions: maturityTransactions),

                  ],
                )),
          ),
        ),
      ),
    );
  }
}



