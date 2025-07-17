import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return UserModel(uid: user.uid, isAnonymous: user.isAnonymous);
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }
}
