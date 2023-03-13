import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/auth_screen.dart';
import './screens/otp_screen.dart';
import './screens/login_screen.dart';
import './screens/sign_up_screen.dart';
import './screens/home_page.dart';
import './providers/theme_provider.dart';
import './providers/auth_provider.dart';
import './res/values/strings.dart';

// TODO: migrate to null safety
// TODO: write firebase cloud function to clear messages collection after 24 hours
// TODO: use singleton class for shared preferences

// FIXME: extract all the strings to a strings.dart file
// FIXME: update policy.md

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDark = prefs.getBool('isDark') ?? true;

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthProvider>(
          create: (_) => AuthProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) => context.read<AuthProvider>().authState,
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(
            isDark: isDark,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black12,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: Provider.of<ThemeProvider>(context).getCurrentTheme,
      initialRoute: AuthScreen.id,
      routes: {
        AuthScreen.id: (context) => const AuthScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        HomePage.id: (context) => const HomePage(),
        OTPScreen.id: (context) => const OTPScreen(),
      },
    );
  }
}
