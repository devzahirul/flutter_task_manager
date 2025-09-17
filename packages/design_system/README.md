# Design System (Android-first, Material 3)

A scalable, maintainable, and reusable Flutter design system tailored for Android (Material 3). It provides tokenized foundations, cohesive theming, and opinionated UI components.

## Highlights
- Tokenized foundations: colors, spacing, radii, elevations, durations
- Material 3 theme builder: light/dark, Android platform defaults
- Cohesive component theming for buttons, inputs, and cards
- Extensible structure for future components

## Package Layout
- `lib/src/tokens/*` — Design tokens (no Flutter context)
- `lib/src/theme/*` — ThemeData builder + typography
- `lib/src/components/*` — DS-wrapped Material components
- `lib/design_system.dart` — Public exports

## Usage

```
MaterialApp(
  theme: DSThemeBuilder.light(),
  darkTheme: DSThemeBuilder.dark(),
  themeMode: ThemeMode.system,
);
```

Components:

```
// Buttons
DSButton(
  label: 'Continue',
  icon: const Icon(Icons.arrow_forward),
  style: DSButtonStyle.primary,
  size: DSButtonSize.medium,
  fullWidth: true,
  onPressed: () {},
);

// Inputs
final controller = TextEditingController();
DSInput(
  controller: controller,
  label: 'Email',
  hint: 'Enter your email',
  helperText: 'We never share your email',
  variant: DSInputVariant.outlined,
);

// Cards
DSCard(
  variant: DSCardVariant.elevated,
  child: Column(children: const [Text('Title'), Text('Body')]),
);
```

## DSThemeBuilder Options
You can pass options to control seed color and text theme application.

```
final theme = DSThemeBuilder.light(const DSThemeOptions(seed: Color(0xFF4F46E5)));
```

## Principles
- Single source of truth for visual decisions via tokens
- Android-first defaults with Material 3 semantics
- Small, composable components that wrap Material primitives
- Strict separation of tokens (no BuildContext) and theming

## Extending
- Add new tokens under `src/tokens/`
- Define component themes in `ds_theme.dart`
- Create DS components in `src/components/` using tokens + Theme

## Notes
- Dynamic color (Material You) can be supported by injecting a ColorScheme into `ThemeData` in the future.
