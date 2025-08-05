import 'package:chesstrainer/modules/learn/models/learn_state.dart';
import 'package:chesstrainer/modules/learn/models/pgn_node_with_parent.dart';
import 'package:dartchess/dartchess.dart';

class LearnService {
  // * Initialization methods

  static LearnState initialize(PgnGame pgnGame) {
    // Convertir le PgnNode original en PgnNodeWithParent
    final rootNodeWithParent = PgnNodeConverter.addParentReferences(
      pgnGame.moves,
    );

    final currentNodeData = rootNodeWithParent.children.isNotEmpty
        ? rootNodeWithParent.children[0].data
        : null;

    final lineLength = pgnGame.moves.mainline().length;

    return LearnState(
      pgnGame: pgnGame,
      openingId: pgnGame.headers['OpeningId'] ?? 'unknown',
      lineId: pgnGame.headers['LineId'] ?? 'unknown',
      currentNode: rootNodeWithParent,
      currentNodeData: currentNodeData,
      lineLength: lineLength,
      currentStep: 0,
      navigationHistory: [rootNodeWithParent],
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
      final newNode = state.currentNode?.children[0];
      if (newNode != null && newNode.children.isEmpty) {
        List<PgnNodeWithParent<PgnNodeData>> newHistory = List.from(
          state.navigationHistory,
        );
        if (state.currentStep < newHistory.length - 1) {
          newHistory.removeRange(state.currentStep + 1, newHistory.length);
        }
        newHistory.add(newNode);

        final newState = state.copyWith(
          currentNode: newNode,
          currentNodeData: newNode.data,
          currentStep: state.currentStep + 1,
          isFinished: true,
          navigationHistory: newHistory,
        );
        return (newState: newState, isCorrect: true);
      }
      // Continuation de ligne
      List<PgnNodeWithParent<PgnNodeData>> newHistory = List.from(
        state.navigationHistory,
      );
      if (state.currentStep < newHistory.length - 1) {
        newHistory.removeRange(state.currentStep + 1, newHistory.length);
      }
      newHistory.add(newNode!);

      state = state.copyWith(
        currentNode: newNode,
        currentNodeData: newNode.children[0].data,
        currentStep: state.currentStep + 1,
        navigationHistory: newHistory,
      );
      return (newState: state, isCorrect: true);
    } else {
      final incorrectNode = PgnChildNodeWithParent<PgnNodeData>(
        PgnNodeData(san: sanMove, comments: ['$sanMove is an incorrect move!']),
        state.currentNode,
      );

      // Ajouter le nœud d'erreur aux enfants du nœud actuel
      state.currentNode?.children.add(incorrectNode);

      List<PgnNodeWithParent<PgnNodeData>> newHistory = List.from(
        state.navigationHistory,
      );
      if (state.currentStep < newHistory.length - 1) {
        newHistory.removeRange(state.currentStep + 1, newHistory.length);
      }
      newHistory.add(incorrectNode);

      final newState = state.copyWith(
        currentNode: incorrectNode,
        currentNodeData: incorrectNode.data,
        currentStep: state.currentStep + 1,
        navigationHistory: newHistory,
      );
      return (newState: newState, isCorrect: false);
    }
  }

  // static Node? getComputerMove(LearnState state) {
  //   return state.currentNode?.children.firstWhereOrNull(
  //     (child) => child.isMainLine == true,
  //   );
  // }

  // * Navigation methods

  static LearnState? goToPrevious(LearnState state) {
    if (state.currentStep > 0 &&
        state.currentStep < state.navigationHistory.length) {
      final previousNode = state.navigationHistory[state.currentStep - 1];
      final newNodeData = previousNode.children.isNotEmpty
          ? previousNode.children[0].data
          : null;

      return state.copyWith(
        currentNode: previousNode,
        currentNodeData: newNodeData,
        currentStep: state.currentStep - 1,
      );
    }
    return null;
  }

  static LearnState? goToNext(LearnState state) {
    if (state.currentStep + 1 < state.navigationHistory.length) {
      final nextNode = state.navigationHistory[state.currentStep + 1];
      final nextNodeData = nextNode.children.isNotEmpty
          ? nextNode.children[0].data
          : (nextNode is PgnChildNodeWithParent<PgnNodeData>
                ? nextNode.data
                : null);

      return state.copyWith(
        currentNode: nextNode,
        currentNodeData: nextNodeData,
        currentStep: state.currentStep + 1,
      );
    }
    return null;
  }

  // * Helper methods

  /// Retourne le chemin complet depuis la racine jusqu'au nœud courant
  static List<PgnNodeData> getCurrentPath(LearnState state) {
    final currentNode = state.currentNode;
    if (currentNode == null) return [];

    final path = currentNode.getPathFromRoot();
    return path
        .whereType<PgnChildNodeWithParent>()
        .cast<PgnChildNodeWithParent<PgnNodeData>>()
        .map((node) => node.data)
        .toList();
  }

  /// Retourne la profondeur actuelle dans l'arbre
  static int getCurrentDepth(LearnState state) {
    return state.currentNode?.getDepth() ?? 0;
  }

  /// Navigue directement vers un nœud spécifique dans le chemin
  static LearnState? goToStep(LearnState state, int stepIndex) {
    final root = state.currentNode?.getRoot();
    if (root == null) return null;

    var currentNode = root;
    for (int i = 0; i < stepIndex && currentNode.children.isNotEmpty; i++) {
      currentNode = currentNode.children[0];
    }

    final nodeData = currentNode is PgnChildNodeWithParent
        ? currentNode.data
        : (currentNode.children.isNotEmpty
              ? currentNode.children[0].data
              : null);

    return state.copyWith(
      currentNode: currentNode,
      currentNodeData: nodeData,
      currentStep: stepIndex,
      isFinished: currentNode.children.isEmpty,
    );
  }

  /// Retourne tous les coups possibles depuis le nœud actuel
  static List<String> getAvailableMoves(LearnState state) {
    final currentNode = state.currentNode;
    if (currentNode == null) return [];

    return currentNode.children.map((child) => child.data.san).toList();
  }
}
