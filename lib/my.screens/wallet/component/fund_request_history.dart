


import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/transparent_container.dart';
import '../model/fund_history_entry.dart';

class FundHistoryScreen extends StatelessWidget {
  final List<FundHistoryEntry> entries;

  FundHistoryScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: bodyLargeText('Fund Request', context, fontSize: 20),
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
        child: Column(
          children: [
            SizedBox(height: 16,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return buildFundHistoryCard(entries[index]);
              },
            ),
          ],
        ),
      ),
    ),
      ),
    );
  }
  Widget buildFundHistoryCard(FundHistoryEntry entry) {
    Color statusColor =
    entry.status == 'Completed' ? Colors.greenAccent : Colors.redAccent;

    return TransparentContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      onTap: () {
        // Optional: Show full details or navigate
        debugPrint("Tapped fund request: ${entry.requestId}");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Date & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar, color: Colors.white70, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    entry.date,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  entry.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: Request ID
          Row(
            children: [
              const Icon(Iconsax.code, color: Colors.cyanAccent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Request ID: ${entry.requestId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 3: Payment Type & Amount
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
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
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

          // Row 4: Optional Proof Link
          if (entry.proofFileUrl != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Iconsax.document, color: Colors.blueAccent, size: 16),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: Open the file or show in modal
                    debugPrint('Open file: ${entry.proofFileUrl}');
                  },
                  child: const Text(
                    'View Proof File',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      decoration: TextDecoration.underline,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ]
        ],
      ),
    );
  }


}