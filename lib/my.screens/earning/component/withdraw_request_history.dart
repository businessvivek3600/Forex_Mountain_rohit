import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/transparent_container.dart';


class WithdrawRequestScreen extends StatelessWidget {
  final List<WithdrawRequestEntry> entries;

  const WithdrawRequestScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: bodyLargeText('Withdraw Requests', context, fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: userAppBgImageProvider(context),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return buildWithdrawCard(context, entries[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWithdrawCard(BuildContext context, WithdrawRequestEntry entry) {
    Color statusColor =
    entry.status == 'Paid' ? Colors.greenAccent : Colors.redAccent;

    return GlassCard(

      onTap: () {
        showDialog(
          context: context,
          builder: (_) => buildInvoiceDialog(entry),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.date,
                    style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Request ID
          Row(
            children: [
              const Icon(Iconsax.code, color: Colors.cyanAccent, size: 18),
              const SizedBox(width: 10),
              Text(
                "Request ID: ${entry.requestId}",
                style: const TextStyle(color: Colors.white, fontSize: 14.5),
              ),
            ],
          ),
          const SizedBox(height: 8),

// User ID
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Iconsax.profile_circle, color: Colors.lightBlueAccent, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "User ID: ${entry.userId}",
                        style: const TextStyle(color: Colors.white70, fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              ),
             Spacer(),
// Name
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Iconsax.user, color: Colors.white60, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Name: ${entry.name}",
                        style: const TextStyle(color: Colors.white70, fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Payment Type & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.card, color: Colors.amberAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.paymentType,
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
                    entry.fundAmount,
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

  Widget buildInvoiceDialog(WithdrawRequestEntry entry) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("Customer Details", {
                    "Name": entry.name,
                    "City": entry.city,
                    "Country": entry.country,
                    "Mobile": entry.mobile,
                    "Payment Type": entry.paymentType,
                  }),
                  _buildInfoColumn("Bank Detail", {
                    "Account Name": "Account Name.",
                    "Account No": "Account No.",
                    "IFSC Code": "IFSC Code",
                    "Bank": "Bank",
                  }),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Transaction Number",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 4),
              const Text("N/A", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date : ${entry.date}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Status : ${entry.status}",
                      style: TextStyle(
                          color: entry.status == "Rejected"
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
              _buildAmountRow("Withdraw Amount", entry.fundAmount),
              _buildAmountRow("Processing Charges (0%)", "\$0.0000"),
              const Divider(color: Colors.white24),
              _buildAmountRow("Net Payable", entry.fundAmount, bold: true),
              const SizedBox(height: 24),
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
                color: Colors.white70, fontWeight: bold ? FontWeight.bold : null)),
        Text(amount,
            style: TextStyle(
                color: Colors.white,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}


class WithdrawRequestEntry {
  final String date;
  final String requestId;
  final String paymentType;
  final String fundAmount;
  final String status;

  final String userId; // <-- ADD THIS
  final String name;
  final String city;
  final String country;
  final String mobile;

  WithdrawRequestEntry({
    required this.date,
    required this.requestId,
    required this.paymentType,
    required this.fundAmount,
    required this.status,
    required this.userId, // <-- ADD THIS
    required this.name,
    required this.city,
    required this.country,
    required this.mobile,
  });
}

