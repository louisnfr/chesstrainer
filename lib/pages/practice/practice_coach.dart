import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/providers/learn_providers.dart';
import 'package:chesstrainer/ui/theme/dark_theme.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PracticeCoach extends ConsumerWidget {
  const PracticeCoach({super.key, required this.pgnGame});

  final PgnGame pgnGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final playerSide = pgnGame.headers['PlayerSide'] == 'white'
        ? PlayerSide.white
        : PlayerSide.black;

    final chessProvider = ref.watch(chessNotifierProvider(playerSide));
    final learnProvider = ref.watch(learnNotifierProvider(pgnGame));

    final comments = learnProvider.currentNodeData?.comments ?? [];
    final instructionComment = comments.isNotEmpty
        ? comments.first.endsWith('is an incorrect move!')
              ? comments.first
              : "What's the move here?"
        : null;
    final computerComment = chessProvider.playerSide == PlayerSide.white
        ? "Black's turn..."
        : "White's turn...";

    final completionComment = comments.length > 1 ? comments.last : null;

    final displayMessage =
        (learnProvider.isFinished && completionComment != null
        ? completionComment
        : (instructionComment ?? computerComment));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/images/coach2.png'),
            width: 64,
            height: 64,
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: 8,
                  child: CustomPaint(
                    painter: BubbleTrianglePainter(color: AppColors.white),
                    size: const Size(10, 16),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleTrianglePainter extends CustomPainter {
  final Color color;

  BubbleTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
