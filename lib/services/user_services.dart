
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final FirebaseAuth _auth = FirebaseAuth.instance;


Future<void> saveUserData(User user) async {
await _firestore.collection('users').doc(user.uid).set(
{
'uid': user.uid,
'name': user.displayName ?? '',
'email': user.email ?? '',
'profileImage': user.photoURL ?? '',
'createdAt': FieldValue.serverTimestamp(),
},
SetOptions(merge: true),
);
}

Future<Map<String, dynamic>?> getUserData() async {
final User? user = _auth.currentUser;

if (user == null) {
return null;
}

final DocumentSnapshot document =
await _firestore.collection('users').doc(user.uid).get();

if (document.exists) {
return document.data() as Map<String, dynamic>;
}

return null;
}


Future<void> updateUserData({
String? name,
String? phone,
String? address,
String? profileImage,
}) async {
final User? user = _auth.currentUser;

if (user == null) {
throw Exception('No user is logged in');
}

final Map<String, dynamic> data = {};

if (name != null) {
data['name'] = name;
}

if (phone != null) {
data['phone'] = phone;
}

if (address != null) {
data['address'] = address;
}

if (profileImage != null) {
data['profileImage'] = profileImage;
}

if (data.isNotEmpty) {
await _firestore
    .collection('users')
    .doc(user.uid)
    .set(data, SetOptions(merge: true));
}
}
}

