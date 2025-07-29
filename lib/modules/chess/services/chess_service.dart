import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:dartchess/dartchess.dart';
import 'package:gaimon/gaimon.dart';

class ChessService {
  // * Initialize methods

  static ChessState initializeGame({PlayerSide playerSide = PlayerSide.both}) {
    final position = Chess.initial;
    return ChessState(
      fen: position.fen,
      playerSide: playerSide,
      position: position,
      orientation: Side.white,
      // moveHistory: const [],
      fenHistory: const [kInitialBoardFEN],
      historyIndex: 0,
      validMoves: makeLegalMoves(position),
      lastMove: null,
    );
  }

  static ChessState resetGame(ChessState currentState) {
    final newPosition = Chess.initial;
    return ChessState(
      position: newPosition,
      orientation: currentState.orientation,
      fen: newPosition.fen,
      // moveHistory: const [],
      fenHistory: const [kInitialBoardFEN],
      historyIndex: 0,
      validMoves: makeLegalMoves(newPosition),
      lastPos: null,
      lastMove: null,
      promotionMove: null,
      playerSide: currentState.playerSide,
    );
  }

  // * GameData methods

  static GameData createGameData(ChessState state, ChessNotifier notifier) {
    return GameData(
      playerSide: state.playerSide,
      sideToMove: state.position.turn,
      validMoves: state.validMoves,
      isCheck: state.position.isCheck,
      onMove: notifier.playMove,
      promotionMove: state.promotionMove,
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

  // * Move methods

  static ChessState? playMove(ChessState currentState, NormalMove move) {
    if (isPromotionPawnMove(currentState, move)) {
      return currentState.copyWith(promotionMove: move);
    } else if (currentState.position.isLegal(move)) {
      final newPosition = currentState.position.playUnchecked(move);
      List<String> newFenHistory = List.from(currentState.fenHistory);
      int newHistoryIndex = currentState.historyIndex;
      if (newHistoryIndex < newFenHistory.length - 1) {
        newFenHistory.removeRange(newHistoryIndex + 1, newFenHistory.length);
        // newMoveHistory.removeRange(newHistoryIndex, newMoveHistory.length);
      }
      newFenHistory.add(newPosition.fen);
      newHistoryIndex++;

      return currentState.copyWith(
        position: newPosition,
        fen: newPosition.fen,
        lastPos: newPosition,
        lastMove: move,
        validMoves: makeLegalMoves(newPosition),
        fenHistory: newFenHistory,
        historyIndex: newHistoryIndex,
        promotionMove: null,
        // moveHistory: null,
      );
    }
    return null;
  }

  // * Promotion methods

  static bool isPromotionPawnMove(ChessState currentState, NormalMove move) {
    return move.promotion == null &&
        currentState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                currentState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                currentState.position.turn == Side.white));
  }

  static ChessState? handlePromotionSelection(
    ChessState currentState,
    Role? role,
  ) {
    if (role == null) {
      return setPromotionMove(currentState, null);
    } else if (currentState.promotionMove != null) {
      final newMove = currentState.promotionMove!.withPromotion(role);
      return playMove(currentState, newMove);
    }
    return null;
  }

  static ChessState setPromotionMove(
    ChessState currentState,
    NormalMove? promotionMove,
  ) {
    return currentState.copyWith(promotionMove: promotionMove);
  }

  // * Navigation methods

  static ChessState? goToPrevious(ChessState currentState) {
    if (canGoToPrevious(currentState)) {
      Gaimon.selection();
      final newIndex = currentState.historyIndex - 1;
      return _loadFenFromHistory(currentState, newIndex);
    }
    return null;
  }

  static ChessState? goToNext(ChessState currentState) {
    if (canGoToNext(currentState)) {
      Gaimon.selection();
      final newIndex = currentState.historyIndex + 1;
      return _loadFenFromHistory(currentState, newIndex);
    }
    return null;
  }

  static ChessState _loadFenFromHistory(ChessState currentState, int newIndex) {
    final fenToLoad = currentState.fenHistory[newIndex];
    final newPosition = Chess.fromSetup(Setup.parseFen(fenToLoad));

    return currentState.copyWith(
      position: newPosition,
      fen: newPosition.fen,
      historyIndex: newIndex,
      validMoves: makeLegalMoves(newPosition),
      promotionMove: null,
    );
  }

  static ChessState? undoMove(ChessState currentState) {
    if (currentState.lastPos == null) {
      return null;
    }
    return currentState.copyWith(
      position: currentState.lastPos!,
      fen: currentState.lastPos!.fen,
      validMoves: makeLegalMoves(currentState.lastPos!),
      lastMove: null,
      promotionMove: null,
    );
  }

  // * Helper methods

  static ChessState toggleOrientation(ChessState currentState) {
    return currentState.copyWith(
      orientation: currentState.orientation.opposite,
    );
  }

  static bool canGoToNext(ChessState state) {
    return state.historyIndex < state.fenHistory.length - 1;
  }

  static bool canGoToPrevious(ChessState state) {
    return state.historyIndex > 0;
  }
}
