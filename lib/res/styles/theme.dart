import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff8f94fb);
const kAccentColor = Color(0xff7c6a86);
const kBackgroundColor = Color(0xffF5F5F5);
const kBackgroundColorDark = Color(0xff151E29);
const kSenderBubbleColor = Color(0xff303E47);

final ThemeData lightTheme = ThemeData(
  primaryColor: kPrimaryColor,
  colorScheme: ColorScheme(
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
    onError: Colors.red[200],
    error: Colors.red[200],
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme(
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
    onError: Colors.red[200],
    error: Colors.red[200],
  ),
);