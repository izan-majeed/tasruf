import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth auth;
  AuthProvider(this.auth);

  Stream<User> get authState => auth.idTokenChanges();
}
