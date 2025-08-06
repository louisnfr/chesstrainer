import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/learn/providers/learn_provider.dart';
import 'package:chesstrainer/modules/learn/providers/pgn_game_provider.dart';
import 'package:chesstrainer/modules/learn/providers/selected_line_provider.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/learn/providers/annotation_provider.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/pages/learn/learn_coach.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:chesstrainer/ui/progress_indicators/linear_progress_bar.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LearnPage extends ConsumerStatefulWidget {
  const LearnPage({required this.opening, super.key});

  final OpeningModel opening;

  @override
  ConsumerState<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends ConsumerState<LearnPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    final opening = widget.opening;
    final linesNumber = opening.linePaths.length;

    // Utiliser les nouveaux providers
    final selectedLine = ref.watch(selectedLineProvider(opening));
    final selectedLineNotifier = ref.read(
      selectedLineProvider(opening).notifier,
    );

    if (selectedLine == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final pgnGameAsync = ref.watch(pgnGameProvider(opening));

    void dropdownCallback(int? value) {
      if (value is int) {
        selectedLineNotifier.selectLine(value);
        // La logique de rechargement est gérée par le listener ci-dessous
      }
    }

    return pgnGameAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(opening.name)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(opening.name)),
        body: Center(child: Text('Error: $error')),
      ),
      data: (PgnGame pgnGame) {
        final playerSide = pgnGame.headers['PlayerSide'] == 'white'
            ? PlayerSide.white
            : PlayerSide.black;

        final chessProvider = ref.watch(chessNotifierProvider(playerSide));
        final learnProvider = ref.watch(learnNotifierProvider(pgnGame));
        final annotations = ref.watch(annotationProvider(pgnGame));

        final learnNotifier = ref.watch(
          learnNotifierProvider(pgnGame).notifier,
        );

        // Réinitialiser le chess provider quand on change de ligne
        ref.listen(selectedLineProvider(opening), (previous, next) {
          if (previous != next && next != null) {
            // Charger la nouvelle ligne et réinitialiser l'état
            ref.read(pgnGameProvider(opening).notifier).loadLine(next).then((
              _,
            ) {
              final newPgnGame = ref.read(pgnGameProvider(opening)).value;
              if (newPgnGame != null) {
                learnNotifier.resetWithNewPgn(newPgnGame);
              }
            });
          }
        });

        return Scaffold(
          appBar: AppBar(title: Text(opening.name)),
          body: PageLayout(
            horizontalPadding: 0,
            child: Column(
              spacing: 12,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: LinearProgressBar(
                          lineHeight: 24,
                          percent:
                              learnProvider.currentStep /
                              (learnProvider.lineLength),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceBright,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton(
                          padding: const EdgeInsets.all(0),
                          borderRadius: BorderRadius.circular(8),
                          value: selectedLine,
                          dropdownColor:
                              theme.colorScheme.surfaceContainerHighest,
                          underline: Container(), // Enlève la ligne du bas
                          style: TextStyle(color: theme.colorScheme.onSurface),
                          items: List.generate(linesNumber, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text(
                                'Line ${index + 1}',
                                style: theme.textTheme.labelLarge,
                              ),
                            );
                          }),
                          onChanged: dropdownCallback,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 128, child: LearnCoach(pgnGame: pgnGame)),
                Column(
                  children: [
                    Chessboard(
                      settings: const ChessboardSettings(
                        pieceAssets: PieceSet.meridaAssets,
                        colorScheme: ChessboardColorScheme.blue,
                      ),
                      game: learnNotifier.getGameData(),
                      size: screenWidth,
                      orientation: chessProvider.orientation,
                      fen: chessProvider.fen,
                      lastMove: chessProvider.lastMove,
                      annotations: annotations,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.lightbulb_outline),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.interests),
                          ),
                          IconButton(
                            onPressed: () {
                              learnNotifier.goToPrevious();
                            },
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              learnNotifier.goToNext();
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (learnProvider.isFinished)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PrimaryButton(
                      text: 'Next Line',
                      onPressed: () {
                        final nextLine = (selectedLine % linesNumber) + 1;
                        selectedLineNotifier.selectLine(nextLine);
                        // La logique de rechargement est gérée par le listener
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
