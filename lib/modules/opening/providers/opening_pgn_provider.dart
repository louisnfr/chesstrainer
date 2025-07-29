import 'package:chesstrainer/modules/opening/services/pgn_loader.dart';
import 'package:dartchess/dartchess.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PgnGameNotifier extends FamilyAsyncNotifier<PgnGame, String> {
  @override
  Future<PgnGame> build(String assetPath) async {
    final pgnString = await PgnLoader.loadPgn(assetPath);
    return PgnGame.parsePgn(pgnString);
  }

  Future<PgnGame> loadGame(String assetPath) async {
    final pgnString = await PgnLoader.loadPgn(assetPath);
    return PgnGame.parsePgn(pgnString);
  }
}

// * Providers

final pgnGameNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<PgnGameNotifier, PgnGame, String>(PgnGameNotifier.new);
