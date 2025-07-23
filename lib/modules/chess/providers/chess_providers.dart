import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/services/chess_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChessNotifier extends FamilyNotifier<ChessState, PlayerSide> {
  // ChessNotifier({PlayerSide playerSide = PlayerSide.both})
  //   : super(ChessService.initializeGame(playerSide: playerSide));

  @override
  ChessState build(PlayerSide playerSide) {
    return ChessService.initializeGame(playerSide: playerSide);
  }

  void initialize() {
    state = state.copyWith(
      validMoves: ChessService.calculateValidMoves(state.position),
    );
  }

  void toggleOrientation() {
    state = ChessService.toggleOrientation(state);
  }

  void resetGame() {
    state = ChessService.resetGame(state);
  }

  void loadPosition(String fen) {
    final newState = ChessService.loadPosition(state, fen);
    if (newState != null) {
      state = newState;
    }
  }

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    final newState = ChessService.playMove(state, move);
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

  void onPromotionSelection(Role? role) {
    if (role == null) {
      onPromotionCancel();
    } else if (state.promotionMove != null) {
      playMove(state.promotionMove!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    state = ChessService.setPromotionMove(state, null);
  }

  bool isPromotionPawnMove(NormalMove move) {
    return ChessService.isPromotionPawnMove(state, move);
  }

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

  // Méthodes pour GameData (délégation au service)
  GameData getGameData() {
    return ChessService.createGameData(state, this);
  }

  GameData getGameDataWith({
    required void Function(NormalMove, {bool? isDrop}) onMove,
  }) {
    return ChessService.createGameDataWith(state, this, onMove: onMove);
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
