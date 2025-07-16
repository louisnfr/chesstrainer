import 'package:chesstrainer/modules/chess/chess_controller.dart';
import 'package:chesstrainer/modules/chess/models/node.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class LearnController extends ChangeNotifier {
  final Line line;
  final ChessController _chessController;

  Node? _currentNode;
  int _currentStep = 0;

  int get currentStep => _currentStep;
  Node? get currentNode => _currentNode;

  LearnController(this._chessController, this.line) {
    _currentNode = line.root;
    print('Starting with root node: ${_currentNode?.move}');
    _currentStep = 0;
    _chessController.initialize();
    notifyListeners();
  }

  bool playMove(NormalMove move, {bool? isDrop}) {
    final sanMove = _chessController.position.makeSanUnchecked(move).$2;

    final nextNode = _currentNode?.children.firstWhereOrNull(
      (child) => child.move == sanMove && child.isMainLine == true,
    );

    _chessController.playMove(move);

    if (nextNode == null) {
      final newNode = Node(
        move: sanMove,
        fen: _chessController.fen,
        comment: 'incorrect move',
        children: [],
        parent: _currentNode,
        isMainLine: false,
      );
      currentNode?.children.add(newNode);
      _currentNode = newNode;
      _currentStep++;
      notifyListeners();
      return false;
    }
    print(
      'updating current node to: ${nextNode.move}, '
      'next we need to : ${nextNode.comment}',
    );
    _currentNode = nextNode;
    _currentStep++;
    notifyListeners();
    return true;
  }

  void reset() {
    _currentStep = 0;
    _currentNode = line.root;
    _chessController.resetGame();
    notifyListeners();
  }

  void goToPrevious() {
    if (_currentNode?.parent != null) {
      print('Going to previous node: ${_currentNode!.parent!.move}');
      _currentNode = _currentNode!.parent;
      _currentStep--;
      notifyListeners();
    }
  }

  void goToNext() {
    if (_currentNode?.children.isNotEmpty == true) {
      _currentNode = _currentNode!.children.first;
      _currentStep++;
      notifyListeners();
    }
  }
}
