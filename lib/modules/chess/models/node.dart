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

  factory Node.fromJson(Map<String, dynamic> json, [Node? parent]) {
    final node = Node(
      move: json['move'],
      fen: json['fen'],
      comment: json['comment'],
      isMainLine: json['isMainLine'] ?? false,
      parent: parent,
      children: [], // Temporairement vide
    );

    // Créer les enfants avec la référence au parent
    final children = (json['children'] as List<dynamic>)
        .map((child) => Node.fromJson(child, node))
        .toList();

    // Retourner un nouveau nœud avec les enfants
    return Node(
      move: node.move,
      fen: node.fen,
      comment: node.comment,
      isMainLine: node.isMainLine,
      parent: parent,
      children: children,
    );
  }

  @override
  String toString() {
    return 'Parent ${parent?.move ?? 'null'}, \nChildren: ${children.length}';
  }
}
