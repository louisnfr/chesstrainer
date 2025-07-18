class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final bool isAnonymous;

  UserModel({
    required this.uid,
    this.username,
    required this.isAnonymous,
    required this.email,
  });

  @override
  String toString() {
    return 'UserModel(uid: $uid, '
        'email: $email, '
        'username: $username, '
        'isAnonymous: $isAnonymous)';
  }
}
