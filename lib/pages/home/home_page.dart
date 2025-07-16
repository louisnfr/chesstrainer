import 'package:chesstrainer/pages/examples/chessground.dart';
import 'package:chesstrainer/pages/examples/learn_game.dart';
import 'package:chesstrainer/pages/examples/normal_game_page.dart';
import 'package:chesstrainer/pages/learn/learn_page.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      safeAreaMinimum: const EdgeInsets.symmetric(horizontal: 16),
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: const Text('Learn Chess Openings'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hi Louis!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          ),
          const Text('Pick up where you left off'),
          GestureDetector(
            onTap: () {
              // Navigate to the opening details page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnPage()),
              );
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
            child: const Text('See Chessground Example'),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearnGamePage()),
              );
            },
            child: const Text('Learn game example'),
          ),
        ],
      ),
    );
  }
}
