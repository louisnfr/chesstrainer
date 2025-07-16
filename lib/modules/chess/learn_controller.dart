import 'package:chesstrainer/modules/chess/chess_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class LearnController extends ChangeNotifier {
  final ChessController _chessController;
  final List<String> _mainLine = ['e4', 'e5', 'Nc3', 'Nf6'];
  int _currentStep = 0;

  int get currentStep => _currentStep;
  int get totalSteps => _mainLine.length;

  LearnController(this._chessController);

  bool playMove(NormalMove move, {bool? isDrop}) {
    if (_currentStep >= _mainLine.length) return false;

    final sanMove = _chessController.position.makeSanUnchecked(move).$2;
    _chessController.playMove(move);

    if (sanMove == _mainLine[_currentStep]) {
      _currentStep++;
      notifyListeners();
      return true; // move was correct
    } else {
      notifyListeners();
      return false; // move was wrong
    }
  }

  void reset() {
    _currentStep = 0;
    _chessController.resetGame();
    notifyListeners();
  }
}

// typedef MoveCallback = void Function(String move, bool isCorrect);
// typedef LineCompletedCallback = void Function();

// class LearnController extends ChangeNotifier {
//   final ChessController _chessController;
//   int _index = 0;
//   final List<String> _mainLine = [];

//   // Callbacks
//   MoveCallback? _onMove;
//   LineCompletedCallback? _onLineCompleted;

//   // Training mode settings
//   final bool _autoRevert = true;
//   final int _revertDelaySeconds = 2;

//   LearnController(this._chessController);

//   // Getters
//   int get index => _index;
//   List<String> get mainLine => _mainLine;
//   bool get autoRevert => _autoRevert;
//   int get revertDelaySeconds => _revertDelaySeconds;
//   bool get isLineCompleted => _index >= _mainLine.length;
//   String? get nextExpectedMove =>
//       _index < _mainLine.length ? _mainLine[_index] : null;

//   void setMoveCallback(MoveCallback? callback) {
//     _onMove = callback;
//   }

//   void setLineCompletedCallback(LineCompletedCallback? callback) {
//     _onLineCompleted = callback;
//   }

//   void reset() {
//     _index = 0;
//     notifyListeners();
//   }

//   /// Vérifie si le coup joué est correct selon la ligne principale
//   bool checkMove(String sanMove) {
//     if (_index >= _mainLine.length) return false;
//     return _mainLine[_index] == sanMove;
//   }

//   /// Traite un coup dans le contexte de l'apprentissage
//   void processMove(String sanMove) {
//     if (_mainLine.isEmpty) return;

//     if (checkMove(sanMove)) {
//       _onMove?.call(sanMove, true);
//       _index++;
//       notifyListeners();

//       if (_index >= _mainLine.length) {
//         _onLineCompleted?.call();
//       }
//     } else {
//       _onMove?.call(sanMove, false);
//       if (_autoRevert) {
//         Future.delayed(Duration(seconds: _revertDelaySeconds), () {
//           _chessController.undoMove();
//         });
//       }
//     }
//   }

//   /// Recule d'un coup dans la ligne
//   void stepBack() {
//     if (_index > 0) {
//       _index--;
//       notifyListeners();
//     }
//   }

//   /// Avance d'un coup dans la ligne
//   void stepForward() {
//     if (_index < _mainLine.length) {
//       _index++;
//       notifyListeners();
//     }
//   }

//   /// Retourne le progrès en pourcentage
//   double getProgress() {
//     if (_mainLine.isEmpty) return 0.0;
//     return _index / _mainLine.length;
//   }
// }
