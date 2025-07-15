class LearnController {
  final List<String> mainLine; // ["e4", "e5", "Nf3", "Nc6", ...]
  int _index = 0;

  LearnController(this.mainLine);

  String get expectedMove => mainLine[_index];
  bool get isComplete => _index >= mainLine.length;

  /// Joue le move, retourne si c’était correct ou pas
  bool play(String move) {
    if (isComplete) return false;
    if (move == expectedMove) {
      _index++;
      return true; // good move
    } else {
      return false; // bad move
    }
  }

  void reset() => _index = 0;
}
