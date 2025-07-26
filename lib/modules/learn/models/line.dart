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

  @override
  String toString() {
    final buffer = StringBuffer();

    String formatNode(Node node) {
      final details = <String>[];
      details.add('move: ${node.move ?? "root"}');
      details.add('parent: ${node.parent?.move ?? "null"}');
      details.add('children: ${node.children.length}');
      return '[${details.join(', ')}]';
    }

    void printTree(Node node) {
      buffer.write(formatNode(node));
      if (node.children.isNotEmpty) {
        buffer.write('\n');
        for (int i = 0; i < node.children.length; i++) {
          printTree(node.children[i]);
          if (i < node.children.length - 1) buffer.write(' ');
        }
      }
    }

    buffer.write(
      'Line(name: $name, eco: $eco, parentOpening: $parentOpening, playerSide: $playerSide):\n',
    );
    printTree(root);
    return buffer.toString();
  }
}

Future<Line> loadLine(String assetPath) async {
  final jsonString = await rootBundle.loadString(assetPath);
  final data = jsonDecode(jsonString);
  return Line.fromJson(data);
}
