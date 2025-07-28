import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = 0.2;

    return Column(
      children: [
        Row(
          children: [
            Text('Progress', style: theme.textTheme.labelSmall),
            const Spacer(),
            Text(
              '${(value * 100).toInt()}%',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
        LinearProgressIndicator(
          value: 0.2,
          backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          color: theme.colorScheme.primary,
          minHeight: 12,
          semanticsLabel: 'Progress Bar',
          borderRadius: BorderRadius.circular(16),
        ),
      ],
    );
  }
}
