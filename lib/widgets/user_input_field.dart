import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../res/styles/decoration.dart';

class UserInputField extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final String prefixText;
  final bool obscureText;
  final int maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final FormFieldValidator<String> customValidator;
  final FloatingLabelBehavior floatingLabelBehavior;
  final TextInputAction textInputAction;

  const UserInputField({
    Key key,
    this.icon,
    this.labelText,
    this.prefixText = '',
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.maxLength = 10,
    this.controller,
    this.obscureText = false,
    this.customValidator,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      validator: customValidator,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        prefix: Text(prefixText),
        labelText: labelText,
        counterText: '',
        filled: true,
        floatingLabelBehavior: floatingLabelBehavior,
        enabledBorder: kUserEnabledOutlineBorder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
