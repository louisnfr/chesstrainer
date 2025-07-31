import 'package:chesstrainer/constants/openings.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/pages/examples/learn_game_page.dart';
import 'package:chesstrainer/pages/home/ui/navigation_bar.dart';
import 'package:chesstrainer/pages/home/ui/opening_card.dart';
import 'package:chesstrainer/pages/home/ui/opening_card_2.dart';
import 'package:chesstrainer/ui/buttons/action_button.dart';
import 'package:chesstrainer/ui/buttons/outline_button.dart';
import 'package:chesstrainer/ui/buttons/secondary_button.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final viennaGambit = OpeningModel(
  id: 'vienna-gambit',
  name: 'Vienna Gambit',
  description: 'A classic opening that leads to rich tactical battles.',
  tags: ['e4', 'Aggressive'],
  linePaths: viennaGambitPaths.values.toList(),
  side: Side.white,
  ecoCode: 'C29',
  fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4PP2/2N5/PPPP2PP/R1BQKBNR b KQkq - 0 3',
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultLayout(
      useSafeAreaBottom: false,
      useSafeAreaTop: false,
      appBar: AppBar(
        title: Text('Openings', style: theme.textTheme.displayLarge),
      ),
      bottomNavigationBar: const HomeNavigationBar(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'CONTINUE LEARNING',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            OpeningCard(
              opening: viennaGambit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LearnGamePage(),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'ALL OPENINGS',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(6, (index) {
                  return OpeningCard2(opening: viennaGambit, onPressed: () {});
                }),
              ),
            ),

            // * Dev tools
            const SizedBox(height: 12),
            Text('Dev Tools', style: theme.textTheme.headlineMedium),
            Row(
              children: [
                ActionButton(onPressed: () {}, icon: Icons.play_arrow_rounded),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                PrimaryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LearnGamePage(),
                      ),
                    );
                  },
                  text: 'Learn game example',
                ),
                PrimaryButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ChessgroundExample(
                    //       title: 'Chessground example',
                    //     ),
                    //   ),
                    // );
                  },
                  text: 'Chessground Example prim',
                ),
                SecondaryButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const NormalGamePage(),
                    //   ),
                    // );
                  },
                  text: 'Normal game example sec',
                ),
                OutlineButton(
                  onPressed: () {},
                  text: 'Normal game example out',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
