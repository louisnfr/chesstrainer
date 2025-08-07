import 'package:flutter/foundation.dart' show immutable;

@immutable
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final List<String> learnedOpenings; // IDs des ouvertures apprises
  final String? lastOpeningId; // ID de la dernière ouverture jouée
  final DateTime createdAt;
  // final bool isAnonymous;

  const UserModel({
    required this.uid,
    required this.createdAt,
    // required this.isAnonymous,
    this.email,
    this.displayName,
    this.learnedOpenings = const [],
    this.lastOpeningId,
  });

  // Pour sauvegarder dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      // 'isAnonymous': isAnonymous,
      'learnedOpenings': learnedOpenings,
      'lastOpeningId': lastOpeningId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Pour récupérer depuis Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      // isAnonymous: map['isAnonymous'],
      learnedOpenings: List<String>.from(map['learnedOpenings'] ?? []),
      lastOpeningId: map['lastOpeningId'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  // CopyWith method for immutable updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isAnonymous,
    List<String>? learnedOpenings,
    String? lastOpeningId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      // isAnonymous: isAnonymous ?? this.isAnonymous,
      learnedOpenings: learnedOpenings ?? this.learnedOpenings,
      lastOpeningId: lastOpeningId ?? this.lastOpeningId,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, '
        'email: $email, '
        'createdAt: $createdAt, '
        'displayName: $displayName, '
        // 'isAnonymous: $isAnonymous, '
        'learnedOpenings: $learnedOpenings), '
        'lastOpeningId: $lastOpeningId';
  }
}
