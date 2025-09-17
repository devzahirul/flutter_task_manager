import 'package:flutter/material.dart';

class DSTypography {
  const DSTypography._();

  // Apply DS text styles on top of a base TextTheme
  static TextTheme apply(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w400, height: 1.1),
      displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w400, height: 1.12),
      displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w500, height: 1.15),
      headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.18),
      headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.2),
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.22),
      titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.25),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.28),
      titleSmall: base.titleSmall?.copyWith(fontWeight: FontWeight.w600, height: 1.3),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.35),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.4),
      bodySmall: base.bodySmall?.copyWith(height: 1.45),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelMedium: base.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      labelSmall: base.labelSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  // Backwards-compatible helper
  static TextTheme textTheme(BuildContext context) => apply(Theme.of(context).textTheme);
}
