import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/chess_controller.dart';
import 'package:chesstrainer/modules/chess/learn_controller.dart';
import 'package:chesstrainer/modules/chess/models/node.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

/// Exemple d'utilisation du ChessController pour une partie normale
/// sans logique d'apprentissage
class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  late ChessController _chessController;
  LearnController? _learnController;
  late Future<Line> _lineFuture;

  @override
  void initState() {
    super.initState();
    _chessController = ChessController();
    _lineFuture = loadLine('assets/openings/vienna_gambit/main_line.json');
  }

  @override
  void dispose() {
    _chessController.dispose();
    _learnController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      safeAreaMinimum: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      appBar: AppBar(
        title: const Text('Learn Game'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      child: PopScope(
        canPop: false,
        child: FutureBuilder(
          future: _lineFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (asyncSnapshot.hasError) {
              return Center(child: Text('Error: ${asyncSnapshot.error}'));
            }
            final Line line = asyncSnapshot.data!;
            _learnController ??= LearnController(_chessController, line);

            return ListenableBuilder(
              listenable: Listenable.merge([
                _chessController,
                _learnController,
              ]),
              builder: (context, child) {
                return Column(
                  children: [
                    const Text(
                      'Play a learn chess game with right and wrong moves.',
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              _learnController!.currentNode?.isMainLine == true
                              ? Colors.green
                              : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        _learnController!.currentNode?.isMainLine == true
                            ? _learnController!.currentNode?.comment ?? ''
                            : '${_learnController!.currentNode?.move} is an '
                                  '${_learnController!.currentNode?.comment}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              _learnController!.currentNode?.isMainLine == true
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                    Text(_chessController.moveHistory.join(' ')),
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
                          _learnController!.playMove(move);
                        },
                      ),
                      size: screenWidth,
                      orientation: _chessController.orientation,
                      fen: _chessController.fen,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            _chessController.goToPrevious();
                            _learnController!.goToPrevious();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        IconButton(
                          onPressed: () {
                            _chessController.goToNext();
                            _learnController!.goToNext();
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
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
            );
          },
        ),
      ),
    );
  }
}
