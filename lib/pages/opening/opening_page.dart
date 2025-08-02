import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/material.dart';

class OpeningPage extends StatelessWidget {
  const OpeningPage({super.key, required this.opening});

  final OpeningModel opening;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(title: Text(opening.name)),
      child: Column(
        children: [
          Text(
            'Chessboard with positions for ${opening.name}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
