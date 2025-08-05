import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isAnonymous;
  final List<String> learnedOpenings; // IDs des ouvertures apprises
  final String? lastOpeningId; // ID de la dernière ouverture jouée

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.isAnonymous,
    this.learnedOpenings = const [],
    this.lastOpeningId,
  });

  // Pour sauvegarder dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'isAnonymous': isAnonymous,
      'learnedOpenings': learnedOpenings,
      'lastOpeningId': lastOpeningId,
    };
  }

  // Pour récupérer depuis Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      isAnonymous: map['isAnonymous'],
      learnedOpenings: List<String>.from(map['learnedOpenings'] ?? []),
      lastOpeningId: map['lastOpeningId'],
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, '
        'email: $email, '
        'displayName: $displayName, '
        'isAnonymous: $isAnonymous, '
        'learnedOpenings: $learnedOpenings), '
        'lastOpeningId: $lastOpeningId';
  }
}
