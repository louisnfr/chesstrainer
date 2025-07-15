import 'package:chessground/chessground.dart';
import 'package:chesstrainer/ui/layouts/default_layout.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  Position position = Chess.initial;
  Side orientation = Side.white;
  String fen = kInitialBoardFEN;
  ValidMoves validMoves = IMap(const {});
  Position? lastPos;
  NormalMove? lastMove;
  NormalMove? promotionMove;
  NormalMove? premove;

  int _index = 0;

  List<String> mainLine = ['e4', 'e5', 'Nc3', 'Nf6', 'f4'];

  @override
  void initState() {
    validMoves = makeLegalMoves(position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DefaultLayout(
      appBar: AppBar(title: const Text('Vienna Game')),
      child: Column(
        children: [
          const Text(
            'Welcome to the Vienna Game! '
            'This is a classic opening that leads to rich tactical battles.\n\n'
            'Start by playing e4 to control the center.',
          ),
          position.turn == Side.white
              ? const Text(
                  'White to move',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                )
              : const Text(
                  'Black to move',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
          Chessboard(
            game: GameData(
              playerSide: position.turn == Side.white
                  ? PlayerSide.white
                  : PlayerSide.black,
              sideToMove: position.turn == Side.white ? Side.white : Side.black,
              validMoves: validMoves,
              promotionMove: promotionMove,
              onMove: _playMove,
              isCheck: position.isCheck,
              onPromotionSelection: _onPromotionSelection,
            ),
            size: screenWidth,
            orientation: orientation,
            fen: fen,
          ),
          if (position.isCheck)
            if (position.isCheckmate)
              Column(
                children: [
                  const Text('Checkmate!'),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        position = Chess.initial;
                        fen = position.fen;
                        validMoves = makeLegalMoves(position);
                        lastPos = null;
                        lastMove = null;
                        promotionMove = null;
                      });
                    },
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

  void _playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    lastPos = position;
    if (position.isLegal(move)) {
      final sanMove = position.makeSanUnchecked(move).$2;
      setState(() {
        position = position.playUnchecked(move);
        lastMove = move;
        fen = position.fen;
        validMoves = makeLegalMoves(position);
      });

      if (mainLine[_index] == sanMove) {
        print('Correct !');
        _index++;
        if (_index >= mainLine.length) {
          print('Congrats ! Line completed ');
        }
      } else {
        print('Incorrect. Reverting in 2seconds...');
        print('Index is $_index');
        print('${mainLine[_index]} != $sanMove');
        // undo move after a 1 sec timeout
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            position = lastPos!;
            fen = position.fen;
            validMoves = makeLegalMoves(position);
            lastMove = null;
          });
        });
      }
    }
  }
  // void _playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
  //   lastPos = position;
  //   if (isPromotionPawnMove(move)) {
  //     setState(() {
  //       promotionMove = move;
  //     });
  //   } else if (position.isLegal(move)) {
  //     setState(() {
  //       position = position.playUnchecked(move);
  //       lastMove = move;
  //       fen = position.fen;
  //       validMoves = makeLegalMoves(position);
  //       promotionMove = null;
  //       if (isPremove == true) {
  //         premove = null;
  //       }
  //     });
  //   }
  // }

  void _onPromotionSelection(Role? role) {
    if (role == null) {
      _onPromotionCancel();
    } else if (promotionMove != null) {
      _playMove(promotionMove!.withPromotion(role));
    }
  }

  void _onPromotionCancel() {
    setState(() {
      promotionMove = null;
    });
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && position.turn == Side.black) ||
            (move.to.rank == Rank.eighth && position.turn == Side.white));
  }
}
