import 'package:chesstrainer/modules/learn/models/learn_state.dart';
import 'package:dartchess/dartchess.dart';

class LearnService {
  // * Initialization methods

  static LearnState initialize(PgnGame pgnGame) {
    final currentNodeData = pgnGame.moves.children.isNotEmpty
        ? pgnGame.moves.children[0].data
        : null;

    final lineLength = pgnGame.moves.mainline().length;

    return LearnState(
      pgnGame: pgnGame,
      currentNode: pgnGame.moves,
      currentNodeData: currentNodeData,
      lineLength: lineLength,
      currentStep: 0,
    );
  }

  // static LearnState reset(LearnState state) {
  //   return state.copyWith(pgnGame: state.pgnGame, currentStep: 0);
  // }

  // * Validation methods

  static ({LearnState newState, bool isCorrect})? validateMove(
    LearnState state,
    String sanMove,
  ) {
    if (sanMove == state.currentNodeData?.san) {
      print('Good move, we go next node');
      final newNode = state.currentNode?.children[0];
      if (newNode != null && newNode.children.isEmpty) {
        print('No next node available');
        final newState = state.copyWith(
          currentNode: newNode,
          currentNodeData: newNode.data, // <- Ajouter cette ligne !
          currentStep: state.currentStep + 1,
          isFinished: true,
        );
        return (newState: newState, isCorrect: true);
      }
      state = state.copyWith(
        currentNode: newNode,
        currentNodeData: newNode?.children[0].data,
        currentStep: state.currentStep + 1,
      );
      return (newState: state, isCorrect: true);
      // * play computer move
      // final nextNode = state.currentNode?.children[0];
      // if (nextNode != null && nextNode.children.isEmpty) {
      //   print('No next node available');
      //   return (state: state, isCorrect: true);
      // }
      // final nextMove = _chessProvider.position.parseSan(
      //   nextNode?.data.san ?? '',
      // );
      // Future.delayed(_computerMoveDelay, () {
      //   _chessNotifier.playMove(nextMove as NormalMove);
      //   state = state.copyWith(
      //     currentNode: nextNode,
      //     currentNodeData: nextNode?.children[0].data,
      //     currentStep: state.currentStep + 1,
      //   );
      // });
    } else {
      print('Bad move');
      return (
        newState: state.copyWith(
          currentNode: state.currentNode,
          currentStep: state.currentStep + 1,
        ),
        isCorrect: false,
      );
    }
    // final nextNode = state.currentNode?.children.firstWhereOrNull(
    //   (child) => child.move == sanMove && child.isMainLine == true,
    // );

    // if (nextNode == null) {
    //   final incorrectNode = Node(
    //     move: sanMove,
    //     fen: currentFen,
    //     comment: '$sanMove is an incorrect move',
    //     parent: state.currentNode,
    //     children: [],
    //     isMainLine: false,
    //   );
    //   state.currentNode?.children.add(incorrectNode);
    //   final newState = state.copyWith(
    //     currentNode: incorrectNode,
    //     currentStep: state.currentStep + 1,
    //   );
    //   return (newState: newState, isCorrect: false);
    // }

    // final newState = state.copyWith(
    //   currentNode: nextNode,
    //   currentStep: state.currentStep + 1,
    // );

    // return (newState: NewState., isCorrect: true);
  }

  // static Node? getComputerMove(LearnState state) {
  //   return state.currentNode?.children.firstWhereOrNull(
  //     (child) => child.isMainLine == true,
  //   );
  // }

  // * Navigation methods

  static LearnState? goToPrevious(LearnState state) {
    if (state.currentStep > 0) {
      // On ne peut pas naviguer dans l'arbre PGN car il n'y a pas de référence parent
      // On se contente de décrémenter currentStep et laisser le ChessService gérer la position
      return state.copyWith(currentStep: state.currentStep - 1);
    }
    return null;
  }

  // static LearnState? goToNext(LearnState state) {
  //   print('Going to next: ${state.currentNode}');
  //   if (state.currentNode?.children.isNotEmpty == true) {
  //     final nextNode = state.currentNode!.children.first;
  //     return state.copyWith(
  //       currentNode: nextNode,
  //       currentStep: state.currentStep + 1,
  //     );
  //   }
  //   return null;
  // }

  // * Computer methods

  // static LearnState playComputerMove(LearnState state, Node opponentNode) {
  //   return state.copyWith(
  //     currentNode: opponentNode,
  //     currentStep: state.currentStep + 1,
  //   );
  // }

  // // * Helper methods

  // static bool isPlayerTurn(LearnState state, Side currentTurn) {
  //   final whiteSideWhiteTurn =
  //       state.line.playerSide == PlayerSide.white && currentTurn == Side.white;

  //   final blackSideBlackTurn =
  //       state.line.playerSide == PlayerSide.black && currentTurn == Side.black;

  //   return whiteSideWhiteTurn || blackSideBlackTurn;
  // }
}
