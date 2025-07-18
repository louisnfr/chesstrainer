import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  static Future<UserModel?> signInAnonymously() async {
    try {
      if (kDebugMode) {
        print('Signing in anonymously...');
      }
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return UserModel(
        uid: user.uid,
        isAnonymous: user.isAnonymous,
        email: user.email,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in anonymously: $e');
      }
      return null;
    }
  }

  static Future<void> linkWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      _auth.currentUser?.linkWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print('Error linking credential: $e');
      }
    }
  }

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Future<void> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        if (kDebugMode) {
          print('No user is currently signed in.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user: $e');
      }
    }
  }
}
