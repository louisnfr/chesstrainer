import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/services/chess_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChessNotifier extends FamilyNotifier<ChessState, PlayerSide> {
  @override
  ChessState build(PlayerSide playerSide) {
    return ChessService.initializeGame(playerSide: playerSide);
  }

  // * Initialize methods

  // void initialize() {
  //   state = state.copyWith(
  //     validMoves: makeLegalMoves(state.position),
  //   );
  // }

  // void loadPosition(String fen) {
  //   final newState = ChessService.loadPosition(state, fen);
  //   if (newState != null) {
  //     state = newState;
  //   }
  // }

  void resetGame() {
    state = ChessService.resetGame(state);
  }

  // * GameData methods

  GameData getGameData() {
    return ChessService.createGameData(state, this);
  }

  GameData getGameDataWith({
    required void Function(NormalMove, {bool? isDrop}) onMove,
  }) {
    return ChessService.createGameDataWith(state, this, onMove: onMove);
  }

  // * Move methods

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    final newState = ChessService.playMove(state, move);
    if (newState != null) {
      state = newState;
    }
  }

  // * Promotion methods

  void onPromotionSelection(Role? role) {
    final newState = ChessService.handlePromotionSelection(state, role);
    if (newState != null) {
      state = newState;
    }
  }

  void onPromotionCancel() {
    onPromotionSelection(null);
  }

  // * Navigation methods

  void goToPrevious() {
    final newState = ChessService.goToPrevious(state);
    if (newState != null) {
      state = newState;
    }
  }

  void goToNext() {
    final newState = ChessService.goToNext(state);
    if (newState != null) {
      state = newState;
    }
  }

  void undoMove() {
    final newState = ChessService.undoMove(state);
    if (newState != null) {
      state = newState;
    }
  }

  // * Side methods

  void toggleOrientation() {
    state = ChessService.toggleOrientation(state);
  }
}

// * Providers

final chessNotifierProvider = NotifierProvider.autoDispose
    .family<ChessNotifier, ChessState, PlayerSide>(ChessNotifier.new);

// Providers utilitaires (optionnels)
// final positionProvider = Provider.family<Position, PlayerSide>((
//   ref,
//   playerSide,
// ) {
//   return ref.watch(chessProvider(playerSide)).position;
// });

// final fenProvider = Provider.family<String, PlayerSide>((ref, playerSide) {
//   return ref.watch(chessProvider(playerSide)).fen;
// });

// final validMovesProvider = Provider.family<ValidMoves, PlayerSide>((
//   ref,
//   playerSide,
// ) {
//   return ref.watch(chessProvider(playerSide)).validMoves;
// });
