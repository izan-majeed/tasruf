import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../res/styles/dialogs.dart';
import '../res/styles/text_style.dart';
import '../screens/otp_screen.dart';
import '../widgets/custom_auth_row.dart';
import '../widgets/custom_button.dart';
import '../widgets/user_input_field.dart';
import '../widgets/top_bar.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();
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
                title: 'Sign Up',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Join Tasruf!',
                      style: kLoginHeadingTextStyle,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'To get connected with other Tasrufdars.',
                      style: kLoginSubHeadingTextStyle,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    UserInputField(
                      textInputAction: TextInputAction.done,
                      icon: Icons.person,
                      labelText: 'Name',
                      maxLength: 20,
                      controller: _nameController,
                      customValidator: RequiredValidator(errorText: 'Enter your name').call,
                    ),
                    const SizedBox(height: 20),
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
                            errorText: 'Enter a valid phone number',
                          ),
                        ],
                      ).call,
                    ),
                    const SizedBox(height: 20),
                    showSpinner
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            label: 'Sign Up',
                            onPressed: signUp,
                          ),
                    const SizedBox(height: 30),
                    AuthRow(
                      () => Navigator.pop(context),
                      'Sign In',
                      'Already have an account',
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

  signUp() async {
    FocusScope.of(context).unfocus();
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          showSpinner = true;
        });
        CollectionReference userRef = FirebaseFirestore.instance.collection('users');
        DocumentSnapshot doc = await userRef.doc("+91${_phoneNumberController.text}").get();

        if (doc.exists) {
          awesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Sign up failed: ',
            desc: 'Account already exits!',
            okPress: () {},
          );
        } else if (!doc.exists) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: _phoneNumberController.text,
                name: _nameController.text,
                signUp: true,
              ),
            ),
            (route) => false,
          );
        }
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      awesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error: ',
        desc: e.toString(),
        okPress: () {},
      );
    }
  }
}
