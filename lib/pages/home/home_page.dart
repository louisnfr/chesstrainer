import 'package:chesstrainer/constants/routes.dart';
import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';
import 'package:chesstrainer/modules/user/providers/user_provider.dart';
import 'package:chesstrainer/pages/examples/chessground.dart';
import 'package:chesstrainer/pages/examples/normal_game_page.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Utilisation du provider
    final user = ref.watch(currentUserProvider);

    return DefaultLayout(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: const Text('Learn Chess Openings'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('User Info:'),
                Text('UID: ${user?.uid ?? 'Not connected'}'),
                Text('Username: ${user?.username ?? 'Not connected'}'),
                Text('Anonymous: ${user?.isAnonymous ?? 'Unknown'}'),
              ],
            ),
          ),
          Text(
            'Hi ${user?.username ?? 'Guest'}!',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
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
              await UserService.deleteUserData();
              await AuthService.deleteUserAccount();
              await ref.read(userNotifierProvider.notifier).deleteUser();
            },
            child: const Text('DELETE USER'),
          ),
        ],
      ),
    );
  }
}
