import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/chess_controller.dart';
import 'package:chesstrainer/modules/chess/learn_controller.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

/// Exemple d'utilisation du ChessController pour une partie normale
/// sans logique d'apprentissage
class LearnGamePage extends StatefulWidget {
  const LearnGamePage({super.key});

  @override
  State<LearnGamePage> createState() => _LearnGamePageState();
}

class _LearnGamePageState extends State<LearnGamePage> {
  late ChessController _chessController;
  late LearnController _learnController;

  @override
  void initState() {
    _chessController = ChessController();
    _chessController.initialize();
    _learnController = LearnController(_chessController);
    super.initState();
  }

  @override
  void dispose() {
    _chessController.dispose();
    _learnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      appBar: AppBar(title: const Text('Learn Game')),
      child: ListenableBuilder(
        listenable: _learnController,
        builder: (context, child) {
          return Column(
            children: [
              const Text('Play a learn chess game with right and wrong moves.'),

              Text(
                _chessController.position.turn == Side.white
                    ? 'White to move'
                    : 'Black to move',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),

              Chessboard(
                game: _chessController.getGameDataWith(
                  onMove: (move, {bool? isDrop}) {
                    final ok = _learnController.playMove(move);
                    if (ok) {
                      print('good');
                    } else {
                      print('not good');
                    }
                  },
                ),
                size: screenWidth,
                orientation: _chessController.orientation,
                fen: _chessController.fen,
              ),
              const Text(''),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     OutlinedButton(
              //       onPressed: () {
              //         _chessController.resetGame();
              //       },
              //       child: const Text('Reset Game'),
              //     ),
              //     OutlinedButton(
              //       onPressed: () {
              //         _chessController.undoMove();
              //       },
              //       child: const Text('Undo Move'),
              //     ),
              //     OutlinedButton(
              //       onPressed: () {
              //         _chessController.setOrientation(
              //           _chessController.orientation == Side.white
              //               ? Side.black
              //               : Side.white,
              //         );
              //       },
              //       child: const Text('Flip Board'),
              //     ),
              //   ],
              // ),
              if (_chessController.position.isCheck)
                if (_chessController.position.isCheckmate)
                  Column(
                    children: [
                      const Text('Checkmate!'),
                      OutlinedButton(
                        onPressed: () {
                          _chessController.resetGame();
                        },
                        child: const Text('Play Again'),
                      ),
                    ],
                  )
                else
                  const Text('Check!'),
            ],
          );
        },
      ),
    );
  }
}
