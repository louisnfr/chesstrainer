import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LearnState {
  final PgnGame pgnGame;
  // mainLine
  final PgnNode? currentNode;
  final int currentStep;

  const LearnState({
    // required this.line,
    // this.currentNode,
    required this.pgnGame,
    this.currentNode,
    this.currentStep = 0,
  });

  LearnState copyWith({
    PgnGame? pgnGame,
    int? currentStep,
    PgnNode? currentNode,
  }) {
    return LearnState(
      // line: line ?? this.line,
      // currentNode: currentNode ?? this.currentNode,
      currentNode: currentNode ?? this.currentNode,
      pgnGame: pgnGame ?? this.pgnGame,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
