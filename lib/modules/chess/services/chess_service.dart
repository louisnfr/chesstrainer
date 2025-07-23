import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class ChessService {
  // * Initialize methods

  static ChessState initializeGame({PlayerSide playerSide = PlayerSide.both}) {
    final position = Chess.initial;

    return ChessState(
      fen: kInitialBoardFEN,
      playerSide: playerSide,
      position: position,
      orientation: Side.white,
      moveHistory: const [],
      fenHistory: const [kInitialBoardFEN],
      historyIndex: 0,
      validMoves: calculateValidMoves(position),
    );
  }

  static GameData createGameData(ChessState state, ChessNotifier notifier) {
    return GameData(
      playerSide: state.playerSide,
      sideToMove: state.position.turn,
      validMoves: state.validMoves,
      promotionMove: state.promotionMove,
      onMove: notifier.playMove,
      isCheck: state.position.isCheck,
      onPromotionSelection: notifier.onPromotionSelection,
    );
  }

  static GameData createGameDataWith(
    ChessState state,
    ChessNotifier notifier, {
    required void Function(NormalMove, {bool? isDrop}) onMove,
  }) {
    return GameData(
      playerSide: state.playerSide,
      sideToMove: state.position.turn,
      validMoves: state.validMoves,
      promotionMove: state.promotionMove,
      onMove: onMove,
      onPromotionSelection: notifier.onPromotionSelection,
    );
  }

  static ValidMoves calculateValidMoves(Position position) {
    return makeLegalMoves(position);
  }

  static ChessState resetGame(ChessState currentState) {
    final newPosition = Chess.initial;
    return ChessState(
      position: newPosition,
      orientation: currentState.orientation,
      fen: newPosition.fen,
      moveHistory: const [],
      fenHistory: const [kInitialBoardFEN],
      historyIndex: 0,
      validMoves: calculateValidMoves(newPosition),
      lastPos: null,
      lastMove: null,
      promotionMove: null,
      playerSide: currentState.playerSide,
    );
  }

  static ChessState? loadPosition(ChessState currentState, String fen) {
    try {
      final newPosition = Chess.fromSetup(Setup.parseFen(fen));
      return currentState.copyWith(
        position: newPosition,
        fen: fen,
        validMoves: calculateValidMoves(newPosition),
        lastPos: null,
        lastMove: null,
        promotionMove: null,
      );
    } catch (e) {
      debugPrint('Error loading position: $e');
      return null;
    }
  }

  static ChessState? playMove(ChessState currentState, NormalMove move) {
    if (!currentState.position.isLegal(move)) {
      return null;
    }

    final sanMove = currentState.position.makeSanUnchecked(move).$2;
    final newPosition = currentState.position.playUnchecked(move);

    // Gérer l'historique immutable
    List<String> newFenHistory = List.from(currentState.fenHistory);
    List<String> newMoveHistory = List.from(currentState.moveHistory);
    int newHistoryIndex = currentState.historyIndex;

    if (newHistoryIndex < newFenHistory.length - 1) {
      newFenHistory.removeRange(newHistoryIndex + 1, newFenHistory.length);
      newMoveHistory.removeRange(newHistoryIndex, newMoveHistory.length);
    }

    newFenHistory.add(newPosition.fen);
    newMoveHistory.add(sanMove);
    newHistoryIndex++;

    return currentState.copyWith(
      position: newPosition,
      fen: newPosition.fen,
      lastPos: currentState.position,
      lastMove: move,
      moveHistory: newMoveHistory,
      fenHistory: newFenHistory,
      historyIndex: newHistoryIndex,
      validMoves: calculateValidMoves(newPosition),
    );
  }

  static ChessState? undoMove(ChessState currentState) {
    if (currentState.lastPos == null) {
      return null;
    }

    return currentState.copyWith(
      position: currentState.lastPos!,
      fen: currentState.lastPos!.fen,
      validMoves: calculateValidMoves(currentState.lastPos!),
      lastMove: null,
    );
  }

  // * Side methods

  static ChessState toggleOrientation(ChessState currentState) {
    return currentState.copyWith(
      orientation: currentState.orientation.opposite,
    );
  }

  static ChessState setPromotionMove(
    ChessState currentState,
    NormalMove? promotionMove,
  ) {
    return currentState.copyWith(promotionMove: promotionMove);
  }

  static bool isPromotionPawnMove(ChessState currentState, NormalMove move) {
    return move.promotion == null &&
        currentState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                currentState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                currentState.position.turn == Side.white));
  }

  static ChessState? goToPrevious(ChessState currentState) {
    if (currentState.historyIndex <= 0) {
      return null;
    }

    final newIndex = currentState.historyIndex - 1;
    return _loadFenFromHistory(currentState, newIndex);
  }

  static ChessState? goToNext(ChessState currentState) {
    if (currentState.historyIndex >= currentState.fenHistory.length - 1) {
      return null;
    }

    final newIndex = currentState.historyIndex + 1;
    return _loadFenFromHistory(currentState, newIndex);
  }

  static ChessState _loadFenFromHistory(ChessState currentState, int index) {
    final fenToLoad = currentState.fenHistory[index];
    final newPosition = Chess.fromSetup(Setup.parseFen(fenToLoad));

    return currentState.copyWith(
      position: newPosition,
      fen: newPosition.fen,
      historyIndex: index,
      validMoves: calculateValidMoves(newPosition),
    );
  }
}
