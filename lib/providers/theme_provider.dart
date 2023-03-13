import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/styles/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = darkTheme;

  ThemeProvider({isDark}) {
    _currentTheme = isDark ? darkTheme : lightTheme;
  }

  ThemeData get getCurrentTheme => _currentTheme;

  Future<void> switchTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_currentTheme == darkTheme) {
      _currentTheme = lightTheme;
      prefs.setBool('isDark', false);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: kPrimaryColor,
        ),
      );
    } else {
      _currentTheme = darkTheme;
      prefs.setBool('isDark', true);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black12,
        ),
      );
    }
    notifyListeners();
  }
}
