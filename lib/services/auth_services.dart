import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }



  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email,
    );
  }
  // =========================
  // UPDATE PASSWORD
  // =========================
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No logged-in user found.',
      );
    }

    await user.updatePassword(
      newPassword,
    );
  }


  Future<void> logout() async {
    await _auth.signOut();
  }


  User? get currentUser {
    return _auth.currentUser;
  }
}