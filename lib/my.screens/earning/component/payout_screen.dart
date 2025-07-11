import 'package:flutter/material.dart';
import 'package:forex_mountain/widgets/glass_card.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/transparent_container.dart';

class PayoutScreen extends StatelessWidget {
  PayoutScreen({super.key});

  final List<PayoutEntry> payoutEntries = [
    PayoutEntry(
      date: '2025-07-06',
      amount: '200',
      status: 'Paid',
      details: 'Transfer successful to UPI account.',
    ),
    PayoutEntry(
      date: '2025-07-05',
      amount: '786.65',
      status: 'Paid',
      details: '',
    ),
    PayoutEntry(
      date: '2025-07-03',
      amount: '1200',
      status: 'Pending',
      details: 'Awaiting admin approval.',
    ),
    PayoutEntry(
      date: '2025-07-02',
      amount: '430',
      status: 'Cancelled',
      details: 'Incorrect account details provided.',
    ),
    PayoutEntry(
      date: '2025-07-01',
      amount: '999.99',
      status: 'Paid',
      details: 'Instant payout processed.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: bodyLargeText('Payout', context, fontSize: 20),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              itemCount: payoutEntries.length,
              itemBuilder: (context, index) {
                return buildPayoutCard(payoutEntries[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPayoutCard(PayoutEntry entry) {
    Color statusColor;
    Color bgColor;

    switch (entry.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orangeAccent;
        bgColor = Colors.orange.withOpacity(0.2);
        break;
      case 'cancelled':
        statusColor = Colors.redAccent;
        bgColor = Colors.red.withOpacity(0.2);
        break;
      default:
        statusColor = Colors.greenAccent;
        bgColor = Colors.green.withOpacity(0.2);
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date row
          Row(
            children: [
              const Icon(Iconsax.calendar, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                entry.date,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Amount & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.dollar_circle,
                      color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '₹${entry.amount}',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Optional details
          if (entry.details.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.message_text,
                    color: Colors.cyanAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.details,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}

class PayoutEntry {
  final String date;
  final String amount;
  final String status;
  final String details;

  PayoutEntry({
    required this.date,
    required this.amount,
    required this.status,
    required this.details,
  });
}
