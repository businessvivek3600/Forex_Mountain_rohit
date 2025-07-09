

import 'package:flutter/material.dart';

import '../../../utils/text.dart';
import '../../../widgets/glass_card.dart';

class WalletTabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final BuildContext context;

  const WalletTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          gradientColors: isSelected
              ? [Colors.amber.withOpacity(0.2), Colors.amber.withOpacity(0.1)]
              : null,
          child: Center(
            child: isSelected
                ? bodyLargeText(label, context, fontSize: 16)
                : Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
