import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider pour le service
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// StreamProvider pour écouter les changements d'auth
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authServiceProvider).authStateChanges();
});

// Notifier pour les actions
class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // État initial
  }

  Future<void> signInAnonymously() async {
    state = const AsyncLoading();

    try {
      await ref.read(authServiceProvider).signInAnonymously();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    try {
      await ref.read(authServiceProvider).signOut();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);
