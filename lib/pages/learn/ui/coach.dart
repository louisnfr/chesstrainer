import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/providers/learn_providers.dart';
import 'package:chesstrainer/ui/theme/light_theme.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Coach extends ConsumerWidget {
  const Coach({super.key, required this.pgnGame});

  final PgnGame pgnGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerSide = pgnGame.headers['PLayerSide'] == 'white'
        ? PlayerSide.white
        : PlayerSide.black;

    final chessProvider = ref.watch(chessNotifierProvider(playerSide));
    final learnProvider = ref.watch(learnNotifierProvider(pgnGame));

    final comments = learnProvider.currentNodeData?.comments ?? [];
    final instructionComment = comments.isNotEmpty ? comments.first : null;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.brown,
            child: Image(
              image: AssetImage('assets/images/coach.png'),
              width: 28,
              height: 28,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Triangle pointer sur la gauche
                Positioned(
                  left: 0,
                  top: 12,
                  child: CustomPaint(
                    painter: BubbleTrianglePainter(color: AppColors.white),
                    size: const Size(8, 16),
                  ),
                ),
                // Container principal avec marge à gauche pour le triangle
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    displayMessage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
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
    // Créer un triangle pointant vers la gauche
    path.moveTo(size.width, 0); // Point en haut à droite
    path.lineTo(0, size.height / 2); // Point à gauche (milieu)
    path.lineTo(size.width, size.height); // Point en bas à droite
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
