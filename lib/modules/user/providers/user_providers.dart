import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider pour le service
final userServiceProvider = Provider<UserService>((ref) => UserService());

// Provider pour récupérer les données utilisateur
final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);

  if (authState.value?.uid == null) return null;

  final user = await ref
      .read(userServiceProvider)
      .getUser(authState.value!.uid);
  return user;
});

// Provider simple pour récupérer juste les données (sans AsyncValue)
final currentUserProvider = Provider<UserModel?>((ref) {
  final userData = ref.watch(userDataProvider);
  return userData.when(
    data: (user) => user,
    loading: () => null,
    error: (_, _) => null,
  );
});

// Provider pour la dernière ouverture
final lastOpeningProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.lastOpeningId;
});

// Notifier pour les actions
class UserNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // État initial
  }

  Future<void> createUserProfile({required String displayName}) async {
    state = const AsyncLoading();

    try {
      // Récupérer l'utilisateur authentifié actuel
      final authUser = ref.read(authStateProvider).value;
      if (authUser == null) {
        throw Exception('No authenticated user');
      }

      final user = UserModel(
        uid: authUser.uid,
        email: authUser.email,
        displayName: displayName,
        isAnonymous: authUser.isAnonymous,
      );

      await ref.read(userServiceProvider).createUser(user);

      // Invalider le cache pour recharger les données
      ref.invalidate(userDataProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> markOpeningAsLearned(String openingId) async {
    state = const AsyncLoading();

    try {
      final authUser = ref.read(authStateProvider).value;
      if (authUser == null) {
        throw Exception('No authenticated user');
      }

      await ref
          .read(userServiceProvider)
          .addLearnedOpening(authUser.uid, openingId);

      // Invalider le cache pour recharger les données
      ref.invalidate(userDataProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> setLastOpening(String openingId) async {
    state = const AsyncLoading();

    try {
      final authUser = ref.read(authStateProvider).value;
      if (authUser == null) {
        throw Exception('No authenticated user');
      }

      await ref
          .read(userServiceProvider)
          .setLastOpening(authUser.uid, openingId);

      // Invalider le cache pour recharger les données
      ref.invalidate(userDataProvider);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// Provider pour le notifier
final userNotifierProvider = AsyncNotifierProvider<UserNotifier, void>(
  () => UserNotifier(),
);
