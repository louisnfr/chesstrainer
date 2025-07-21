import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isAnonymous;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.isAnonymous,
  });

  // Pour sauvegarder dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'isAnonymous': isAnonymous,
    };
  }

  // Pour récupérer depuis Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      isAnonymous: map['isAnonymous'],
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, '
        'email: $email, '
        'displayName: $displayName, '
        'isAnonymous: $isAnonymous)';
  }
}
