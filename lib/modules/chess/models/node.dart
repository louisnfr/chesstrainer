import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class Opening {
  final String eco;
  final String name;

  Opening({required this.eco, required this.name});
}

abstract class Node {
  Move? move;
  Position get position;
  Opening? opening;
  String? comments;
  IList<Node> get children;

  // Node({
  //   this.move,
  //   required this.position,
  //   this.opening,
  //   this.comments,
  //   IList<Node>? children,
  // }) : children = children ?? const IListConst([]);

  // factory Root.fromPgnMoves(String pgn) {
  //   Position position = Chess.initial;
  //   final root = Root(position: position);
  //   Node current = root;
  //   final moves = pgn.split(' ');
  //   for (final san in moves) {
  //     final move = position.parseSan(san);
  //     position = position.playUnchecked(move!);
  //     final nextNode = Branch(sanMove: SanMove(san, move), position: position);
  //     current.addChild(nextNode);
  //     current = nextNode;
  //   }
  //   return root;
  // }

  // factory Node.fromJson(Map<String, dynamic> json) {
  //   Position position = Chess.initial;

  //   final root = Node()

  //   return Node(
  //     move: json['move'] != null ? NormalMove.fromSan(json['move']) : null,
  //     position: Position.fromFEN(json['fen']),
  //     opening: json['opening'] != null
  //         ? Opening(eco: json['opening']['eco'], name: json['opening']['name'])
  //         : null,
  //     comments: json['comment'],
  //     children: (json['children'] as List<dynamic>? ?? [])
  //         .map((child) => Node.fromJson(child))
  //         .toIList(),
  //   );
  // }
}
