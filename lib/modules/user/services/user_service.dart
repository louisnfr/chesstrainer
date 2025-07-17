import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUser({required String username}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }

    await _firestore.collection('users').doc(user.uid).set({
      'username': username,
      'isAnonymous': user.isAnonymous,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  static Future<void> deleteUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
      } else {
        if (kDebugMode) {
          print('No user is currently signed in.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user data: $e');
      }
    }
  }
}
