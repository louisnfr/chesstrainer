import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart' show immutable;

@immutable
class ChessState {
  final Position position;
  final Side orientation;
  final String fen;
  // final List<String> moveHistory;
  final List<String> fenHistory;
  final int historyIndex;
  final ValidMoves validMoves;
  final Position? lastPos;
  final NormalMove? lastMove;
  final NormalMove? promotionMove;
  final NormalMove? premove;
  final PlayerSide playerSide;

  const ChessState({
    required this.position,
    required this.orientation,
    required this.fen,
    // required this.moveHistory,
    required this.fenHistory,
    required this.historyIndex,
    required this.validMoves,
    required this.playerSide,
    this.lastPos,
    this.lastMove,
    this.promotionMove,
    this.premove,
  });

  ChessState copyWith({
    Position? position,
    Side? orientation,
    String? fen,
    PlayerSide? playerSide,
    List<String>? moveHistory,
    List<String>? fenHistory,
    int? historyIndex,
    ValidMoves? validMoves,
    Position? lastPos,
    NormalMove? lastMove,
    NormalMove? promotionMove,
    NormalMove? premove,
  }) {
    return ChessState(
      position: position ?? this.position,
      orientation: orientation ?? this.orientation,
      fen: fen ?? this.fen,
      // moveHistory: moveHistory ?? this.moveHistory,
      playerSide: playerSide ?? this.playerSide,
      fenHistory: fenHistory ?? this.fenHistory,
      historyIndex: historyIndex ?? this.historyIndex,
      validMoves: validMoves ?? this.validMoves,
      lastPos: lastPos,
      lastMove: lastMove,
      promotionMove: promotionMove,
      premove: premove,
    );
  }
}
