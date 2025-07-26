import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/models/learn_state.dart';
import 'package:chesstrainer/modules/learn/services/learn_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const Duration _computerMoveDelay = Duration(milliseconds: 500);

class LearnNotifier extends FamilyNotifier<LearnState, PgnGame> {
  ChessNotifier get _chessNotifier =>
      ref.read(chessNotifierProvider(PlayerSide.white).notifier);

  ChessState get _chessProvider =>
      ref.read(chessNotifierProvider(PlayerSide.white));

  // * Initialization methods

  @override
  LearnState build(PgnGame pgnGame) {
    final learnState = LearnService.initialize(pgnGame);

    // if (line.playerSide == PlayerSide.black) {
    //   Future.delayed(_computerMoveDelay, () {
    //     _playOpponentMoveIfNeeded();
    //   });
    // }

    return learnState;
  }

  GameData getGameData() {
    return _chessNotifier.getGameDataWith(
      onMove: (move, {isDrop}) => playMove(move),
    );
  }

  void reset() {
    _chessNotifier.resetGame();
    state = LearnService.reset(state);
  }

  // * Move methods

  void playMove(NormalMove move) {
    if (!_chessProvider.position.isLegal(move)) return;

    final sanMove = _chessProvider.position.makeSanUnchecked(move).$2;
    _chessNotifier.playMove(move);
    // final result = LearnService.validateMove(state, sanMove);
    // state = result.newState;
    // if (result.isCorrect) {
    //   Future.delayed(_computerMoveDelay, () {
    //     _playOpponentMoveIfNeeded();
    //   });
    // }
    if (sanMove == state.currentNode?.children[0].data.san) {
      print('Good move');
      state = state.copyWith(
        currentNode: state.currentNode?.children[0],
        currentStep: state.currentStep + 1,
      );
      // TODO dangereux le children[0]
      final nextMove = _chessProvider.position.parseSan(
        state.currentNode?.children[0].data.san ?? '',
      );
      Future.delayed(_computerMoveDelay, () {
        _chessNotifier.playMove(nextMove as NormalMove);
        state = state.copyWith(
          currentNode: state.currentNode?.children[0],
          currentStep: state.currentStep + 1,
        );
      });
    } else {
      print('Bad move');
    }
    // return result.isCorrect;
  }

  // void _playOpponentMoveIfNeeded() {
  //   final opponentNode = LearnService.getComputerMove(state);
  //   if (opponentNode?.move != null) {
  //     final move = _chessState.position.parseSan(opponentNode!.move!);
  //     if (move != null && move is NormalMove) {
  //       _chessNotifier.playMove(move);
  //       state = LearnService.playComputerMove(state, opponentNode);
  //     }
  //   }
  // }

  // * Navigation methods

  // void goToPrevious() {
  //   if (!_chessState.canGoToPrevious) return;
  //   _chessNotifier.goToPrevious();
  //   final newState = LearnService.goToPrevious(state);
  //   print('Going to previous: $newState');
  //   if (newState != null) {
  //     state = newState;
  //   }
  // }

  // void goToNext() {
  //   if (!_chessState.canGoToNext) return;
  //   _chessNotifier.goToNext();
  //   final newState = LearnService.goToNext(state);
  //   print('Going to next: $newState');
  //   if (newState != null) {
  //     state = newState;
  //   }
  // }
}

// * Providers

final learnNotifierProvider = NotifierProvider.autoDispose
    .family<LearnNotifier, LearnState, PgnGame>(LearnNotifier.new);
