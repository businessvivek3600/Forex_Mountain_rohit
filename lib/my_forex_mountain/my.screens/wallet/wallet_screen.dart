import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.screens/drawer/custom_drawer.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
          key: _scaffoldKey, // Add the key
          backgroundColor: Colors.transparent,
          drawer: const CustomAppDrawer(),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.element_4, color: Colors.amber),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
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
          body: const SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TabBarView(
                  children: [
                    TransactionTab(),
                    MaturityTab(),

                  ],
                )),
          ),
        ),
      ),
    );
  }
}



