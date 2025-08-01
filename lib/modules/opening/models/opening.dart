import 'package:chesstrainer/modules/opening/models/opening_progress.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class OpeningModel {
  final String id;
  final String name;
  final String description;
  final List<Line> linePaths;
  final List<String> tags;
  final Side side;
  final String ecoCode;
  final String fen;

  const OpeningModel({
    required this.fen,
    required this.linePaths,
    required this.ecoCode,
    required this.id,
    required this.name,
    required this.description,
    this.side = Side.white,
    this.tags = const [],
  });

  OpeningProgress progressFor(List<String> learnedOpenings) {
    final lineIds = linePaths.map((line) => line.id).toList();
    final learned = learnedOpenings.where((id) => lineIds.contains(id)).length;
    return OpeningProgress.fromCounts(learned, linePaths.length);
  }

  int getFirstUnlearnedLineIndex(List<String> learnedOpenings) {
    for (int i = 0; i < linePaths.length; i++) {
      if (!learnedOpenings.contains(linePaths[i].id)) {
        return i + 1;
      }
    }
    return 1;
  }
}

@immutable
class Line {
  final String id;
  final String name;
  final String description;
  final String path;

  const Line({
    required this.id,
    required this.name,
    required this.description,
    required this.path,
  });
}
