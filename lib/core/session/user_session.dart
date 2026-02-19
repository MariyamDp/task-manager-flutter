class UserSession {
  final String userId;
  DateTime startedAt = DateTime.now();

  UserSession({required this.userId});

  void dispose() {
    // clean up any resources here
  }
}
