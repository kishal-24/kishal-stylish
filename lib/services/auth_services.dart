
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {


final FirebaseAuth _auth = FirebaseAuth.instance;

final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
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


Future<UserCredential?> signInWithGoogle() async {
try {

  await _googleSignIn.initialize(
    serverClientId:
    ' 194467807514-d3imlvr67nb2gfke0ssql1bji06j0q07.apps.googleusercontent.com',
  );

final GoogleSignInAccount googleUser =
await _googleSignIn.authenticate();


final GoogleSignInAuthentication googleAuth =
googleUser.authentication;


final OAuthCredential credential =
GoogleAuthProvider.credential(
idToken: googleAuth.idToken,
);

final UserCredential userCredential =
await _auth.signInWithCredential(credential);

return userCredential;
} on FirebaseAuthException catch (e) {
print('Firebase Auth Error: ${e.code}');
print('Message: ${e.message}');

return null;
} catch (e) {
print('Google Sign-In Error: $e');

return null;
}
}


Future<void> sendPasswordResetEmail({
required String email,
}) async {
await _auth.sendPasswordResetEmail(
email: email,
);
}


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
User? get currentUser {
return _auth.currentUser;
}

User? getCurrentUser() {
return _auth.currentUser;
}
bool isLoggedIn() {
return _auth.currentUser != null;
}


Future<void> logout() async {
try {

await _googleSignIn.signOut();


await _auth.signOut();
} catch (e) {
print('Logout Error: $e');
}
}

Future<void> signOut() async {
await logout();
}
}

