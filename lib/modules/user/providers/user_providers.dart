import 'package:chesstrainer/modules/auth/providers/auth_providers.dart';
import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider pour le service
final userServiceProvider = Provider<UserService>((ref) => UserService());

// Main user state notifier that manages UserModel directly
class UserNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    // Watch auth state changes and automatically fetch user data
    final authState = ref.watch(authStateProvider);

    if (authState.value?.uid == null) {
      return null;
    }

    final authUser = authState.value!;

    try {
      final user = await ref.read(userServiceProvider).getUser(authUser.uid);

      // If user exists in database, return it
      if (user != null) {
        return user;
      }

      // If user doesn't exist in database, create a basic profile automatically
      final newUser = UserModel(
        uid: authUser.uid,
        email: authUser.email,
        displayName: authUser.email?.split('@').first ?? 'User',
        isAnonymous: authUser.isAnonymous,
      );

      // Create the user in the database
      await ref.read(userServiceProvider).createUser(newUser);

      return newUser;
    } catch (e) {
      // On any error, return null and let the UI handle it
      return null;
    }
  }

  Future<void> createUserProfile({required String displayName}) async {
    final authUser = ref.read(authStateProvider).value;
    if (authUser == null) {
      throw Exception('No authenticated user');
    }

    final newUser = UserModel(
      uid: authUser.uid,
      email: authUser.email,
      displayName: displayName,
      isAnonymous: authUser.isAnonymous,
    );

    // Optimistic update: update local state immediately
    state = AsyncData(newUser);

    try {
      await ref.read(userServiceProvider).createUser(newUser);
      // Success: state is already updated optimistically
    } catch (e) {
      // Rollback on error
      state = const AsyncData(null);
      rethrow;
    }
  }

  Future<void> markOpeningAsLearned(String openingId) async {
    final currentUser = state.value;
    if (currentUser == null) {
      throw Exception('No user data available');
    }

    // Optimistic update: add opening to learned list immediately
    final updatedLearnedOpenings = [...currentUser.learnedOpenings];
    if (!updatedLearnedOpenings.contains(openingId)) {
      updatedLearnedOpenings.add(openingId);
    }

    final optimisticUser = currentUser.copyWith(
      learnedOpenings: updatedLearnedOpenings,
    );
    state = AsyncData(optimisticUser);

    try {
      await ref
          .read(userServiceProvider)
          .addLearnedOpening(currentUser.uid, openingId);
      // Success: state is already updated optimistically
    } catch (e) {
      // Rollback on error
      state = AsyncData(currentUser);
      rethrow;
    }
  }

  Future<void> setLastOpening(String openingId) async {
    final currentUser = state.value;
    if (currentUser == null) {
      throw Exception('No user data available');
    }

    // Optimistic update: set last opening immediately
    final optimisticUser = currentUser.copyWith(lastOpeningId: openingId);
    state = AsyncData(optimisticUser);

    try {
      await ref
          .read(userServiceProvider)
          .setLastOpening(currentUser.uid, openingId);
      // Success: state is already updated optimistically
    } catch (e) {
      // Rollback on error
      state = AsyncData(currentUser);
      rethrow;
    }
  }

  Future<void> updateUser(UserModel updatedUser) async {
    final currentUser = state.value;
    if (currentUser == null) {
      throw Exception('No user data available');
    }

    // Optimistic update: update local state immediately
    state = AsyncData(updatedUser);

    try {
      await ref.read(userServiceProvider).updateUser(updatedUser);
      // Success: state is already updated optimistically
    } catch (e) {
      // Rollback on error
      state = AsyncData(currentUser);
      rethrow;
    }
  }
}

// Main user notifier provider
final userNotifierProvider = AsyncNotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

// Derived provider for current user (without AsyncValue wrapper)
final currentUserProvider = Provider<UserModel?>((ref) {
  final userData = ref.watch(userNotifierProvider);
  return userData.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Derived provider for last opening
final lastOpeningProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.lastOpeningId;
});

// Derived provider for learned openings
final learnedOpeningsProvider = Provider<List<String>>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.learnedOpenings ?? [];
});

// Helper provider to check if a specific opening is learned
final isOpeningLearnedProvider = Provider.family<bool, String>((
  ref,
  openingId,
) {
  final learnedOpenings = ref.watch(learnedOpeningsProvider);
  return learnedOpenings.contains(openingId);
});

// Helper provider to get user loading state
final userLoadingProvider = Provider<bool>((ref) {
  final userData = ref.watch(userNotifierProvider);
  return userData.isLoading;
});

// Helper provider to get user error state
final userErrorProvider = Provider<Object?>((ref) {
  final userData = ref.watch(userNotifierProvider);
  return userData.error;
});
