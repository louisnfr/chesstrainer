import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _authServiceProvider = Provider<AuthService>((ref) => AuthService());
final _userServiceProvider = Provider<UserService>((ref) => UserService());

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
      final user = await ref
          .read(_authServiceProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user profile in Firestore immediately after account creation
      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.email?.split('@').first ?? 'User',
          isAnonymous: user.isAnonymous,
        );

        await ref.read(_userServiceProvider).createUser(userModel);
      }

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
