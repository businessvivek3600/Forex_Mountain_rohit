

import 'package:flutter/material.dart';

import '../utils/color.dart';

class GradientSaveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const GradientSaveButton({
    super.key,
    required this.label,
    required this.onPressed,
  });



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: textGradiantColors),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
