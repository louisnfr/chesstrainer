import 'dart:async';

import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:chesstrainer/pages/examples/chessground.dart';
import 'package:chesstrainer/pages/examples/normal_game_page.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider); // Plus simple !

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
                  'Welcome back ${user?.displayName ?? 'Guest'}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Text(
            'Welcome back ${user?.displayName ?? 'Guest'}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const Text('Pick up where you left off'),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, learnRoute);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 8,
                  children: [
                    Image.network(
                      width: 64,
                      height: 64,
                      'https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/vitualis/phptwVuTc.png',
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vienna Game'),
                          Text(
                            'A classic opening that leads'
                            ' to rich tactical battles.',
                          ),
                        ],
                      ),
                    ),
                    const Icon(CupertinoIcons.book),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ChessgroundExample(title: 'Chessground example'),
                ),
              );
            },
            child: const Text('Chessground Example'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NormalGamePage()),
              );
            },
            child: const Text('Normal game example'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, registerRoute);
            },
            child: const Text('Create account'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
            },
            child: const Text('Sign Out'),
          ),
          TextButton(
            onPressed: () async {
              // await ref.read(authNotifierProvider.notifier).deleteAccount();
              // if (context.mounted) {
              //   unawaited(
              //     Navigator.pushNamedAndRemoveUntil(
              //       context,
              //       welcomeRoute,
              //       (_) => false,
              //     ),
              //   );
              // }
            },
            child: const Text(
              'DELETE USER',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
