import 'package:chesstrainer/modules/learn/models/pgn_node_with_parent.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class LearnState {
  final PgnGame pgnGame;
  final String openingId;
  final String lineId;
  final PgnNodeWithParent<PgnNodeData>? currentNode;
  final PgnNodeData? currentNodeData;
  final int lineLength;
  final int currentStep;
  final bool isFinished;
  final List<PgnNodeWithParent<PgnNodeData>> navigationHistory;

  const LearnState({
    required this.pgnGame,
    required this.lineLength,
    required this.openingId,
    required this.lineId,
    this.currentNodeData,
    this.currentNode,
    this.currentStep = 0,
    this.isFinished = false,
    this.navigationHistory = const [],
  });

  LearnState copyWith({
    PgnGame? pgnGame,
    String? openingId,
    String? lineId,
    int? currentStep,
    PgnNodeWithParent<PgnNodeData>? currentNode,
    PgnNodeData? currentNodeData,
    int? lineLength,
    bool? isFinished,
    List<PgnNodeWithParent<PgnNodeData>>? navigationHistory,
  }) {
    return LearnState(
      pgnGame: pgnGame ?? this.pgnGame,
      openingId: openingId ?? this.openingId,
      lineId: lineId ?? this.lineId,
      currentNodeData: currentNodeData ?? this.currentNodeData,
      currentNode: currentNode ?? this.currentNode,
      currentStep: currentStep ?? this.currentStep,
      lineLength: lineLength ?? this.lineLength,
      isFinished: isFinished ?? this.isFinished,
      navigationHistory: navigationHistory ?? this.navigationHistory,
    );
  }
}
