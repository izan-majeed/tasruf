import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../res/styles/dialogs.dart';
import '../res/styles/text_style.dart';
import '../screens/otp_screen.dart';
import '../screens/sign_up_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/user_input_field.dart';
import '../widgets/top_bar.dart';
import '../widgets/custom_auth_row.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const TopBar(
                title: 'Sign In',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Welcome!',
                      style: kLoginHeadingTextStyle,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign-in and get connected to Kashmir\'s first open chat app.',
                      style: kLoginSubHeadingTextStyle,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    UserInputField(
                      textInputAction: TextInputAction.done,
                      icon: Icons.phone,
                      labelText: 'Phone Number',
                      prefixText: '+91 ',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _phoneNumberController,
                      customValidator: MultiValidator(
                        [
                          RequiredValidator(
                            errorText: 'Where is your phone number?',
                          ),
                          LengthRangeValidator(
                            min: 10,
                            max: 10,
                            errorText: 'Enter a valid 10 digit phone number',
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    showSpinner
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            label: 'Log In',
                            onPressed: logIn,
                          ),
                    const SizedBox(height: 30),
                    AuthRow(
                      () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      'Sign up',
                      'Don\'t have an account?',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  logIn() async {
    FocusScope.of(context).unfocus();
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          showSpinner = true;
        });
        CollectionReference userRef = FirebaseFirestore.instance.collection('users');
        DocumentSnapshot doc = await userRef.doc("+91${_phoneNumberController.text}").get();

        if (doc.exists) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: _phoneNumberController.text,
              ),
            ),
            (route) => false,
          );
        } else if (!doc.exists) {
          awesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Sign in failed: ',
            desc: 'Account not found!\nYou\'ve to create an account first ',
            okPress: () {
              Navigator.pushNamed(context, SignUpScreen.id);
            },
          );
        }
      }
    } catch (e) {
      awesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error: ',
        desc: e.message,
        okPress: () {},
      );
    }
    setState(() {
      showSpinner = false;
    });
  }
}
