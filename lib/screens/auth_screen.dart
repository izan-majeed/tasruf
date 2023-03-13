import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../screens/home_page.dart';
import '../screens/login_screen.dart';

class AuthScreen extends StatelessWidget {
  static const String id = "AuthScreen";

  const AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    return (user != null) ? const HomePage() : const LoginScreen();
  }
}
