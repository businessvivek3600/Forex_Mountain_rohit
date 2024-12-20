import 'package:flutter/material.dart';
import 'package:forex_mountain/providers/deposit_request_provider.dart';
import 'package:intl/intl.dart';

import '/providers/auth_provider.dart';
import '/sl_container.dart';

import 'package:provider/provider.dart';

import '../../../utils/color.dart';
import '../../../utils/sizedbox_utils.dart';
import '../../../utils/picture_utils.dart';

import '../../../utils/text.dart';

class DepositHistoryRequestsPage extends StatefulWidget {
  const DepositHistoryRequestsPage({Key? key}) : super(key: key);

  @override
  State<DepositHistoryRequestsPage> createState() =>
      _DepositHistoryRequestsPageState();
}

class _DepositHistoryRequestsPageState
    extends State<DepositHistoryRequestsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DepositRequestProvider>(context, listen: false)
        .getDepositData();
  }

  void _showSlipDialog(BuildContext context, String slip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Payment Slip",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: slip.isNotEmpty
              ? Image.network(
            slip,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text("Failed to load image");
            },
          )
              : const Text("No slip available."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    String currency_icon = sl.get<AuthProvider>().userData.currency_icon ?? '';
    final depositProvider = Provider.of<DepositRequestProvider>(context);
    String formattedWalletBalance = NumberFormat("#,##0.0#", "en_US").format(
        double.tryParse(depositProvider.depositRequest!.walletBalance) ?? 0);
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: titleLargeText('Deposit Request', context, useGradient: true),
          actions: [
        Consumer<DepositRequestProvider>(
        builder: (context, depositProvider, child) {

    return Row(
      children: [
        titleLargeText(
          '$currency_icon $formattedWalletBalance',context,
         useGradient: true,
        ),
        width20(),
      ],
    );
  },
    ),],
          elevation: 3,
        ),
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: userAppBgImageProvider(context),
              fit: BoxFit.cover,
              opacity: 0.5,
            ),
          ),
          child: depositProvider.fundPackages.isEmpty
              ? const Center(
                  child: Text("No deposit requests found"),
                )
              : ListView.builder(
                  itemCount: depositProvider.fundPackages.length,
                  itemBuilder: (context, index) {
                    final deposit = depositProvider.fundPackages[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ExpansionTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          titleLargeText(
                                            '$currency_icon ${deposit.totalAmount}',
                                            context,
                                          ),
                                          // width10(),
                                          // Expanded(
                                          //   child: bodyLargeText(
                                          //     (deposit.username ??
                                          //         ''),
                                          //     context,
                                          //     textAlign: TextAlign.start,
                                          //     // style: TextStyle(
                                          //     //     fontWeight: FontWeight.bold),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    width10(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: deposit.status == '0'
                                            ? Colors.amber[500]
                                            : deposit.status == '1'
                                                ? Colors.green[500]
                                                : Colors.red[500],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: bodyMedText(
                                        deposit.status == '0'
                                            ? 'Pending'
                                            : deposit.status == '1'
                                                ? 'Completed'
                                                : 'Canceled',
                                        context,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    capText(
                                      DateFormat().add_yMMMEd().format(
                                          DateTime.parse(
                                              deposit.createdAt ?? '')),
                                      context,
                                      textAlign: TextAlign.center,
                                    ),
                                    capText(
                                      DateFormat().add_jm().format(
                                          DateTime.parse(
                                              deposit.createdAt ?? '')),
                                      context,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                collapsedBackgroundColor: Colors.white24,
                                backgroundColor: Colors.white24,
                                iconColor: Colors.white,
                                textColor: Colors.white,
                                collapsedTextColor: Colors.white70,
                                collapsedIconColor: Colors.white,
                                // initiallyExpanded: true,
                                children: [
                                  Container(
                                    // height: 100,
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [

                                        // titleLargeText('\$35', context),
                                        height5(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                capText('Request Id :', context),
                                                width10(),
                                                capText(
                                                    deposit.orderId ?? '',
                                                    context,
                                                    fontWeight: FontWeight.bold),
                                              ],
                                            ),
                                            TextButton(onPressed: () {
                                              _showSlipDialog(
                                                context,
                                                deposit.slip ?? '',
                                              );
                                            }, child: const Text("View Slip",style: TextStyle(fontWeight: FontWeight.w800,color: blueLight),))
                                          ],
                                        ),
                                        height5(),
                                        Row(
                                          children: [
                                            capText('Payment Type :', context),
                                            width10(),
                                            Expanded(
                                              child: bodyLargeText(
                                                deposit.paymentType ??
                                                    '',
                                                context,
                                                // color: index % 2 == 0
                                                //     ? yearlyPackColor
                                                //     : monthlyPackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )

                      ),
                    );
                  }),
        ));
  }
}
