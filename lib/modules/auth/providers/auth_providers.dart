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

// Separate notifier for login
class LoginNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // État initial
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
}

// Separate notifier for register
class RegisterNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // État initial
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
          createdAt: DateTime.now(),
        );

        await ref.read(_userServiceProvider).createUser(userModel);
      }

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// General auth notifier for other operations
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

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, void>(
  LoginNotifier.new,
);

final registerNotifierProvider = AsyncNotifierProvider<RegisterNotifier, void>(
  RegisterNotifier.new,
);

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);
