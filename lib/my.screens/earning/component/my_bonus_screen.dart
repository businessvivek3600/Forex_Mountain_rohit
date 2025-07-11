import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/color.dart';
import '../../../utils/picture_utils.dart';
import '../../../utils/text.dart';
import '../../../widgets/glass_card.dart';

class BonusScreen extends StatelessWidget {
  final String title;
  final String notePrefix;
  final List<BonusEntry> entries;

  const BonusScreen({
    super.key,
    required this.title,
    required this.entries,
    this.notePrefix = 'Bonus',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: bodyLargeText(title, context, fontSize: 20),
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
                return buildBonusCard(entries[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBonusCard(BonusEntry entry) {
    return GlassCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Amount
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
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Iconsax.dollar_circle,
                      color: Colors.greenAccent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '\$${entry.amount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Note Row
          Row(
            children: [
              const Icon(Iconsax.note_2, color: Colors.cyanAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$notePrefix ${entry.note}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class BonusEntry {
  final String date;
  final String amount;
  final String note;

  BonusEntry({
    required this.date,
    required this.amount,
    required this.note,
  });
}
