import 'package:chessground/chessground.dart';
import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/ui/theme/light_theme.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class OpeningCard extends StatelessWidget {
  const OpeningCard({super.key, required this.opening});

  final OpeningModel opening;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, learnRoute, arguments: opening);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          spacing: 12,
          children: [
            Row(
              spacing: 12,
              children: [
                Chessboard.fixed(
                  settings: ChessboardSettings(
                    enableCoordinates: false,
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                  fen: opening.fen,
                  size: 128,
                  orientation: Side.white,
                  // annotations: IMap({
                  //   const Square(29): Annotation(
                  //     color: Colors.red,
                  //     symbol: 'X',
                  //     // widget: Icon(Icons.close, color: Colors.white, size: 16),
                  //     widget: Image.asset(
                  //       'assets/images/incorrect.png',
                  //       width: 2,
                  //       height: 2,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // }),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        opening.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(opening.description),
                      Text(
                        '${opening.lineCount} lines',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              color: AppColors.primaryColor,
              value: 0.5,
              minHeight: 8,
              borderRadius: BorderRadius.circular(32),
            ),
          ],
        ),
      ),
    );
  }
}
