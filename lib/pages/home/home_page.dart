import 'package:chesstrainer/constants/openings.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/home/ui/opening_card.dart';
import 'package:chesstrainer/pages/home/ui/recent_opening_card.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/pages/opening/opening_page.dart';
import 'package:chesstrainer/ui/buttons/action_button.dart';
import 'package:chesstrainer/ui/buttons/outline_button.dart';
import 'package:chesstrainer/ui/buttons/secondary_button.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:chesstrainer/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    final allOpenings = openings;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back, ${user?.displayName ?? 'Guest'}!',
                style: theme.textTheme.headlineMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'CONTINUE LEARNING',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              RecentOpeningCard(
                opening: viennaGambit,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LearnPage(opening: viennaGambit),
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
                  children: List.generate(allOpenings.length, (index) {
                    return OpeningCard(
                      opening: allOpenings[index],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OpeningPage(opening: allOpenings[index]),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),

              // * Dev tools
              const SizedBox(height: 12),
              Text('Dev Tools', style: theme.textTheme.headlineMedium),
              Row(
                children: [
                  ActionButton(
                    onPressed: () {},
                    icon: Icons.play_arrow_rounded,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  PrimaryButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const LearnGamePage(),
                      //   ),
                      // );
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
                    onPressed: () {
                      final auth = ref.read(authNotifierProvider.notifier);
                      auth.signOut();
                    },
                    text: 'log out',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
