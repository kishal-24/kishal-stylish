import 'package:firebase_auth/firebase_auth.dart';

import '../data/services/auth_services.dart';

class AuthRepository {
  AuthRepository({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  Future<UserCredential?> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }
}
