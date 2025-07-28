import 'package:chesstrainer/modules/opening/models/opening_difficulty.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class OpeningModel {
  final String id;
  final String name;
  final String description;
  final OpeningDifficulty difficulty;
  final List<String> tags;
  // final OpeningStyle style;
  final Side side;
  final String ecoCode;
  final int lineCount;
  final String fen;

  const OpeningModel({
    required this.difficulty,
    required this.fen,
    // required this.style,
    required this.lineCount,
    required this.ecoCode,
    required this.id,
    required this.name,
    required this.description,
    this.side = Side.white,
    this.tags = const [],
  });
}
