import 'package:chessground/chessground.dart';
import 'package:chesstrainer/constants/openings.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/providers/annotation_providers.dart';
import 'package:chesstrainer/modules/learn/providers/learn_providers.dart';
import 'package:chesstrainer/modules/opening/providers/opening_pgn_provider.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/learn/ui/coach.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LearnGamePage extends ConsumerStatefulWidget {
  const LearnGamePage({super.key});

  @override
  ConsumerState<LearnGamePage> createState() => _LearnGamePageState();
}

class _LearnGamePageState extends ConsumerState<LearnGamePage> {
  int? selectedLine; // Nullable au début

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    final linesNumber = viennaGambit.linePaths.length;

    // Initialiser selectedLine avec la première ligne non apprise
    if (selectedLine == null) {
      final currentUser = ref.watch(currentUserProvider);
      final userLearnedOpenings = currentUser?.learnedOpenings ?? [];
      selectedLine = viennaGambit.getFirstUnlearnedLineIndex(
        userLearnedOpenings,
      );
    }

    final pgnGameProvider = ref.watch(
      pgnGameNotifierProvider(
        'assets/openings/vienna_gambit/vienna_gambit_$selectedLine.pgn',
      ),
    );

    void dropdownCallback(int? value) {
      if (value is int) {
        setState(() => selectedLine = value);
      }
    }

    // Return loading si selectedLine n'est pas encore initialisé
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

        return DefaultLayout(
          useSafeArea: false,
          // useSafeAreaLeft: false,
          // useSafeAreaRight: false,
          // useSafeAreaTop: false,
          appBar: AppBar(title: const Text('Vienna Gambit')),
          // bottomNavigationBar: NavigationBar(
          //   height: 48,
          //   destinations: [
          //     const NavigationDestination(
          //       icon: Icon(Icons.lightbulb_outline),
          //       label: 'Coach',
          //     ),
          //     const NavigationDestination(
          //       icon: Icon(Icons.interests),
          //       label: 'Annotations',
          //     ),
          //   ],
          // ),
          child: Column(
            spacing: 12,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        // backgroundColor: Colors.grey.shade300,
                        barRadius: const Radius.circular(8),
                        lineHeight: 16,
                        animation: true,
                        animationDuration: 250,
                        animateFromLastPercent: true,
                        progressColor: theme.colorScheme.primary,
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
              SizedBox(height: 128, child: Coach(pgnGame: pgnGame)),

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
