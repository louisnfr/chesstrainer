import 'package:chesstrainer/constants/routes.dart';
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('User Info:'), Text('**'), Text('**')],
            ),
          ),
          const Text(
            'Hi Louis!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }
}
