import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pinput/pinput.dart';

import '../res/styles/dialogs.dart';
import '../res/styles/text_style.dart';
import './login_screen.dart';
import './home_page.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_auth_row.dart';

class OTPScreen extends StatefulWidget {
  static const String id = 'OTPScreen';

  final String phoneNumber;
  final String name;
  final bool signUp;

  const OTPScreen({
    Key? key,
    this.phoneNumber = '',
    this.name = '',
    this.signUp = false,
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinPutController = TextEditingController();
  String _verificationCode = '';
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        awesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: e.message!,
          okPress: () {},
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationCode = verificationId;

        awesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: '+91 ${widget.phoneNumber}',
          desc: 'OTP sent successfully.',
          okPress: () {},
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Verify your Identity',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/otp.svg',
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Enter One Time Passoword',
            style: kLoginHeadingTextStyle,
          ),
          const SizedBox(height: 10),
          const Text(
            'Wait while we sent OTP to your mobile number',
            style: kLoginSubHeadingTextStyle,
          ),
          otpBoxes(),
          showSpinner
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomButton(
                  label: 'Verify',
                  onPressed: verifyUser,
                ),
          const SizedBox(height: 20),
          AuthRow(
            () => Navigator.pushNamed(context, LoginScreen.id),
            'Go Back',
            'Not your phone number?',
          ),
        ],
      ),
    );
  }

  verifyUser() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          showSpinner = true;
        });
        await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
            verificationId: _verificationCode,
            smsCode: _pinPutController.text,
          ),
        );

        User user = _auth.currentUser!;
        if (widget.signUp) await createUserInFirestore(user);

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.id,
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid OTP \n${e.toString()}',
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        );
      }
      setState(() {
        showSpinner = false;
      });
    }
  }

  createUserInFirestore(User user) async {
    await user.updateDisplayName(widget.name);

    final CollectionReference userRef = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot doc = await userRef.doc(user.phoneNumber).get();

    if (!doc.exists) {
      await userRef.doc(user.phoneNumber).set({
        'id': user.uid,
        'name': widget.name,
        'phoneNumber': user.phoneNumber,
      });
    }
  }

  Container otpBoxes() => Container(
        padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Pinput(
            length: 6,
            validator: MultiValidator(
              [
                RequiredValidator(errorText: 'Otp boxes can\'t remain empty'),
                LengthRangeValidator(
                  min: 6,
                  max: 6,
                  errorText: 'Enter the complete verification Code',
                ),
              ],
            ).call,
            onSubmitted: (pin) => FocusScope.of(context).unfocus(),
            controller: _pinPutController,
            keyboardType: TextInputType.number,
            androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
          ),
        ),
      );
}
