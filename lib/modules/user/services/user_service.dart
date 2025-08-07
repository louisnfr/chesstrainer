import 'package:chesstrainer/modules/user/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set({...user.toMap()});
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;

    return UserModel.fromMap(data);
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<void> addLearnedOpening(String uid, String openingId) async {
    await _firestore.collection('users').doc(uid).update({
      'learnedOpenings': FieldValue.arrayUnion([openingId]),
    });
  }

  Future<void> setLastOpening(String uid, String openingId) async {
    await _firestore.collection('users').doc(uid).update({
      'lastOpeningId': openingId,
    });
  }
}
