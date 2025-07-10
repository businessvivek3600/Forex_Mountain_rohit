

import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blurSigma;
  final List<Color>? gradientColors;
  final BoxShadow? boxShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 16),
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16,
    this.blurSigma = 8,
    this.gradientColors,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
  const  defaultGradient  = [
    Color.fromRGBO(255, 255, 255, 0.1),
    Color.fromRGBO(255, 255, 255, 0.05),
    ];
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: gradientColors ?? defaultGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          boxShadow ??
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(4, 6),
              ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
