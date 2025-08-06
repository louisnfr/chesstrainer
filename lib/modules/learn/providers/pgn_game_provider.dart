// Provider pour le PgnGame basé sur l'opening et la ligne sélectionnée
import 'package:chesstrainer/modules/learn/providers/selected_line_provider.dart';
import 'package:chesstrainer/modules/learn/services/learn_service.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/opening/providers/opening_pgn_provider.dart';
import 'package:dartchess/dartchess.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PgnGameNotifier extends FamilyAsyncNotifier<PgnGame, OpeningModel> {
  @override
  Future<PgnGame> build(OpeningModel opening) async {
    final selectedLine = ref.watch(selectedLineProvider(opening));
    if (selectedLine == null) {
      throw Exception('No line selected');
    }

    final assetPath = LearnService.buildAssetPath(opening.id, selectedLine);
    final pgnNotifier = ref.read(pgnGameNotifierProvider(assetPath).notifier);
    return await pgnNotifier.loadGame(assetPath);
  }

  Future<void> loadLine(int lineIndex) async {
    final assetPath = LearnService.buildAssetPath(arg.id, lineIndex);

    try {
      final pgnNotifier = ref.read(pgnGameNotifierProvider(assetPath).notifier);
      final pgnGame = await pgnNotifier.loadGame(assetPath);
      state = AsyncValue.data(pgnGame);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final pgnGameProvider = AsyncNotifierProvider.autoDispose
    .family<PgnGameNotifier, PgnGame, OpeningModel>(PgnGameNotifier.new);
