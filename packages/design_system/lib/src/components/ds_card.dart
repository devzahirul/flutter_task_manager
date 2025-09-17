import 'package:flutter/material.dart';
import '../tokens/elevations.dart';
import '../tokens/spacing.dart';

enum DSCardVariant { elevated, filled, outlined }

class DSCard extends StatelessWidget {
  const DSCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DSSpacing.xl),
    this.variant = DSCardVariant.elevated,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final DSCardVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final shape = Theme.of(context).cardTheme.shape;

    final (elevation, color, border) = switch (variant) {
      DSCardVariant.elevated => (DSElevations.level1, Theme.of(context).cardTheme.color, null as OutlinedBorder?),
      DSCardVariant.filled => (DSElevations.level0, cs.surfaceContainerHighest.withValues(alpha: 0.6), null),
      DSCardVariant.outlined => (DSElevations.level0, Theme.of(context).cardTheme.color,
          RoundedRectangleBorder(side: BorderSide(color: cs.outline), borderRadius: BorderRadius.circular(12))),
    };

    final card = Card(
      elevation: elevation,
      clipBehavior: Clip.antiAlias,
      color: color,
      shape: border ?? shape,
      child: Padding(padding: padding, child: child),
    );
    if (onTap == null) return card;
    return InkWell(onTap: onTap, child: card);
  }
}
