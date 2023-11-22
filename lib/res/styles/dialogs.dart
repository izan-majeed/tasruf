import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import './theme.dart';

AwesomeDialog awesomeDialog({
  required BuildContext context,
  required DialogType dialogType,
  required String title,
  void Function()? okPress,
  void Function()? cancelPress,
  bool autoHide = true,
  String? desc,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: AnimType.topSlide,
    autoHide: autoHide ? const Duration(seconds: 4) : null,
    title: title,
    desc: desc,
    btnOkOnPress: okPress,
    btnCancelOnPress: cancelPress,
    btnOkColor: kAccentColor,
    btnCancelColor: Colors.red[100],
    buttonsTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    borderSide: const BorderSide(color: kPrimaryColor, width: 1),
    buttonsBorderRadius: const BorderRadius.all(Radius.circular(30)),
  )..show();
}
