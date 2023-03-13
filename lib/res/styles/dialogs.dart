import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import './theme.dart';

AwesomeDialog awesomeDialog({
  BuildContext context,
  DialogType dialogType,
  String title,
  String desc,
  Function okPress,
  Function cancelPress,
}) {
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: AnimType.topSlide,
    autoHide: const Duration(seconds: 4),
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
