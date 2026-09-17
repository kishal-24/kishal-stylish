class AuthModel {
  final String email;
  final String password;

  const AuthModel({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
