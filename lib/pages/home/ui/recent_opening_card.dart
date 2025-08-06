import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/ui/progress_indicators/linear_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double _kScreenRatio = 0.4;

class RecentOpeningCard extends StatefulWidget {
  final OpeningModel opening;
  final VoidCallback onPressed;

  const RecentOpeningCard({
    super.key,
    required this.opening,
    required this.onPressed,
  });

  @override
  State<RecentOpeningCard> createState() => _RecentOpeningCardState();
}

class _RecentOpeningCardState extends State<RecentOpeningCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Gaimon.selection();
        widget.onPressed.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _isPressed ? theme.colorScheme.surfaceDim : Colors.transparent,
        ),
        child: SizedBox(
          height: screenWidth * _kScreenRatio,
          child: Row(
            spacing: 12,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Chessboard.fixed(
                  settings: ChessboardSettings(
                    border: BoardBorder(
                      color: theme.colorScheme.surfaceBright,
                      width: 8,
                    ),
                    enableCoordinates: false,
                    pieceAssets: PieceSet.meridaAssets,
                    colorScheme: ChessboardColorScheme.blue,
                  ),
                  fen: widget.opening.fen,
                  size: screenWidth * _kScreenRatio,
                  orientation: widget.opening.side,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.opening.name,
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          'Continue were you left off!',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final currentUser = ref.watch(currentUserProvider);
                        final userLearnedOpenings =
                            currentUser?.learnedOpenings ?? [];
                        final progress = widget.opening.progressFor(
                          userLearnedOpenings,
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next: Line ${progress.learned + 1} / ${progress.total}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            LinearProgressBar(
                              percent: progress.percentage,
                              lineHeight: 20,
                            ),
                          ],
                        );
                      },
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
