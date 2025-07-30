import 'package:chessground/chessground.dart';
import 'package:chesstrainer/constants/openings/vienna_gambit/vienna_gambit.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/providers/annotation_providers.dart';
import 'package:chesstrainer/modules/learn/providers/learn_providers.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/opening/providers/opening_pgn_provider.dart';
import 'package:chesstrainer/pages/learn/ui/coach.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

final viennaGambit = OpeningModel(
  id: 'vienna-gambit',
  name: 'Vienna Gambit',
  description: 'A classic opening that leads to rich tactical battles.',
  tags: ['White', 'Gambit', 'Aggressive'],
  linePaths: viennaGambitPaths.values.toList(),
  side: Side.white,
  ecoCode: 'C29',
  fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4PP2/2N5/PPPP2PP/R1BQKBNR b KQkq - 0 3',
);

class LearnGamePage extends ConsumerStatefulWidget {
  const LearnGamePage({super.key});

  @override
  ConsumerState<LearnGamePage> createState() => _LearnGamePageState();
}

class _LearnGamePageState extends ConsumerState<LearnGamePage> {
  int selectedLine = 1;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);

    final pgnGameProvider = ref.watch(
      pgnGameNotifierProvider(
        'assets/openings/vienna_gambit/vienna_gambit_$selectedLine.pgn',
      ),
    );

    void dropdownCallback(int? value) {
      if (value is int) {
        setState(() {
          selectedLine = value;
        });
      }
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
          bottomNavigationBar: NavigationBar(
            height: 48,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.lightbulb_outline),
                label: 'Coach',
              ),
              const NavigationDestination(
                icon: Icon(Icons.interests),
                label: 'Annotations',
              ),
            ],
          ),
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
                      items: List.generate(2, (index) {
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       IconButton(
                  //         onPressed: () {},
                  //         icon: const Icon(Icons.lightbulb_outline),
                  //       ),
                  //       IconButton(
                  //         onPressed: () {},
                  //         icon: const Icon(Icons.interests),
                  //       ),
                  //       IconButton(
                  //         onPressed: () {
                  //           learnNotifier.goToPrevious();
                  //         },
                  //         icon: const Icon(Icons.arrow_back_ios_rounded),
                  //       ),
                  //       IconButton(
                  //         onPressed: () {
                  //           learnNotifier.goToNext();
                  //         },
                  //         icon: const Icon(Icons.arrow_forward_ios_rounded),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              if (learnProvider.isFinished)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PrimaryButton(
                    text: 'Next Line',
                    onPressed: () {
                      setState(() {
                        selectedLine =
                            (selectedLine % 2) + 1; // Toggle between 1 and 2
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

// import 'package:chessground/chessground.dart';
// import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
// import 'package:chesstrainer/modules/learn/models/line.dart';
// import 'package:chesstrainer/modules/learn/providers/learn_providers.dart';
// import 'package:chesstrainer/modules/opening/providers/opening_pgn_provider.dart';
// import 'package:chesstrainer/pages/learn/ui/coach.dart';
// import 'package:chesstrainer/ui/layouts/default_layout.dart';
// import 'package:dartchess/dartchess.dart';
// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class LearnGamePage extends ConsumerStatefulWidget {
//   const LearnGamePage({super.key});

//   @override
//   ConsumerState<LearnGamePage> createState() => _LearnGamePageState();
// }

// class _LearnGamePageState extends ConsumerState<LearnGamePage> {
//   final IMap<Square, Annotation> _annotations = IMap();
//   int currentMoveIndex = 0; // Move this to class level

//   @override
//   Widget build(BuildContext context) {
//     final pgnGameAsync = ref.watch(
//       pgnGameProvider('assets/openings/vienna_gambit/vienna_gambit_1.pgn'),
//     );

//     final double screenWidth = MediaQuery.sizeOf(context).width;

//     return pgnGameAsync.when(
//       data: (pgnGame) {
//         // Debug: print les commentaires du jeu
//         print('Game comments: ${pgnGame.comments}');

//         final mainLine = pgnGame.moves.mainline();

//         // Helper to get the current move and navigation capability
//         final moves = mainLine.toList();
//         bool canGoPrevious = currentMoveIndex > 0;
//         bool canGoNext = currentMoveIndex < moves.length - 1;
//         PgnNodeData? currentMove = moves.isNotEmpty
//             ? moves[currentMoveIndex]
//             : null;

//         // final learnNotifier = ref.read(learnNotifierProvider(line).notifier);
//         // final chessState = ref.watch(chessNotifierProvider(line.playerSide));
//         // final learnState = ref.watch(learnNotifierProvider(line));

//         return DefaultLayout(
//           useSafeArea: false,
//           appBar: AppBar(
//             title: const Text(
//               'Vienna Gambit - Line 3 / 12',
//               style: TextStyle(fontWeight: FontWeight.w500),
//             ),
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back_ios_new_rounded),
//             ),
//           ),
//           child: PopScope(
//             canPop: false,
//             child: Column(
//               spacing: 12,
//               children: [
//                 Text(currentMove?.san ?? 'No move selected'),
//                 Text(
//                   mainLine.first.startingComments?.first ?? 'No main comment',
//                 ),
//                 Text(currentMove?.comments?.first ?? 'No comment'),

//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           if (canGoPrevious) {
//                             currentMoveIndex--;
//                             currentMove = moves[currentMoveIndex];
//                           }
//                         });
//                       },
//                       icon: const Icon(Icons.arrow_back_ios_new_rounded),
//                     ),
//                     Text('${currentMoveIndex + 1} / ${moves.length}'),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           if (canGoNext) {
//                             currentMoveIndex++;
//                             currentMove = moves[currentMoveIndex];
//                           }
//                         });
//                       },
//                       icon: const Icon(Icons.arrow_forward_ios_rounded),
//                     ),
//                   ],
//                 ),
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(minHeight: 156),
//                   child: const Coach(text: 'heyy'),
//                   // child: Coach(text: learnState.currentNode?.comment ?? ''),
//                 ),
//                 // Chessboard(
//                 //   settings: const ChessboardSettings(
//                 //     pieceAssets: PieceSet.meridaAssets,
//                 //     colorScheme: ChessboardColorScheme.blue,
//                 //   ),
//                 //   game: ref
//                 //       .read(chessNotifierProvider(PlayerSide.white).notifier)
//                 //       .getGameDataWith(
//                 //         onMove: (move, {isDrop}) {
//                 //           learnNotifier.playMove(move);
//                 //         },
//                 //       ),
//                 //   size: screenWidth,
//                 //   orientation: line.playerSide == PlayerSide.white
//                 //       ? Side.white
//                 //       : Side.black,
//                 //   fen: chessState.fen,
//                 //   annotations: _annotations.isNotEmpty ? _annotations : null,
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //   child: Row(
//                 //     children: [
//                 //       Expanded(
//                 //         child: FilledButton(
//                 //           onPressed: chessState.canGoToPrevious
//                 //               ? () => learnNotifier.goToPrevious()
//                 //               : null,
//                 //           child: const Text('Previous'),
//                 //         ),
//                 //       ),
//                 //       const SizedBox(width: 16),
//                 //       Expanded(
//                 //         child: FilledButton(
//                 //           onPressed: chessState.canGoToNext
//                 //               ? () => learnNotifier.goToNext()
//                 //               : null,
//                 //           child: const Text('Next'),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //   child: Row(
//                 //     spacing: 16,
//                 //     children: [
//                 //       Expanded(
//                 //         child: FilledButton(
//                 //           onPressed: () => learnNotifier.reset(),
//                 //           child: const Text('Reset'),
//                 //         ),
//                 //       ),
//                 //       Expanded(
//                 //         child: FilledButton(
//                 //           onPressed: () => print(line.toString()),
//                 //           child: const Text('Print Line'),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (error, stack) => Center(child: Text('Error: $error')),
//     );
//   }
// }
