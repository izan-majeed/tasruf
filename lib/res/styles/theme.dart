import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff8f94fb);
const kAccentColor = Color(0xff7c6a86);
const kBackgroundColor = Color(0xffF5F5F5);
const kBackgroundColorDark = Color(0xff151E29);
const kSenderBubbleColor = Color(0xff303E47);

final ThemeData lightTheme = ThemeData(
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme(
    primary: kPrimaryColor,
    primaryContainer: kPrimaryColor,
    secondary: kAccentColor,
    secondaryContainer: kAccentColor,
    surface: kBackgroundColor,
    background: kBackgroundColor,
    brightness: Brightness.light,
    onPrimary: kPrimaryColor,
    onSecondary: kAccentColor,
    onSurface: kBackgroundColor,
    onBackground: kBackgroundColor,
    onError: Color(0xffFFCDD2),
    error: Color(0xffFFCDD2),
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme(
    primary: kPrimaryColor,
    primaryContainer: kPrimaryColor,
    secondary: kAccentColor,
    secondaryContainer: kAccentColor,
    surface: kBackgroundColorDark,
    background: kBackgroundColorDark,
    brightness: Brightness.dark,
    onPrimary: kPrimaryColor,
    onSecondary: kAccentColor,
    onSurface: kBackgroundColorDark,
    onBackground: kBackgroundColorDark,
    onError: Color(0xffFFCDD2),
    error: Color(0xffFFCDD2),
  ),
);
