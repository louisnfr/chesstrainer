import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserModel?> signInAnonymously() async {
    try {
      if (kDebugMode) {
        print('Signing in anonymously...');
      }
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return UserModel(uid: user.uid, isAnonymous: user.isAnonymous);
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in anonymously: $e');
      }
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
    }
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
