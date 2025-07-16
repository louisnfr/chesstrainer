import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/chess_controller.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

/// Exemple d'utilisation du ChessController pour une partie normale
/// sans logique d'apprentissage
class NormalGamePage extends StatefulWidget {
  const NormalGamePage({super.key});

  @override
  State<NormalGamePage> createState() => _NormalGamePageState();
}

class _NormalGamePageState extends State<NormalGamePage> {
  late ChessController _controller;

  @override
  void initState() {
    _controller = ChessController();
    _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      appBar: AppBar(title: const Text('Normal Game')),
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return Column(
            children: [
              const Text('Play a normal chess game without training mode.'),
              _controller.position.turn == Side.white
                  ? const Text(
                      'White to move',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    )
                  : const Text(
                      'Black to move',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
              Chessboard(
                game: _controller.getGameData(),
                size: screenWidth,
                orientation: _controller.orientation,
                fen: _controller.fen,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _controller.resetGame();
                    },
                    child: const Text('Reset Game'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _controller.undoMove();
                    },
                    child: const Text('Undo Move'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _controller.setOrientation(
                        _controller.orientation == Side.white
                            ? Side.black
                            : Side.white,
                      );
                    },
                    child: const Text('Flip Board'),
                  ),
                ],
              ),
              if (_controller.position.isCheck)
                if (_controller.position.isCheckmate)
                  Column(
                    children: [
                      const Text('Checkmate!'),
                      OutlinedButton(
                        onPressed: () {
                          _controller.resetGame();
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
