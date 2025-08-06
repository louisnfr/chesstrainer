import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/providers/annotation_provider.dart';
import 'package:chesstrainer/modules/learn/providers/learn_provider.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/opening/providers/opening_pgn_provider.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/practice/practice_coach.dart';
import 'package:chesstrainer/ui/progress_indicators/linear_progress_bar.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({super.key, required this.opening});

  final OpeningModel opening;

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  int? selectedLine;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final opening = widget.opening;
    final linesNumber = opening.linePaths.length;

    if (selectedLine == null) {
      final currentUser = ref.watch(currentUserProvider);
      final userLearnedOpenings = currentUser?.learnedOpenings ?? [];
      selectedLine = opening.getFirstUnlearnedLineIndex(userLearnedOpenings);
    }

    final pgnGameProvider = ref.watch(
      pgnGameNotifierProvider(
        'assets/openings/${opening.id}/${opening.id}_$selectedLine.pgn',
      ),
    );

    void dropdownCallback(int? value) {
      if (value is int) {
        setState(() => selectedLine = value);
      }
    }

    if (selectedLine == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return pgnGameProvider.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),

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

        return Scaffold(
          appBar: AppBar(title: Text(opening.name)),
          body: Column(
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
                    DropdownButton(
                      value: selectedLine,
                      items: List.generate(linesNumber, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text('Line ${index + 1}'),
                        );
                      }),
                      onChanged: dropdownCallback,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 128, child: PracticeCoach(pgnGame: pgnGame)),
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
                      setState(() {
                        selectedLine = ((selectedLine ?? 1) % linesNumber) + 1;
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
