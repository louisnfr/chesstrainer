import 'package:flutter/services.dart' show rootBundle;

class PgnLoader {
  static Future<String> loadPgn(String assetPath) async {
    return await rootBundle.loadString(assetPath);
  }
}
