import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/ui/progress_indicators/linear_progress_bar.dart';
import 'package:chesstrainer/ui/theme/dark_theme.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

const double _kScreenRatio = 0.33;

class OpeningCard extends ConsumerStatefulWidget {
  final OpeningModel opening;
  final VoidCallback onPressed;

  const OpeningCard({
    super.key,
    required this.opening,
    required this.onPressed,
  });

  @override
  ConsumerState<OpeningCard> createState() => _OpeningCardState();
}

class _OpeningCardState extends ConsumerState<OpeningCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final learnedOpenings = ref.watch(learnedOpeningsProvider);
    final progress = widget.opening.progressFor(learnedOpenings);

    final bool isWhite = widget.opening.side == Side.white;

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
                      width: 6,
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
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.opening.name,
                              style: theme.textTheme.headlineMedium,
                            ),
                            if (progress.percentage >= 1.0)
                              const Icon(
                                Symbols.bookmark_check,
                                color: AppColors.success,
                                size: 36,
                                fill: 1,
                              ),
                          ],
                        ),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isWhite ? Colors.white : Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isWhite ? 'White' : 'Black',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isWhite ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...widget.opening.tags.map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceBright,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${progress.total} Lines',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Expanded(
                          child: LinearProgressBar(
                            percent: progress.percentage,
                          ),
                        ),
                      ],
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
