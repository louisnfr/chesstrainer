import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class ChessgroundExample extends StatefulWidget {
  const ChessgroundExample({super.key, required this.title});

  final String title;

  @override
  State<ChessgroundExample> createState() => _ChessgroundExampleState();
}

class _ChessgroundExampleState extends State<ChessgroundExample> {
  Position position = Chess.initial;
  String fen = kInitialBoardFEN;
  Side orientation = Side.white;
  Side sideToMove = Side.white;
  ValidMoves validMoves = IMap(const {});
  NormalMove? lastMove;
  NormalMove? promotionMove;

  @override
  void initState() {
    validMoves = makeLegalMoves(position);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(title: const Text('Chessground Example')),
      body: Center(
        child: Chessboard(
          size: screenWidth,
          orientation: orientation,
          fen: fen,
          lastMove: lastMove,
          game: GameData(
            playerSide: PlayerSide.both,
            validMoves: validMoves,
            sideToMove: position.turn == Side.white ? Side.white : Side.black,
            isCheck: position.isCheck,
            promotionMove: promotionMove,
            onMove: _playMove,
            onPromotionSelection: _onPromotionSelection,
          ),
        ),
      ),
    );
  }

  void _playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    if (isPromotionPawnMove(move)) {
      print('Promotion pawn move detected: $move');
      setState(() {
        promotionMove = move;
      });
    } else if (position.isLegal(move)) {
      setState(() {
        position = position.playUnchecked(move);
        lastMove = move;
        fen = position.fen;
        validMoves = makeLegalMoves(position);
        promotionMove = null;
      });
    }
  }

  void _onPromotionSelection(Role? role) {
    print('Promotion selected: $role');
    if (role == null) {
      print('Promotion cancelled');
      _onPromotionCancel();
    } else if (promotionMove != null) {
      print('Playing promotion move with role: $role');
      _playMove(promotionMove!.withPromotion(role));
    }
  }

  void _onPromotionCancel() {
    print('Promotion cancelled');
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
