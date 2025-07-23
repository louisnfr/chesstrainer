import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NormalGamePage extends ConsumerWidget {
  const NormalGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerSide = PlayerSide.both;
    final chessProvider = ref.watch(chessNotifierProvider(playerSide));
    final chessNotifier = ref.read(chessNotifierProvider(playerSide).notifier);

    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      useSafeArea: false,
      appBar: AppBar(title: const Text('Normal Game')),
      child: Column(
        children: [
          chessProvider.position.turn == Side.white
              ? const Text(
                  'White to move',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                )
              : const Text(
                  'Black to move',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
          Chessboard(
            game: chessNotifier.getGameData(),
            size: screenWidth,
            orientation: chessProvider.orientation,
            fen: chessProvider.fen,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => chessNotifier.goToPrevious(),
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              IconButton(
                onPressed: () => chessNotifier.goToNext(),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
          Wrap(
            children: [
              OutlinedButton(
                onPressed: () => chessNotifier.resetGame(),
                child: const Text('Reset Game'),
              ),
              OutlinedButton(
                onPressed: () => chessNotifier.undoMove(),
                child: const Text('Undo Move'),
              ),
              OutlinedButton(
                onPressed: () => chessNotifier.toggleOrientation(),
                child: const Text('Flip Board'),
              ),
            ],
          ),
          if (chessProvider.position.isCheck)
            if (chessProvider.position.isCheckmate)
              Column(
                children: [
                  const Text('Checkmate!'),
                  OutlinedButton(
                    onPressed: () => chessNotifier.resetGame(),
                    child: const Text('Play Again'),
                  ),
                ],
              )
            else
              const Text('Check!'),
        ],
      ),
    );
  }
}
