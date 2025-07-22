import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/opening/models/opening_difficulty.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/examples/chessground.dart';
import 'package:chesstrainer/pages/examples/normal_game_page.dart';
import 'package:chesstrainer/pages/home/ui/opening_card.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final viennaGambit = const OpeningModel(
  id: 'vienna-gambit',
  name: 'Vienna Gambit',
  description: 'A classic opening that leads to rich tactical battles.',
  difficulty: OpeningDifficulty.intermediate,
  ecoCode: 'C29',
  lineCount: 3,
  fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4PP2/2N5/PPPP2PP/R1BQKBNR b KQkq - 0 3',
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return DefaultLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.blueGrey[50],
            ),
            child: Column(
              children: [
                Text(
                  'Welcome back ${user?.displayName ?? '!'}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Text('Pick up where you left off'),
          OpeningCard(opening: viennaGambit),
          TextButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
            },
            child: const Text('Sign Out'),
          ),
          // Text
        ],
      ),
    );
  }
}


// void Button(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             const ChessgroundExample(title: 'Chessground example'),
          //       ),
          //     );
          //   },
          //   child: const Text('Chessground Example'),
          // ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const NormalGamePage()),
          //     );
          //   },
          //   child: const Text('Normal game example'),
          // ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, registerRoute);
          //   },
          //   child: const Text('Create account'),
          // ),
