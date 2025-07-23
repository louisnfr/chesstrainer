import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/models/node.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/services.dart';

@immutable
class Line {
  final String name;
  final String eco;
  final String parentOpening;
  final PlayerSide playerSide;
  final Node root;

  const Line({
    required this.name,
    required this.eco,
    required this.parentOpening,
    required this.playerSide,
    required this.root,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      name: json['name'],
      eco: json['eco'],
      parentOpening: json['parentOpening'],
      playerSide: json['playerSide'] == 'white'
          ? PlayerSide.white
          : PlayerSide.black,
      root: Node.fromJson(json['root']),
    );
  }
}

Future<Line> loadLine(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final data = jsonDecode(jsonString);
  final Line line = Line.fromJson(data);
  // assignParent(line.root);
  return line;
}
