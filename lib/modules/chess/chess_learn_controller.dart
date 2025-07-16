// import 'package:chesstrainer/modules/chess/chess_controller.dart';
// import 'package:chesstrainer/modules/chess/learn_controller.dart';
// import 'package:chessground/chessground.dart';
// import 'package:dartchess/dartchess.dart';
// import 'package:flutter/material.dart';

// class ChessLearnController extends ChangeNotifier {
//   final ChessController _chessController;
//   late final LearnController _learnController;

//   ChessLearnController() : _chessController = ChessController() {
//     _learnController = LearnController(_chessController);
//     _chessController.addListener(_onChessControllerChanged);
//     _learnController.addListener(_onLearnControllerChanged);
//   }

//   // Getters pour accéder aux contrôleurs
//   ChessController get chessController => _chessController;
//   LearnController get learnController => _learnController;

//   // Getters combinés pour l'interface
//   Position get position => _chessController.position;
//   Side get orientation => _chessController.orientation;
//   String get fen => _chessController.fen;
//   ValidMoves get validMoves => _chessController.validMoves;
//   NormalMove? get lastMove => _chessController.lastMove;
//   NormalMove? get promotionMove => _chessController.promotionMove;
//   bool get isLineCompleted => _learnController.isLineCompleted;
//   double get progress => _learnController.getProgress();
//   String? get nextExpectedMove => _learnController.nextExpectedMove;

//   @override
//   void dispose() {
//     _chessController.removeListener(_onChessControllerChanged);
//     _learnController.removeListener(_onLearnControllerChanged);
//     _chessController.dispose();
//     _learnController.dispose();
//     super.dispose();
//   }

//   void _onChessControllerChanged() {
//     notifyListeners();
//   }

//   void _onLearnControllerChanged() {
//     notifyListeners();
//   }

//   void initialize() {
//     _chessController.initialize();
//   }

//   void setMainLine(List<String> mainLine) {
//     _learnController.setMainLine(mainLine);
//   }

//   void setMoveCallback(MoveCallback? callback) {
//     _learnController.setMoveCallback(callback);
//   }

//   void setLineCompletedCallback(LineCompletedCallback? callback) {
//     _learnController.setLineCompletedCallback(callback);
//   }

//   void resetGame() {
//     _chessController.resetGame();
//     _learnController.reset();
//   }

//   void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
//     if (_chessController.position.isLegal(move)) {
//       final sanMove = _chessController.position.makeSanUnchecked(move).$2;
//       _chessController.playMove(move, isDrop: isDrop, isPremove: isPremove);
//       _learnController.processMove(sanMove);
//     }
//   }

//   void undoMove() {
//     _chessController.undoMove();
//     _learnController.stepBack();
//   }

//   void onPromotionSelection(Role? role) {
//     _chessController.onPromotionSelection(role);
//   }

//   GameData getGameData() {
//     return GameData(
//       playerSide: position.turn == Side.white
//           ? PlayerSide.white
//           : PlayerSide.black,
//       sideToMove: position.turn == Side.white ? Side.white : Side.black,
//       validMoves: validMoves,
//       promotionMove: promotionMove,
//       onMove: playMove,
//       isCheck: position.isCheck,
//       onPromotionSelection: onPromotionSelection,
//     );
//   }
// }
