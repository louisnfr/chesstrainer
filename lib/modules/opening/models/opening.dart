import 'package:dartchess/dartchess.dart';
import 'package:flutter/foundation.dart' show immutable;

typedef LinePath = String;

@immutable
class OpeningModel {
  final String id;
  final String name;
  final String description;
  final List<LinePath> linePaths;
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
}
