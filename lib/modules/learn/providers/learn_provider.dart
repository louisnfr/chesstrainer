import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/chess_state.dart';
import 'package:chesstrainer/modules/chess/providers/chess_providers.dart';
import 'package:chesstrainer/modules/learn/models/learn_state.dart';
import 'package:chesstrainer/modules/learn/models/pgn_node_with_parent.dart';
import 'package:chesstrainer/modules/learn/providers/annotation_provider.dart';
import 'package:chesstrainer/modules/learn/services/learn_service.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:dartchess/dartchess.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const Duration _kComputerMoveDelay = Duration(milliseconds: 500);

// Provider principal pour l'apprentissage
class LearnNotifier extends FamilyNotifier<LearnState, PgnGame> {
  // * Other providers
  PlayerSide get _playerSide => arg.headers['PlayerSide'] == 'white'
      ? PlayerSide.white
      : PlayerSide.black;

  ChessNotifier get _chessNotifier =>
      ref.read(chessNotifierProvider(_playerSide).notifier);

  ChessState get _chessProvider => ref.read(chessNotifierProvider(_playerSide));

  AnnotationNotifier get _annotationNotifier =>
      ref.read(annotationProvider(arg).notifier);

  // * Initialization methods

  @override
  LearnState build(PgnGame pgnGame) {
    final learnState = LearnService.initialize(pgnGame);
    if (pgnGame.headers['PlayerSide'] == 'black') {
      Future.microtask(() => _playComputerMove());
    }
    return learnState;
  }

  void resetWithNewPgn(PgnGame newPgnGame) {
    final newState = LearnService.reset(state, newPgnGame);
    state = newState;
    _chessNotifier.resetGame();

    if (newPgnGame.headers['PlayerSide'] == 'black') {
      _playComputerMove();
    }
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

    final result = LearnService.validateMove(state, sanMove);
    if (result == null) return;

    if (result.isCorrect) {
      _annotationNotifier.setAnnotation(move.to, correct: true);
      Gaimon.success();
      state = result.newState;
      if (!state.isFinished) {
        _playComputerMove();
      } else if (state.isFinished == true) {
        final userNotifier = ref.read(userNotifierProvider.notifier);
        userNotifier.markOpeningAsLearned(state.lineId);
        userNotifier.setLastOpening(state.openingId);
      }
    } else {
      _annotationNotifier.setAnnotation(move.to, correct: false);
      Gaimon.error();
      state = result.newState;
    }
  }

  void _playComputerMove() {
    if (state.currentNode == null || state.currentNode!.children.isEmpty) {
      return;
    }

    final nextNode = state.currentNode?.children[0];
    if (nextNode == null) return;

    final nextMove = _chessProvider.position.parseSan(nextNode.data.san);
    Future.delayed(_kComputerMoveDelay, () {
      // Clear annotations before computer move
      _annotationNotifier.clearAnnotations();

      _chessNotifier.playMove(nextMove as NormalMove);

      // Truncate history if not at the end, then add the computer move
      List<PgnNodeWithParent<PgnNodeData>> newHistory = List.from(
        state.navigationHistory,
      );
      if (state.currentStep < newHistory.length - 1) {
        newHistory.removeRange(state.currentStep + 1, newHistory.length);
      }
      newHistory.add(nextNode);

      // Check if the computer's move finishes the line
      final isFinished = nextNode.children.isEmpty;

      state = state.copyWith(
        currentNode: nextNode,
        currentNodeData: nextNode.children.isNotEmpty
            ? nextNode.children[0].data
            : null,
        currentStep: state.currentStep + 1,
        navigationHistory: newHistory,
        isFinished: isFinished,
      );

      // If finished, mark the opening as learned and update last opening
      if (isFinished) {
        final userNotifier = ref.read(userNotifierProvider.notifier);
        userNotifier.markOpeningAsLearned(state.lineId);
        userNotifier.setLastOpening(state.openingId);
      }
    });
  }

  // * Navigation methods

  void goToPrevious() {
    final canGoToPrevious = _chessNotifier.goToPrevious();
    if (!canGoToPrevious) return;
    _annotationNotifier.clearAnnotations();
    final newState = LearnService.goToPrevious(state);
    if (newState != null) {
      state = newState;
    }
  }

  void goToNext() {
    final canGoToNext = _chessNotifier.goToNext();
    if (!canGoToNext) return;
    _annotationNotifier.clearAnnotations();

    final newState = LearnService.goToNext(state);
    if (newState != null) {
      state = newState;
    }
  }

  void goToStep(int stepIndex) {
    final newState = LearnService.goToStep(state, stepIndex);
    if (newState != null) {
      state = newState;
    }
  }

  // * Helper methods

  List<PgnNodeData> getCurrentPath() {
    return LearnService.getCurrentPath(state);
  }

  int getCurrentDepth() {
    return LearnService.getCurrentDepth(state);
  }

  List<String> getAvailableMoves() {
    return LearnService.getAvailableMoves(state);
  }
}

// * Providers

final learnNotifierProvider = NotifierProvider.autoDispose
    .family<LearnNotifier, LearnState, PgnGame>(LearnNotifier.new);
