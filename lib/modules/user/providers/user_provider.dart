import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:chesstrainer/modules/user/services/user_service.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _loadUserData(user);
      } else {
        state = null;
      }
    });
  }

  Future<void> _loadUserData(User user) async {
    try {
      final userDoc = await UserService.getUser(user.uid);
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        state = UserModel(
          uid: user.uid,
          username: userData['username'],
          isAnonymous: user.isAnonymous,
        );
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> createUser(String username) async {
    await UserService.createUser(username: username);
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _loadUserData(currentUser);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = null;
  }
}

// Provider principal
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserModel?>(
  (ref) => UserNotifier(),
);

// Provider pour accéder à l'utilisateur
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(userNotifierProvider);
});

// Provider pour vérifier si l'utilisateur est connecté
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(userNotifierProvider) != null;
});
