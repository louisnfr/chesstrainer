import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/models/learn_state.dart';
import 'package:chesstrainer/modules/learn/providers/annotation_providers.dart';
import 'package:chesstrainer/modules/learn/services/learn_service.dart';
import 'package:dartchess/dartchess.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const Duration _computerMoveDelay = Duration(milliseconds: 500);

class LearnNotifier extends FamilyNotifier<LearnState, PgnGame> {
  ChessNotifier get _chessNotifier =>
      ref.read(chessNotifierProvider(PlayerSide.white).notifier);

  ChessState get _chessProvider =>
      ref.read(chessNotifierProvider(PlayerSide.white));

  AnnotationNotifier get _annotationNotifier =>
      ref.read(annotationProvider(arg).notifier);

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

  // void reset() {
  //   _chessNotifier.resetGame();
  //   state = LearnService.reset(state);
  // }

  // * Move methods

  void playMove(NormalMove move) {
    if (!_chessProvider.position.isLegal(move)) return;

    // Play the move on the chessboard
    final sanMove = _chessProvider.position.makeSanUnchecked(move).$2;
    _chessNotifier.playMove(move);

    // Validate the move against the current node data
    final result = LearnService.validateMove(state, sanMove);
    if (result == null) {
      return;
    }

    if (result.isCorrect) {
      // Show green checkmark on the destination square
      _annotationNotifier.setAnnotation(move.to, correct: true);

      Gaimon.success();
      state = result.newState;
      if (!state.isFinished) {
        _playComputerMove();
      }
    } else {
      // Show red X on the destination square
      _annotationNotifier.setAnnotation(move.to, correct: false);

      Gaimon.error();
      print('Invalid move: $sanMove');
    }
    // final result = LearnService.validateMove(state, sanMove);
    // state = result.newState;
    // if (result.isCorrect) {
    //   Future.delayed(_computerMoveDelay, () {
    //     _playOpponentMoveIfNeeded();
    //   });
    // }
    // if (sanMove == state.currentNodeData?.san) {
    //   print('Good move');
    //   final newNode = state.currentNode?.children[0];
    //   if (newNode != null && newNode.children.isEmpty) {
    //     print('No next node available');
    //     return;
    //   }
    //   state = state.copyWith(
    //     currentNode: newNode,
    //     currentNodeData: newNode?.children[0].data,
    //     currentStep: state.currentStep + 1,
    //   );
    //   // * play computer move
    //   final nextNode = state.currentNode?.children[0];
    //   if (nextNode != null && nextNode.children.isEmpty) {
    //     print('No next node available');
    //     return;
    //   }
    //   final nextMove = _chessProvider.position.parseSan(
    //     nextNode?.data.san ?? '',
    //   );
    //   Future.delayed(_computerMoveDelay, () {
    //     _chessNotifier.playMove(nextMove as NormalMove);
    //     state = state.copyWith(
    //       currentNode: nextNode,
    //       currentNodeData: nextNode?.children[0].data,
    //       currentStep: state.currentStep + 1,
    //     );
    //   });
    // } else {
    //   print('Bad move');
    // }
    // return result.isCorrect;
  }

  void _playComputerMove() {
    if (state.currentNode != null &&
        state.currentNode?.children.isEmpty == true) {
      print('No next node available');
      return;
    }
    final nextNode = state.currentNode?.children[0];
    final nextMove = _chessProvider.position.parseSan(nextNode?.data.san ?? '');
    Future.delayed(_computerMoveDelay, () {
      // Clear annotations before computer move
      _annotationNotifier.clearAnnotations();

      _chessNotifier.playMove(nextMove as NormalMove);
      state = state.copyWith(
        currentNode: nextNode,
        currentNodeData: nextNode?.children[0].data,
        currentStep: state.currentStep + 1,
      );
    });
  }

  // * Navigation methods

  void goToPrevious() {
    _chessNotifier.goToPrevious();
    final newState = LearnService.goToPrevious(state);
    print('Going to previous: $newState');
    if (newState != null) {
      state = newState;
    }
  }

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
