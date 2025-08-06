import 'package:chesstrainer/constants/openings.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/home/ui/opening_card.dart';
import 'package:chesstrainer/pages/home/ui/recent_opening_card.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/pages/opening/opening_page.dart';
import 'package:chesstrainer/ui/layouts/page_layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final allOpenings = openings;

    final lastOpeningId = ref.watch(lastOpeningProvider);
    final lastOpening = lastOpeningId != null
        ? allOpenings.firstWhere((opening) => opening.id == lastOpeningId)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: PageLayout(
        verticalPadding: 0,
        horizontalPadding: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lastOpening != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  'Continue Learning',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              RecentOpeningCard(
                opening: lastOpening,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearnPage(opening: lastOpening),
                    ),
                  );
                },
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'All Openings',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(allOpenings.length, (index) {
                return Column(
                  children: [
                    OpeningCard(
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
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth / 8,
                      ),
                      child: const Divider(),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
