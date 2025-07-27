import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LearnState {
  final PgnGame pgnGame;
  final PgnNode? currentNode;
  final PgnNodeData? currentNodeData;
  // final String? currentNodeComment;
  final int lineLength;
  final int currentStep;
  final bool isFinished;

  const LearnState({
    required this.pgnGame,
    required this.lineLength,
    this.currentNodeData,
    this.currentNode,
    this.currentStep = 0,
    this.isFinished = false,
  });

  LearnState copyWith({
    PgnGame? pgnGame,
    int? currentStep,
    PgnNode? currentNode,
    PgnNodeData? currentNodeData,
    int? lineLength,
    bool? isFinished,
  }) {
    return LearnState(
      pgnGame: pgnGame ?? this.pgnGame,
      currentNodeData: currentNodeData ?? this.currentNodeData,
      currentNode: currentNode ?? this.currentNode,
      currentStep: currentStep ?? this.currentStep,
      lineLength: lineLength ?? this.lineLength,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}
