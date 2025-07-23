import 'package:flutter/widgets.dart' show immutable;

@immutable
class Node {
  final String? move;
  final String fen;
  final String? comment;
  final List<Node> children;
  final bool isMainLine;
  final Node? parent;

  const Node({
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

// void assignParent(Node node, [Node? parent]) {
//   node.parent = parent;
//   for (final child in node.children) {
//     assignParent(child, node);
//   }
// }
