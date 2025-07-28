import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.all(Radius.circular(32)),
      ),
      child: Text(label, style: theme.textTheme.labelSmall),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadiusGeometry.circular(64),
      // ),
    );
  }
}
