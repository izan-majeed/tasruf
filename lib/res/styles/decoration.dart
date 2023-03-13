import 'package:flutter/material.dart';
import './theme.dart';

final kUserEnabledOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: const BorderSide(color: Colors.black12),
);

final pinPutDecoration = BoxDecoration(
  color: Colors.grey,
  borderRadius: BorderRadius.circular(20.0),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.grey, width: 2.0),
  ),
);

final kMessageInputBarDecoraton = BoxDecoration(
  color: kPrimaryColor.withAlpha(127),
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
  hintText: 'Type your messages here...',
  hintStyle: TextStyle(color: Colors.grey),
  border: InputBorder.none,
);
