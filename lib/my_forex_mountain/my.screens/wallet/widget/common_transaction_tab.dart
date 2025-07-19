

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../my.model/my_wallet_model.dart';
import '../../../widgets/transparent_container.dart';

Widget buildTransactionCard(MyWalletData tx) {
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
                Text(tx.createdAt,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12.5)),
              ],
            ),
            Row(
              children: [
                const Icon(Iconsax.wallet_3,
                    color: Colors.amberAccent, size: 16),
                const SizedBox(width: 6),
                Text(double.tryParse(tx.balance)?.toStringAsFixed(2) ?? '0.00',
                    style: const TextStyle(
                        color: Colors.amberAccent, fontSize: 13)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Iconsax.document_text,
                color: Colors.cyanAccent, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tx.note,
                style: const TextStyle(color: Colors.white, fontSize: 14.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Iconsax.arrow_circle_down4,
                    color: Colors.greenAccent, size: 18),
                const SizedBox(width: 6),

                Text('In: ${double.tryParse(tx.credit)?.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.greenAccent, fontSize: 13.5)),
              ],
            ),
            Row(
              children: [
                const Icon(Iconsax.arrow_up_14,
                    color: Colors.redAccent, size: 18),
                const SizedBox(width: 6),
                Text('Out: ${double.tryParse(tx.debit)?.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.redAccent, fontSize: 13.5)),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}