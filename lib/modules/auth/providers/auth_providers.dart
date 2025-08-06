import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(_authServiceProvider).authStateChanges();
});

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // État initial
  }

  Future<void> signInAnonymously() async {
    state = const AsyncLoading();

    try {
      await ref.read(_authServiceProvider).signInAnonymously();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(_authServiceProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(_authServiceProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      // User profile will be created automatically by UserNotifier when it detects
      // a new authenticated user without a database profile

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    try {
      await ref.read(_authServiceProvider).signOut();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);
