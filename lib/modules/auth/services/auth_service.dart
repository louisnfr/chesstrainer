import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<User?> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return result.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
