import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/pages/practice/practice_page.dart';
import 'package:chesstrainer/ui/buttons/primary_button.dart';
import 'package:chesstrainer/ui/buttons/secondary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:chesstrainer/ui/progress_indicators/linear_progress_bar.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      bottomNavigationBar: Container(
        color: theme.colorScheme.surfaceDim,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PracticePage(opening: opening),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/images/icons/practice.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageLayout(
        verticalPadding: 0,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  LinearProgressBar(
                    percent: progress.percentage,
                    lineHeight: 24,
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceBright,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About this opening',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      opening.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 0,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
