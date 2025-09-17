import 'package:flutter/material.dart';
import '../tokens/radii.dart';
import '../tokens/spacing.dart';

enum DSButtonStyle { primary, secondary, outlined }

enum DSButtonSize { small, medium, large }

class DSButton extends StatelessWidget {
  const DSButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.style = DSButtonStyle.primary,
    this.size = DSButtonSize.medium,
    this.loading = false,
    this.fullWidth = false,
  });

  final String label;
  final Widget? icon;
  final Widget? trailingIcon;
  final VoidCallback? onPressed;
  final DSButtonStyle style;
  final DSButtonSize size;
  final bool loading;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final (height, spacing, textStyle) = switch (size) {
      DSButtonSize.small => (40.0, DSSpacing.sm, Theme.of(context).textTheme.labelLarge),
      DSButtonSize.medium => (48.0, DSSpacing.md, Theme.of(context).textTheme.labelLarge),
      DSButtonSize.large => (56.0, DSSpacing.lg, Theme.of(context).textTheme.titleSmall),
    };

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          SizedBox(height: height / 2.5, width: height / 2.5, child: const CircularProgressIndicator(strokeWidth: 2))
        else if (icon != null) ...[icon!, SizedBox(width: spacing)],
        Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle)),
        if (!loading && trailingIcon != null) ...[SizedBox(width: spacing), trailingIcon!],
      ],
    );

    final shape = RoundedRectangleBorder(borderRadius: DSRounders.md);
    final minSize = Size.fromHeight(height);

    switch (style) {
      case DSButtonStyle.primary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: FilledButton(
            onPressed: loading ? null : onPressed,
            style: FilledButton.styleFrom(minimumSize: minSize, shape: shape, padding: EdgeInsets.symmetric(horizontal: spacing * 2)),
            child: content,
          ),
        );
      case DSButtonStyle.secondary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: FilledButton.tonal(
            onPressed: loading ? null : onPressed,
            style: FilledButton.styleFrom(minimumSize: minSize, shape: shape, padding: EdgeInsets.symmetric(horizontal: spacing * 2)),
            child: content,
          ),
        );
      case DSButtonStyle.outlined:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: OutlinedButton.styleFrom(minimumSize: minSize, shape: shape, padding: EdgeInsets.symmetric(horizontal: spacing * 2)),
            child: content,
          ),
        );
    }
  }
}
