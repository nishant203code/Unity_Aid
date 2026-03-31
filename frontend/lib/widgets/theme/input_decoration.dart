import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppInputDecoration {
  static InputDecoration style(String label, {BuildContext? context}) {
    final theme = context != null ? Theme.of(context) : null;
    final isDark = theme?.brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isDark
          ? Colors.grey.withOpacity(0.2) // Lighter grey for dark theme
          : theme?.colorScheme.surface.withOpacity(0.1) ??
              Colors.grey.withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
    );
  }
}
