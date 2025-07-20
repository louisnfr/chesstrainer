import 'package:chesstrainer/modules/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    _listenToAuthChanges();
    return null;
  }

  void _listenToAuthChanges() {
    AuthService.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user);
      } else {
        state = null;
      }
    });
  }

  Future<void> _loadUserData(User user) async {
    try {
      final userDocument = await UserService.getUser(user.uid);
      if (userDocument.exists) {
        final userData = userDocument.data() as Map<String, dynamic>;
        state = UserModel(
          uid: user.uid,
          email: user.email,
          username: userData['username'],
          isAnonymous: user.isAnonymous,
        );
      }
    } catch (e) {
      throw Exception('Error loading user data: $e');
    }
  }

  Future<void> createUser(String username) async {
    await UserService.createUser(username: username);
    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      await _loadUserData(currentUser);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Pas besoin de _loadUserData ici car authStateChanges() s'en charge
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<void> signInAnonymously() async {
    try {
      await AuthService.signInAnonymously();
      // Pas besoin de _loadUserData ici car authStateChanges() s'en charge
    } catch (e) {
      if (kDebugMode) {
        print('Anonymous sign in error: $e');
      }
      rethrow; // Pour permettre au widget de gérer l'erreur
    }
  }

  Future<void> signOut() async {
    await AuthService.signOut();
    state = null;
  }

  Future<void> deleteUser() async {
    try {
      await UserService.deleteUserData();
      await AuthService.deleteUserAccount();
      state = null;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
    }
  }
}

// Provider principal
final userNotifierProvider = NotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);

// Provider pour accéder à l'utilisateur
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(userNotifierProvider);
});

// Provider pour vérifier si l'utilisateur est connecté
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(userNotifierProvider) != null;
});
