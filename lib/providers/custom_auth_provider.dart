import 'package:firebase_auth/firebase_auth.dart';

class CustomAuthProvider {
  final FirebaseAuth auth;

  CustomAuthProvider(this.auth);

  Stream<User?> get authState => auth.idTokenChanges();
}
