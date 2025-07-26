import 'package:chesstrainer/modules/learn/models/learn_state.dart';
import 'package:dartchess/dartchess.dart';

class LearnService {
  // * Initialization methods

  static LearnState initialize(PgnGame pgnGame) {
    return LearnState(
      pgnGame: pgnGame,
      currentNode: pgnGame.moves,
      currentStep: 0,
    );
  }

  static LearnState reset(LearnState state) {
    return state.copyWith(pgnGame: state.pgnGame, currentStep: 0);
  }

  // * Validation methods

  static ({LearnState newState, bool isCorrect}) validateMove(
    LearnState state,
    String sanMove,
  ) {
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
    return (
      newState: state.copyWith(
        currentNode: state.currentNode,
        currentStep: state.currentStep + 1,
      ),
      isCorrect: true,
    );
  }

  // static Node? getComputerMove(LearnState state) {
  //   return state.currentNode?.children.firstWhereOrNull(
  //     (child) => child.isMainLine == true,
  //   );
  // }

  // * Navigation methods

  // static LearnState? goToPrevious(LearnState state) {
  //   if (state.currentNode?.parent != null) {
  //     return state.copyWith(
  //       currentNode: state.currentNode!.parent,
  //       currentStep: state.currentStep - 1,
  //     );
  //   }
  //   return null;
  // }

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
