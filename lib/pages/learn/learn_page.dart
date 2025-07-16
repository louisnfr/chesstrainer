import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/chess_learn_controller.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  // late ChessLearnController _controller;

  // @override
  // void initState() {
  //   _controller = ChessLearnController();
  //   _controller.setMainLine(['e4', 'e5', 'Nc3', 'Nf6', 'f4']);
  //   _controller.setMoveCallback(_onMove);
  //   _controller.setLineCompletedCallback(_onLineCompleted);
  //   _controller.initialize();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  // void _onMove(String move, bool isCorrect) {
  //   if (isCorrect) {
  //     print('Correct ! Move: $move');
  //   } else {
  //     print('Incorrect. Expected: ${_controller.nextExpectedMove}, Got: $move');
  //   }
  // }

  // void _onLineCompleted() {
  //   print('Congrats ! Line completed');
  // }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      appBar: AppBar(title: const Text('Vienna Game')),
      child: const Text('wip'),
      // child: ListenableBuilder(
      //   listenable: _controller,
      //   builder: (context, child) {
      //     return Column(
      //       children: [
      //         const Text(
      //           'Welcome to the Vienna Game! '
      //           'This is a classic opening that leads to rich tactical battles.\n\n'
      //           'Start by playing e4 to control the center.',
      //         ),
      //         _controller.position.turn == Side.white
      //             ? const Text(
      //                 'White to move',
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.w600,
      //                   fontSize: 24,
      //                 ),
      //               )
      //             : const Text(
      //                 'Black to move',
      //                 style: TextStyle(
      //                   fontWeight: FontWeight.w600,
      //                   fontSize: 24,
      //                 ),
      //               ),
      //         Chessboard(
      //           game: _controller.getGameData(),
      //           size: screenWidth,
      //           orientation: _controller.orientation,
      //           fen: _controller.fen,
      //         ),
      //         if (_controller.position.isCheck)
      //           if (_controller.position.isCheckmate)
      //             Column(
      //               children: [
      //                 const Text('Checkmate!'),
      //                 OutlinedButton(
      //                   onPressed: () {
      //                     _controller.resetGame();
      //                   },
      //                   child: const Text('Play Again'),
      //                 ),
      //               ],
      //             )
      //           else
      //             const Text('Check!'),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
