import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/opening/providers/opening_pgn_provider.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:dartchess/dartchess.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider pour gérer la ligne sélectionnée
class SelectedLineNotifier extends FamilyNotifier<int?, OpeningModel> {
  @override
  int? build(OpeningModel opening) {
    final currentUser = ref.watch(currentUserProvider);
    final userLearnedOpenings = currentUser?.learnedOpenings ?? [];
    return opening.getFirstUnlearnedLineIndex(userLearnedOpenings);
  }

  void selectLine(int lineIndex) {
    state = lineIndex;
  }
}

// Provider pour le PgnGame basé sur l'opening et la ligne sélectionnée
class LearnPagePgnGameNotifier
    extends FamilyAsyncNotifier<PgnGame, OpeningModel> {
  @override
  Future<PgnGame> build(OpeningModel opening) async {
    final selectedLine = ref.watch(selectedLineProvider(opening));
    if (selectedLine == null) {
      throw Exception('No line selected');
    }

    final assetPath =
        'assets/openings/${opening.id}/${opening.id}_$selectedLine.pgn';
    final pgnNotifier = ref.read(pgnGameNotifierProvider(assetPath).notifier);
    return await pgnNotifier.loadGame(assetPath);
  }

  Future<void> loadLine(int lineIndex) async {
    final assetPath = 'assets/openings/${arg.id}/${arg.id}_$lineIndex.pgn';

    try {
      final pgnNotifier = ref.read(pgnGameNotifierProvider(assetPath).notifier);
      final pgnGame = await pgnNotifier.loadGame(assetPath);
      // Mise à jour directe sans état loading visible
      state = AsyncValue.data(pgnGame);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Providers
final selectedLineProvider = NotifierProvider.autoDispose
    .family<SelectedLineNotifier, int?, OpeningModel>(SelectedLineNotifier.new);

final learnPagePgnGameProvider = AsyncNotifierProvider.autoDispose
    .family<LearnPagePgnGameNotifier, PgnGame, OpeningModel>(
      LearnPagePgnGameNotifier.new,
    );
