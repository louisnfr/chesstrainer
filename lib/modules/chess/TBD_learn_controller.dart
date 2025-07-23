import 'package:chessground/chessground.dart';
import 'package:chesstrainer/modules/chess/TBD_chess_controller.dart';
import 'package:chesstrainer/modules/chess/models/node.dart';
import 'package:chesstrainer/modules/learn/models/line.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class LearnController extends ChangeNotifier {
  final ChessController _chessController;
  final Line line;

  Node? _currentNode;
  int _currentStep = 0;
  bool _isAutoPlayEnabled = true;

  int get currentStep => _currentStep;
  Node? get currentNode => _currentNode;
  bool get isAutoPlayEnabled => _isAutoPlayEnabled;

  LearnController(this._chessController, this.line) {
    _currentNode = line.root;
    _currentStep = 0;
    _chessController.initialize();
    notifyListeners();

    // Si le joueur joue les noirs, jouer automatiquement le premier coup des blancs
    if (_isAutoPlayEnabled && line.playerSide == PlayerSide.black) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _playOpponentMove();
      });
    }
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
    _currentNode = nextNode;
    _currentStep++;
    notifyListeners();

    // Jouer automatiquement le coup de l'adversaire si c'est le tour du joueur et que l'auto-play est activé
    if (_isAutoPlayEnabled &&
        ((line.playerSide == PlayerSide.white &&
                _chessController.position.turn == Side.black) ||
            (line.playerSide == PlayerSide.black &&
                _chessController.position.turn == Side.white))) {
      // Ajouter un petit délai pour que l'utilisateur puisse voir son coup
      Future.delayed(const Duration(seconds: 1), () {
        _playOpponentMove();
      });
    }

    return true;
  }

  void _playOpponentMove() {
    // Chercher le coup de l'adversaire dans la ligne principale
    final opponentNode = _currentNode?.children.firstWhereOrNull(
      (child) => child.isMainLine == true,
    );

    if (opponentNode != null && opponentNode.move != null) {
      // Convertir le move SAN en Move
      final move = _chessController.position.parseSan(opponentNode.move!);
      if (move != null && move is NormalMove) {
        // Jouer le coup de l'adversaire
        _chessController.playMove(move);
        _currentNode = opponentNode;
        _currentStep++;
        notifyListeners();
      }
    }
  }

  void setAutoPlay(bool enabled) {
    _isAutoPlayEnabled = enabled;
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _currentNode = line.root;
    _chessController.resetGame();
    notifyListeners();
  }

  void goToPrevious() {
    if (_currentNode?.parent != null) {
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
