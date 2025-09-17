import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radii.dart';
import '../tokens/spacing.dart';
import '../tokens/elevations.dart';
import '../tokens/durations.dart';
import 'ds_typography.dart';

class DSThemeOptions {
  const DSThemeOptions({
    this.seed,
    this.applyTextTheme = true,
    this.density,
  });

  final Color? seed;
  final bool applyTextTheme;
  final VisualDensity? density;
}

class DSThemeBuilder {
  static ThemeData light([DSThemeOptions options = const DSThemeOptions()]) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: options.seed ?? DSColors.light.brand),
      visualDensity: options.density ?? VisualDensity.standard,
      platform: TargetPlatform.android,
    );
    return _applyComponents(base, DSColors.light, options);
  }

  static ThemeData dark([DSThemeOptions options = const DSThemeOptions()]) {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: options.seed ?? DSColors.dark.brand,
        brightness: Brightness.dark,
      ),
      visualDensity: options.density ?? VisualDensity.standard,
      platform: TargetPlatform.android,
    );
    return _applyComponents(base, DSColors.dark, options);
  }

  static ThemeData _applyComponents(ThemeData base, DSColors colors, DSThemeOptions options) {
    final cs = base.colorScheme;
    final textTheme = options.applyTextTheme ? DSTypography.apply(base.textTheme) : base.textTheme;

    final shape = RoundedRectangleBorder(borderRadius: DSRounders.md);
    final buttonPadding = const EdgeInsets.symmetric(horizontal: DSSpacing.lg);

    final filledButtonTheme = FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
        padding: WidgetStatePropertyAll(buttonPadding),
        shape: WidgetStatePropertyAll(shape),
        elevation: const WidgetStatePropertyAll(DSElevations.level1),
        animationDuration: DSDurations.short,
      ),
    );
    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
        padding: WidgetStatePropertyAll(buttonPadding),
        shape: WidgetStatePropertyAll(shape),
        elevation: const WidgetStatePropertyAll(DSElevations.level1),
        animationDuration: DSDurations.short,
        backgroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.disabled) ? cs.surfaceContainerHighest : cs.secondaryContainer),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.disabled) ? cs.onSurface : cs.onSecondaryContainer),
      ),
    );
    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(48)),
        padding: WidgetStatePropertyAll(buttonPadding),
        shape: WidgetStatePropertyAll(shape),
        animationDuration: DSDurations.short,
        side: WidgetStatePropertyAll(BorderSide(color: cs.outline)),
      ),
    );

    final inputTheme = InputDecorationTheme(
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: DSSpacing.lg, vertical: DSSpacing.md),
      border: OutlineInputBorder(borderRadius: DSRounders.md),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: cs.outline), borderRadius: DSRounders.md),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cs.primary, width: 2), borderRadius: DSRounders.md),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: cs.error), borderRadius: DSRounders.md),
      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: cs.error, width: 2), borderRadius: DSRounders.md),
      filled: false,
      hintStyle: TextStyle(color: cs.onSurfaceVariant),
      labelStyle: TextStyle(color: cs.onSurfaceVariant),
      helperStyle: TextStyle(color: cs.onSurfaceVariant),
      errorStyle: TextStyle(color: cs.error),
    );

    final cardTheme = CardThemeData(
      shape: shape,
      elevation: DSElevations.level1,
      clipBehavior: Clip.antiAlias,
      color: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      margin: const EdgeInsets.all(0),
    );

    return base.copyWith(
      textTheme: textTheme,
      cardTheme: cardTheme,
      inputDecorationTheme: inputTheme,
      filledButtonTheme: filledButtonTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: shape),
      appBarTheme: AppBarTheme(centerTitle: false, elevation: 0, backgroundColor: cs.surface, foregroundColor: cs.onSurface),
      extensions: [colors],
    );
  }

  // Build theme from a provided ColorScheme (e.g., dynamic colors on Android 12+)
  static ThemeData fromScheme(ColorScheme scheme, {bool dark = false, DSThemeOptions options = const DSThemeOptions()}) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      visualDensity: options.density ?? VisualDensity.standard,
      platform: TargetPlatform.android,
    );
    // Pick closest DSColors variant for extension; brand derives from primary
    final colors = DSColors(
      brand: scheme.primary,
      brandOn: scheme.onPrimary,
      surfaceMuted: scheme.surfaceContainerHighest,
    );
    return _applyComponents(base, colors, options);
  }
}

extension DSThemeX on BuildContext {
  DSColors get dsColors => Theme.of(this).extension<DSColors>() ?? DSColors.light;
  ColorScheme get dsColorScheme => Theme.of(this).colorScheme;
}
