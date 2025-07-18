import 'package:flutter/material.dart';

class TransparentContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  final double borderWidth;       // ✅ Customizable border width
  final double borderBlurRadius;  // ✅ Customizable blur radius

  const TransparentContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.onTap,
    this.borderWidth = 1.0,             // Default same as before
    this.borderBlurRadius = 12.0,       // Default same as before
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: borderBlurRadius, // 👈 Used here
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: borderWidth, // 👈 Used here
          ),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
