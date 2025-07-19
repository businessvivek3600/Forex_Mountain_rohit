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
      provider.fetchWithdrawRequests();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      Provider.of<MyEarningProvider>(context, listen: false)
          .fetchWithdrawRequests(loadMore: true);
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
                  return const Center(
                      child: Text("No withdraw requests found"));
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
print("-----------------${entry.id}-----------------");
    // Format the date
    String formattedDate = '';
    try {
      final DateTime parsedDate = DateTime.parse(entry.createdAt);
      formattedDate = DateFormat('dd MMM, yyyy – hh:mm a').format(parsedDate);
    } catch (_) {
      formattedDate = entry.createdAt;
    }

    return TransparentContainer(
      margin: const EdgeInsets.only(top: 16),
      borderWidth: 4,
      onTap: () async{
        final prov = Provider.of<MyEarningProvider>(context, listen: false);
        await prov.fetchInvoice(entry.id); // uses ID
        showDialog(
          context: context,
          builder: (_) => Consumer<MyEarningProvider>(
            builder: (_, p, __) {
              if (p.isLoadingInvoice) {
                return const Center(child: CircularProgressIndicator());
              } else if (p.invoiceError != null) {
                return AlertDialog(content: Text(p.invoiceError!));
              } else if (p.invoiceDetail != null) {
                return buildInvoiceDialog(p.invoiceDetail!); // pass model
              } else {
                return const AlertDialog(content: Text("No data"));
              }
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.calendar, color: Colors.blueGrey, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.tick_circle, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // User ID & Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(
                  icon: Iconsax.profile_circle,
                  label: 'User ID',
                  value: entry.username,
                ),

                _infoItem(
                  label: 'Name',
                  value: entry.name,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Payment & Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(
                  icon: Iconsax.card,
                  label: 'Method',
                  value: entry.paymentType,
                  iconColor: Colors.amberAccent,
                ),
                _infoItem(

                  label: 'Amount',
                  value:
                  '\$${double.tryParse(entry.netPayable)?.toStringAsFixed(2) ?? '0.00'}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem({
 IconData? icon,
    required String label,
    required String value,
    Color iconColor = Colors.white70,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label:  ",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ))
          ),
        ],
      ),
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

  Widget _buildAmountRow(String label, String amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white70,
                fontWeight: bold ? FontWeight.bold : null)),
        Text(amount,
            style: TextStyle(
                color: Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
