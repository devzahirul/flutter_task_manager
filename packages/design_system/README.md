# Design System (Android-first, Material 3)

A scalable, maintainable, and reusable Flutter design system tailored for Android. It ships tokenized foundations, cohesive Material 3 theming, and DS-wrapped components designed for consistency and velocity.

## Highlights
- Tokenized foundations: colors, spacing, radii, elevations, durations, opacities
- Android-first Material 3 theme builder (light/dark) with component themes
- Reusable DS components: buttons, inputs, and cards
- Extensible architecture for future components and tokens

## Installation

Monorepo path dependency (already configured here). For stand‑alone usage:

```
dependencies:
  design_system:
    path: ./packages/design_system
```

Import once:

```
import 'package:design_system/design_system.dart';
```

## Quick Start

```
MaterialApp(
  theme: DSThemeBuilder.light(),
  darkTheme: DSThemeBuilder.dark(),
  themeMode: ThemeMode.system,
);
```

### Android Dynamic Color (Material You)
Optionally use dynamic colors on Android 12+ with `DSThemeBuilder.fromScheme`.

```
// Using the dynamic_color package as an example (optional)
return DynamicColorBuilder(
  builder: (ColorScheme? light, ColorScheme? dark) {
    final lightScheme = light ?? ColorScheme.fromSeed(seedColor: DSColors.light.brand);
    final darkScheme  = dark  ?? ColorScheme.fromSeed(seedColor: DSColors.dark.brand, brightness: Brightness.dark);
    return MaterialApp(
      theme: DSThemeBuilder.fromScheme(lightScheme),
      darkTheme: DSThemeBuilder.fromScheme(darkScheme, dark: true),
      themeMode: ThemeMode.system,
    );
  },
);
```

## Package Layout
- `lib/src/tokens/*` — Design tokens (no BuildContext)
- `lib/src/theme/*` — ThemeData builder + typography
- `lib/src/components/*` — Opinionated wrappers around Material
- `lib/design_system.dart` — Public exports

## Tokens
- Colors: `DSColors` (ThemeExtension)
  - Access via context: `context.dsColors` or `context.dsColorScheme`
  - Light/Dark presets, plus dynamic via `fromScheme`/seed color
- Spacing: `DSSpacing.xxs..xxl` (dp)
- Radii: `DSRadii` (Radius) and `DSRounders` (BorderRadius)
- Elevations: `DSElevations.level0..level5` (dp)
- Durations: `DSDurations.quick|short|medium|long|emphasized`
- Opacities: `DSOpacities.disabled|hover|focus|pressed`

Example:

```
Padding(
  padding: const EdgeInsets.all(DSSpacing.lg),
  child: Container(decoration: BoxDecoration(borderRadius: DSRounders.md)),
)
```

## Components

### DSButton

```
DSButton(
  label: 'Continue',
  icon: const Icon(Icons.arrow_forward),
  trailingIcon: const Icon(Icons.check),
  style: DSButtonStyle.primary,   // primary | secondary | outlined
  size: DSButtonSize.medium,      // small | medium | large
  loading: false,
  fullWidth: true,
  onPressed: () {},
)
```

Props: `label` (required), `icon`, `trailingIcon`, `onPressed`, `style`, `size`, `loading`, `fullWidth`.

### DSInput

```
final controller = TextEditingController();
DSInput(
  controller: controller,
  variant: DSInputVariant.outlined, // outlined | filled
  label: 'Email',
  hint: 'Enter your email',
  helperText: 'We never share your email',
  errorText: null,
  prefix: const Icon(Icons.email_outlined),
  keyboardType: TextInputType.emailAddress,
)
```

### DSCard

```
DSCard(
  variant: DSCardVariant.elevated, // elevated | filled | outlined
  padding: const EdgeInsets.all(DSSpacing.xl),
  child: Column(children: const [Text('Title'), Text('Body')]),
)
```

## Theming

`DSThemeBuilder` provides light/dark and `fromScheme` builders. Component themes are preconfigured for buttons, inputs, cards, AppBar, and SnackBar.

```
final theme = DSThemeBuilder.light(
  const DSThemeOptions(
    seed: Color(0xFF4F46E5),       // Optional custom seed color
    applyTextTheme: true,          // Apply DS typography overrides
    density: VisualDensity.standard,
  ),
);
```

Typography is applied via `DSTypography.apply` to ensure consistent weights and leading across the app.

## Principles
- Single source of truth via tokens
- Android-first defaults with Material 3 semantics
- Small, composable components wrapping Material primitives
- Strict separation of tokens (no BuildContext) and theming
- Accessibility: 48dp min touch target, adequate contrast, scalable text

## Extending
- Add new tokens under `src/tokens/`
- Add/adjust component themes in `src/theme/ds_theme.dart`
- Create new DS components in `src/components/` using tokens + Theme

## Changelog
- 0.1.0: Initial Android-first M3 tokens, theming, and components
