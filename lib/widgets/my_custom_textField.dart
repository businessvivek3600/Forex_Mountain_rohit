import 'package:flutter/material.dart';
import 'glass_card.dart';
class MyCustomTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController controller;
  final bool readOnly;
  final String? Function(String?)? validator;
  final VoidCallback? onSuffixTap;
  final bool obscureText;

  const MyCustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.label,
    this.icon,
    this.isPassword = false,
    this.readOnly = false,
    this.validator,
    this.onSuffixTap,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                label!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          TextFormField(
            controller: controller,
            obscureText: isPassword && obscureText,
            readOnly: readOnly,
            validator: validator,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                ),
                onPressed: onSuffixTap,
              )
                  : null,
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
