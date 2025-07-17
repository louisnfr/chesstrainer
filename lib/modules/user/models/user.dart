class UserModel {
  final String uid;
  final String? username;
  final bool isAnonymous;

  UserModel({required this.uid, this.username, required this.isAnonymous});

  @override
  String toString() {
    return 'UserModel(uid: $uid, '
        'username: $username, '
        'isAnonymous: $isAnonymous)';
  }
}
