import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/TBD_chess_controller.dart';
import 'package:chesstrainer/modules/chess/TBD_learn_controller.dart';
import 'package:chesstrainer/modules/learn/models/line.dart';
import 'package:chesstrainer/pages/learn/ui/coach.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:chesstrainer/ui/theme/theme.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  LearnController? _learnController;
  late ChessController _chessController;
  late Future<Line> _lineFuture;
  IMap<Square, Annotation> _annotations = IMap();

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
        title: const Text(
          'Vienna Gambit - Line 3 / 12',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
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
                  spacing: 12,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        color: AppColors.primaryColor,
                        value: 0.5,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    Coach(
                      text: _learnController!.currentNode?.isMainLine == true
                          ? _learnController!.currentNode?.comment ?? ''
                          : '${_learnController!.currentNode?.move} is an '
                                '${_learnController!.currentNode?.comment}',
                    ),
                    Text(_chessController.moveHistory.join(' ')),
                    Chessboard(
                      game: _chessController.getGameDataWith(
                        onMove: (move, {bool? isDrop}) {
                          final isCorrect = _learnController!.playMove(move);
                          // Si le coup est incorrect, ajouter une croix rouge sur la case de destination
                          if (!isCorrect) {
                            setState(() {
                              // Créer une croix en utilisant un cercle rouge épais
                              _annotations = IMap({
                                Square(move.to): Annotation(
                                  color: Colors.red,
                                  symbol: 'X',
                                  // widget: Icon(Icons.close, color: Colors.white, size: 16),
                                  widget: Image.asset(
                                    'assets/images/incorrect.png',
                                    width: 128,
                                    height: 128,
                                    color: Colors.white,
                                  ),
                                ),
                              });
                            });
                          } else {
                            setState(() {
                              _annotations = IMap();
                            });
                          }
                        },
                      ),
                      size: screenWidth,
                      orientation: _chessController.orientation,
                      fen: _chessController.fen,
                      annotations: _annotations.isNotEmpty
                          ? _annotations
                          : null,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            _chessController.goToPrevious();
                            _learnController!.goToPrevious();
                            // Effacer les marques d'erreur lors de la navigation
                            setState(() {
                              _annotations = IMap();
                            });
                          },
                          icon: const Icon(Icons.arrow_back_ios_new),
                        ),
                        IconButton(
                          onPressed: () {
                            _chessController.goToNext();
                            _learnController!.goToNext();
                            // Effacer les marques d'erreur lors de la navigation
                            setState(() {
                              _annotations = IMap();
                            });
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
