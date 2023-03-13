import 'package:flutter/material.dart';

import '../res/styles/theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final List<Color> colorList;

  const CustomButton({
    Key key,
    this.label,
    this.onPressed,
    this.colorList = const [
      kPrimaryColor,
      Color(0xffBDC0FD),
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: colorList,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
