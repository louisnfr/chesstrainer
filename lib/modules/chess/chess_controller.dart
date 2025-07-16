import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

class ChessController extends ChangeNotifier {
  Position _position = Chess.initial;
  Side _orientation = Side.white;
  String _fen = kInitialBoardFEN;
  ValidMoves _validMoves = IMap(const {});
  Position? _lastPos;
  NormalMove? _lastMove;
  NormalMove? _promotionMove;
  NormalMove? _premove;

  PlayerSide playerSide;

  ChessController({this.playerSide = PlayerSide.both});

  // Getters
  Position get position => _position;
  Side get orientation => _orientation;
  String get fen => _fen;
  ValidMoves get validMoves => _validMoves;
  Position? get lastPos => _lastPos;
  NormalMove? get lastMove => _lastMove;
  NormalMove? get promotionMove => _promotionMove;
  NormalMove? get premove => _premove;

  // Setters
  void setOrientation(Side newOrientation) {
    _orientation = newOrientation;
    notifyListeners();
  }

  void initialize() {
    _validMoves = makeLegalMoves(_position);
    notifyListeners();
  }

  void resetGame() {
    _position = Chess.initial;
    _fen = _position.fen;
    _validMoves = makeLegalMoves(_position);
    _lastPos = null;
    _lastMove = null;
    _promotionMove = null;
    notifyListeners();
  }

  void loadPosition(String fen) {
    try {
      _position = Chess.fromSetup(Setup.parseFen(fen));
      _fen = fen;
      _validMoves = makeLegalMoves(_position);
      _lastPos = null;
      _lastMove = null;
      _promotionMove = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading position: $e');
    }
  }

  void playMove(NormalMove move, {bool? isDrop, bool? isPremove}) {
    _lastPos = _position;
    if (_position.isLegal(move)) {
      _position = _position.playUnchecked(move);
      _lastMove = move;
      _fen = _position.fen;
      _validMoves = makeLegalMoves(_position);
      notifyListeners();
    }
  }

  void undoMove() {
    if (_lastPos != null) {
      _position = _lastPos!;
      _fen = _position.fen;
      _validMoves = makeLegalMoves(_position);
      _lastMove = null;
      notifyListeners();
    }
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      onPromotionCancel();
    } else if (_promotionMove != null) {
      playMove(_promotionMove!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    _promotionMove = null;
    notifyListeners();
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        _position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first && _position.turn == Side.black) ||
            (move.to.rank == Rank.eighth && _position.turn == Side.white));
  }

  GameData getGameData() {
    return GameData(
      playerSide: playerSide,
      sideToMove: _position.turn,
      validMoves: _validMoves,
      promotionMove: _promotionMove,
      onMove: playMove,
      isCheck: _position.isCheck,
      onPromotionSelection: onPromotionSelection,
    );
  }

  GameData getGameDataWith({
    required void Function(NormalMove, {bool? isDrop}) onMove,
  }) {
    return GameData(
      playerSide: playerSide,
      sideToMove: _position.turn,
      validMoves: validMoves,
      promotionMove: promotionMove,
      onMove: onMove,
      onPromotionSelection: onPromotionSelection,
    );
  }
}
