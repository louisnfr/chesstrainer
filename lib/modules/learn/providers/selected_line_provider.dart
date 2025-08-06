// Provider pour gérer la ligne sélectionnée
import 'package:chesstrainer/modules/learn/services/learn_service.dart';
import 'package:chesstrainer/modules/opening/models/opening.dart';
import 'package:chesstrainer/modules/user/providers/user_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectedLineNotifier extends FamilyNotifier<int?, OpeningModel> {
  @override
  int? build(OpeningModel opening) {
    // Ne watch pas currentUserProvider pour éviter les changements automatiques
    // Utilise seulement read pour initialiser une seule fois
    final currentUser = ref.read(currentUserProvider);
    final userLearnedOpenings = currentUser?.learnedOpenings ?? [];
    return LearnService.getFirstUnlearnedLineIndex(
      opening,
      userLearnedOpenings,
    );
  }

  void selectLine(int lineIndex) {
    state = lineIndex;
  }
}

final selectedLineProvider = NotifierProvider.autoDispose
    .family<SelectedLineNotifier, int?, OpeningModel>(SelectedLineNotifier.new);
