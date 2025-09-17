import 'package:flutter/material.dart';

enum DSInputVariant { outlined, filled }

class DSInput extends StatelessWidget {
  const DSInput({
    super.key,
    required this.controller,
    this.variant = DSInputVariant.outlined,
    this.hint,
    this.label,
    this.helperText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.minLines,
    this.maxLines = 1,
    this.enabled = true,
  });

  final TextEditingController controller;
  final DSInputVariant variant;
  final String? hint;
  final String? label;
  final String? helperText;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == DSInputVariant.filled;
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: isFilled,
        fillColor: isFilled ? cs.surfaceContainerHighest.withValues(alpha: 0.3) : null,
      ),
    );
  }
}
