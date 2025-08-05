import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/ui/buttons/secondary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

const double _kScreenRatio = 0.85;

class OpeningPage extends ConsumerWidget {
  const OpeningPage({super.key, required this.opening});

  final OpeningModel opening;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    final currentUser = ref.watch(currentUserProvider);
    final userLearnedOpenings = currentUser?.learnedOpenings ?? [];
    final progress = opening.progressFor(userLearnedOpenings);

    final bool isWhite = opening.side == Side.white;

    return Scaffold(
      appBar: AppBar(title: Text(opening.name)),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
            spacing: 24,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You learned ${progress.learned} lines out of '
                    '${progress.total}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  LinearPercentIndicator(
                    padding: const EdgeInsets.all(0),
                    barRadius: const Radius.circular(32),
                    lineHeight: 24,
                    animation: true,
                    animationDuration: 1000,
                    animateFromLastPercent: true,
                    progressColor: theme.colorScheme.primary,
                    percent: progress.percentage,
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isWhite ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isWhite ? 'White' : 'Black',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isWhite ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...opening.tags.map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Chessboard.fixed(
                settings: ChessboardSettings(
                  pieceAssets: PieceSet.meridaAssets,
                  colorScheme: ChessboardColorScheme.blue,
                  border: BoardBorder(
                    color: theme.colorScheme.surfaceBright,
                    width: 16,
                  ),
                ),
                size: screenWidth * _kScreenRatio,
                orientation: opening.side,
                fen: opening.fen,
              ),
              Text(
                opening.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),

              Column(
                spacing: 12,
                children: [
                  PrimaryButton(
                    text: 'Learn',
                    icon: Image.asset(
                      'assets/images/icons/learn.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearnPage(opening: opening),
                        ),
                      );
                    },
                  ),
                  SecondaryButton(
                    text: 'Practice',
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/icons/practice.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              // const Text('discover improve master'),
            ],
          ),
        ),
      ),
    );
  }
}
