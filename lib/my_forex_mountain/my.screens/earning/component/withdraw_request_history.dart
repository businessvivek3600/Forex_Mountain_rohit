import 'package:flutter/material.dart';
import 'package:forex_mountain/my_forex_mountain/my.model/my_withdraw_model.dart';
import 'package:forex_mountain/my_forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../sl_container.dart';
import '../../../../utils/color.dart';
import '../../../../utils/picture_utils.dart';
import '../../../../utils/text.dart';
import '../../../my.model/my_withdraw_invoice.dart';
import '../../../my.provider/my_earning_provider.dart';
import '../../../widgets/transparent_container.dart';

class WithdrawRequestScreen extends StatefulWidget {
  const WithdrawRequestScreen({
    super.key,
  });

  @override
  State<WithdrawRequestScreen> createState() => _WithdrawRequestScreenState();
}

class _WithdrawRequestScreenState extends State<WithdrawRequestScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    // Delay provider calls until the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =  sl<MyEarningProvider>();

      provider.resetWithdrawRequests();
      provider.fetchWithdrawRequests(context);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<MyEarningProvider>(context, listen: false)
          .fetchWithdrawRequests(context,loadMore: true);
    }
  }
  String getStatusText(String statusCode) {
    switch (statusCode) {
      case '0':
        return 'Pending';
      case '1':
        return 'Paid';
      case '2':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color getStatusColor(String statusCode) {
    switch (statusCode) {
      case '0':
        return Colors.orangeAccent;
      case '1':
        return Colors.greenAccent;
      case '2':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
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
          title: bodyLargeText('Withdraw Requests', context, fontSize: 20),
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.amber),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<MyEarningProvider>(
              builder: (context, provider, _) {
                if (provider.isFirstLoadWithdraw) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.withdrawRequests.isEmpty) {
                  return Center(
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


                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.withdrawRequests.length +
                      (provider.hasMoreWithdraw ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < provider.withdrawRequests.length) {
                      return buildWithdrawCard(
                          context, provider.withdrawRequests[index]);
                    } else {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
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

  Widget buildWithdrawCard(BuildContext context, MyWithdrawRequestModel entry) {
    final String statusText = getStatusText(entry.status);
    final Color statusColor = getStatusColor(entry.status);

    String formattedDate = '';
    try {
      final DateTime parsedDate = DateTime.parse(entry.createdAt);
      formattedDate = DateFormat('dd MMM, yyyy • hh:mm a').format(parsedDate);
    } catch (_) {
      formattedDate = entry.createdAt;
    }

    return GestureDetector(
      onTap: () async {
        // final prov = Provider.of<MyEarningProvider>(context, listen: false);
        // await prov.fetchInvoice(entry.id);
        // showDialog(
        //   context: context,
        //   builder: (_) => Consumer<MyEarningProvider>(
        //     builder: (_, p, __) {
        //       if (p.isLoadingInvoice) {
        //         return const Center(child: CircularProgressIndicator());
        //       } else if (p.invoiceError != null) {
        //         return AlertDialog(content: Text(p.invoiceError!));
        //       } else if (p.invoiceDetail != null) {
        //         return buildInvoiceDialog(p.invoiceDetail!);
        //       } else {
        //         return const AlertDialog(content: Text("No data"));
        //       }
        //     },
        //   ),
        // );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(1),
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.02),
              Colors.white.withOpacity(0.06),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1),width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Date & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.calendar, size: 16, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon( entry.status == '0'
                          ? Iconsax.timer
                          : entry.status == '1'
                          ? Iconsax.tick_circle
                          : Iconsax.close_circle, size: 16, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Info Tiles
            _infoRow(Iconsax.profile_circle, "User ID", entry.username),
            const SizedBox(height: 10),
            _infoRow(Iconsax.user, "Name", entry.name),
            const SizedBox(height: 10),
            _infoRow(Iconsax.card, "Method", entry.paymentType),
            const SizedBox(height: 10),
            /// 🔹 Amount Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.money, color: Colors.greenAccent, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "\$${double.tryParse(entry.netPayable)?.toStringAsFixed(2) ?? '0.00'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.greenAccent,
                          blurRadius: 8,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white60),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildInvoiceDialog(InvDetail inv) {
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text("Withdrawal Invoice",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              const SizedBox(height: 20),
              Center(child: Text("Withdrawal Invoice", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white))),
              const SizedBox(height: 16),
              // Common details
              _buildInfoRow("Date", inv.date),
              _buildInfoRow("Username", inv.username),
              _buildInfoRow("Name", inv.name),
              _buildInfoRow("Net Payable", "\$${double.tryParse(inv.netPayable)?.toStringAsFixed(2)}"),
              const Divider(color: Colors.white30),
              // Payment-type-specific section
              _buildPaymentSection(inv),
              const SizedBox(height: 20),
              const SizedBox(height: 16),
              const Text("Transaction Number",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              const Text("N/A", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("Date : ${entry.date}",
                  //     style: const TextStyle(color: Colors.white70)),
                  Text("Status : ${inv.status}",
                      style: TextStyle(
                          color: inv.status == "Rejected"
                              ? Colors.redAccent
                              : Colors.greenAccent,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Type",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // _buildAmountRow("Withdraw Amount", entry.fundAmount),
              // _buildAmountRow("Processing Charges (0%)", "\$0.0000"),
              // const Divider(color: Colors.white24),
              // _buildAmountRow("Net Payable", entry.fundAmount, bold: true),
              // const SizedBox(height: 24),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.picture_as_pdf, color: Colors.white38),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildInfoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$key:", style: TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
  Widget _buildPaymentSection(InvDetail inv) {
    switch (inv.paymentType.toUpperCase()) {
      case 'GOOGLEPAY':
        return _buildInfoColumn("Google Pay Detail", {
          "Number": inv.googlePayNo ?? "-",
          "UPI ID": inv.googlePayId ?? "-",
          "QR": inv.googlePayQr ?? "-",
        });
      case 'PHONEPAY':
        return _buildInfoColumn("PhonePe Detail", {
          "Number": inv.phonePayNo ?? "-",
          "UPI ID": inv.phonePayId ?? "-",
          "QR": inv.phonePayQr ?? "-",
        });
      case 'BANK':
        return _buildInfoColumn("Bank Details", {
          "Account Holder": inv.accountHolderName,
          "Account No": inv.accountNo ?? "-",
          "IFSC": inv.ifscCode,
          "Bank": inv.bank ?? "-",
        });
      case 'USDT':
        return _buildInfoColumn("USDT Wallet", {
          "USDT Address": inv.usdtAddress ?? "-",
          "OBD Address": inv.obdAddress ?? "-",
        });
      default:
        return const Text("Unknown payment type", style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildInfoColumn(String title, Map<String, String> data) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (var entry in data.entries)
            Text("${entry.key} : ${entry.value}",
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }


}
