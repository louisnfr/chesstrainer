import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:flutter/services.dart';

class Node {
  final String? move;
  final String fen;
  final String? comment;
  final List<Node> children;
  final bool isMainLine;
  Node? parent;

  Node({
    required this.move,
    required this.fen,
    required this.comment,
    required this.children,
    required this.isMainLine,
    this.parent,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      move: json['move'],
      fen: json['fen'],
      comment: json['comment'],
      isMainLine: json['isMainLine'] ?? false,
      children: (json['children'] as List<dynamic>)
          .map((child) => Node.fromJson(child))
          .toList(),
    );
  }
}

class Line {
  final String name;
  final String eco;
  final String parentOpening;
  final PlayerSide playerSide;
  final Node root;

  Line({
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
  assignParent(line.root);
  return line;
}

void assignParent(Node node, [Node? parent]) {
  node.parent = parent;
  for (final child in node.children) {
    assignParent(child, node);
  }
}
