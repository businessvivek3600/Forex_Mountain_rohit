import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransparentTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? icon;
  final TextEditingController controller;
  final bool readOnly;
  final List<String>? dropdownItems;
  final void Function(String?)? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;


  const TransparentTextField({
    super.key,
   this.label,
    this.hintText,
    this.icon,
    required this.controller,
    this.readOnly = false,
    this.dropdownItems,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return dropdownItems != null
        ? DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 12),
        labelText: label,
        labelStyle: const TextStyle(
            color: Colors.white70, fontSize: 14),
        hintText: hintText ?? 'Select $label',
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: icon != null
            ? Icon(icon, color:  Colors.amberAccent)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: Colors.white.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color:  Colors.amberAccent, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      dropdownColor: Colors.black87,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      items: dropdownItems!
          .map(
            (item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ),
      )
          .toList(),
      onChanged: (value) {
        controller.text = value ?? '';
        if (onChanged != null) onChanged!(value);
      },
    )
        : TextFormField(
      controller: controller,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 16, horizontal: 12),
        labelText: label,
        labelStyle:
        const TextStyle(color: Colors.white70, fontSize: 14),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: icon != null
            ? Icon(icon, color:  Colors.amberAccent)
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: Colors.white.withOpacity(0.2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color:  Colors.amberAccent, width: 1.5),
        ),
      ),
    );
  }
}
