import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/ui/buttons/secondary_button.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OpeningPage extends ConsumerWidget {
  const OpeningPage({super.key, required this.opening});

  final OpeningModel opening;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return DefaultLayout(
      appBar: AppBar(title: Text(opening.name)),
      child: Column(
        spacing: 12,
        children: [
          LinearPercentIndicator(
            percent: 50 / 100,
            lineHeight: 24,
            backgroundColor: Colors.grey.shade300,
            progressColor: Colors.blue,
            barRadius: const Radius.circular(32),
          ),
          Chessboard.fixed(
            size: screenWidth * 0.8,
            orientation: opening.side,
            fen: opening.fen,
          ),
          Text(opening.description),
          PrimaryButton(text: 'Learn', onPressed: () {}),
          const Text('discover improve master'),
          SecondaryButton(text: 'Practice', onPressed: () {}),
        ],
      ),
    );
  }
}
