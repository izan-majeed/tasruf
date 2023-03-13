import 'package:flutter/material.dart';
import '../res/styles/text_style.dart';

class AuthRow extends StatelessWidget {
  final Function tapHandler;
  final String richTextFieldText;
  final String text;

  const AuthRow(this.tapHandler, this.richTextFieldText, this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          child: Text(
            richTextFieldText,
            style: kLinkTextFieldTextStyle,
          ),
          onPressed: () => tapHandler(),
        )
      ],
    );
  }
}
