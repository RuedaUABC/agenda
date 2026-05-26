class LocalUser {
  final String displayName;

  const LocalUser({required this.displayName});
}

class LocalUserCredential {
  final LocalUser? user;

  const LocalUserCredential({required this.user});
}

class AuthService {
  LocalUser? _currentUser;

  LocalUser? getCurrentUser() {
    return _currentUser;
  }

  Future<LocalUserCredential> signInLocally() async {
    _currentUser = const LocalUser(displayName: 'Usuario local');
    return LocalUserCredential(user: _currentUser);
  }

  Future<void> signOut() async {
    _currentUser = null;
  }
}
