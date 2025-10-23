import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: TextStyle(
        color: theme.brightness == Brightness.dark
            ? Colors.white
            : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.brightness == Brightness.dark
              ? Colors.white70
              : Colors.black54,
        ),
        prefixIcon: Icon(icon,
            color: theme.brightness == Brightness.dark
                ? colorScheme.secondary
                : colorScheme.primary),
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1C1C23)
            : Colors.grey[100],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary.withOpacity(0.5),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
