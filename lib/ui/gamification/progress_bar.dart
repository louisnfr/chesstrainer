import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LinearProgressIndicator(
      value: 0.2,
      backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.2),
      color: theme.colorScheme.primary,
      minHeight: 20,
      semanticsLabel: 'Progress Bar',
      borderRadius: BorderRadius.circular(32),
    );
  }
}
