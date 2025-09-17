import 'package:flutter/material.dart';

class DSColors extends ThemeExtension<DSColors> {
  const DSColors({
    required this.brand,
    required this.brandOn,
    required this.surfaceMuted,
  });

  final Color brand;
  final Color brandOn;
  final Color surfaceMuted;

  @override
  ThemeExtension<DSColors> copyWith({Color? brand, Color? brandOn, Color? surfaceMuted}) {
    return DSColors(
      brand: brand ?? this.brand,
      brandOn: brandOn ?? this.brandOn,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
    );
  }

  @override
  ThemeExtension<DSColors> lerp(ThemeExtension<DSColors>? other, double t) {
    if (other is! DSColors) return this;
    return DSColors(
      brand: Color.lerp(brand, other.brand, t)!,
      brandOn: Color.lerp(brandOn, other.brandOn, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
    );
  }

  static const light = DSColors(
    brand: Color(0xFF4F46E5),
    brandOn: Colors.white,
    surfaceMuted: Color(0xFFF3F4F6),
  );

  static const dark = DSColors(
    brand: Color(0xFF818CF8),
    brandOn: Colors.black,
    surfaceMuted: Color(0xFF111827),
  );
}

