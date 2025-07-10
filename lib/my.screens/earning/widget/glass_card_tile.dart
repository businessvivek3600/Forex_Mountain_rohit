import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../widgets/glass_card.dart';

class GlassCardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const GlassCardTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.amber, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Icon(Iconsax.arrow_right_41, size: 24, color: Colors.white),
          ],
        ),
      ),
    );
  }
}