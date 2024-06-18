import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:travel_gpt/screens/main_screen.dart';

import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/snackbar.dart';
import 'home_screen.dart';

class OTPScreen extends StatefulWidget {
  final String name, phoneNumber, email, password, profile;
  final int type, rating;
  final List reviews;

  const OTPScreen(
      {super.key,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.password,
      required this.type,
      required this.rating,
      required this.reviews,
      required this.profile});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  late String _verificationId;
  bool isLoading = true;

  Future signInWithPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + widget.phoneNumber,
      timeout: Duration(seconds: 50),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            String? token = await FirebaseMessaging.instance.getToken();

            prefs!.setBool("user_login", true);
            prefs!.setString("user_id", value.user!.uid);

            prefs!.setString("user_name", widget.name);

            prefs!.setString("user_phone", widget.phoneNumber);
            prefs!.setString("user_email", widget.email);
            prefs!.setString("user_token", token!);
            prefs!.setString("user_password", widget.password);

            if (widget.type == 0) {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(value.user!.uid)
                  .set({
                "user_id": value.user!.uid,
                "user_name": widget.name,
                "user_phone": widget.phoneNumber,
                "user_email": widget.email,
                "user_token": token,
                "user_rating": widget.rating,
                "user_reviews_by": widget.reviews,
                "user_password": widget.password,
                "user_blood_group": "",
                "user_profile": "",
              });
            }
          }
        });
        goOff(context, MainScreen());
        showSnackbar(
            context,
            widget.type == 0
                ? "Registered Successfully"
                : "Login Successfully");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackbar(context, e.code);
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackbar(context, "Code Sent");
        setState(() {
          _verificationId = verificationId;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackbar(context, "codeAutoRetrievalTimeout");
        setState(() {
          _verificationId = verificationId;
          isLoading = false;
        });
      },
    );
  }

  Future verifyOtp() async {
    try {
      isLoading = true;
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationId, smsCode: otpController.text))
          .then((value) async {
        if (value.user != null) {
          String? token = await FirebaseMessaging.instance.getToken();

          prefs!.setBool("user_login", true);
          prefs!.setString("user_id", value.user!.uid);

          prefs!.setString("user_name", widget.name);

          prefs!.setString("user_phone", widget.phoneNumber);
          prefs!.setString("user_email", widget.email);
          prefs!.setString("user_token", token!);
          prefs!.setString("user_password", widget.password);

          if (widget.type == 0) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(value.user!.uid)
                .set({
              "user_id": value.user!.uid,
              "user_name": widget.name,
              "user_phone": widget.phoneNumber,
              "user_email": widget.email,
              "user_token": token,
              "user_rating": widget.rating,
              "user_reviews_by": widget.reviews,
              "user_password": widget.password,
              "user_blood_group": "",
              "user_profile": "",
            });
          }
        }
      });
      goOff(context, MainScreen());
      showSnackbar(context,
          widget.type == 0 ? "Registered Successfully" : "Login Successfully");
    } catch (e) {
      isLoading = false;
      setState(() {});
      FocusScope.of(context).unfocus();
      showSnackbar(context, e.toString());
    }
  }

  // void _listenForOtp() async {
  //   await SmsAutoFill().listenForCode;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    signInWithPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoldText("Enter OTP", 25),
                    VGap(20),
                    Text(
                      "+91" + " " + widget.phoneNumber,
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "A six digit number has come to your registered number. Enter it and after verification move forward",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 30),
                    // PinFieldAutoFill(
                    //   codeLength: 6,
                    // ),
                    SizedBox(
                      height: 55,
                      child: Pinput(
                        length: 6,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        androidSmsAutofillMethod:
                            AndroidSmsAutofillMethod.smsRetrieverApi,
                        controller: otpController,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                      ),
                    ),
                    SizedBox(height: 30),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : PrimaryMaterialButton(
                            context,
                            "Continue",
                            () {
                              if (otpController.text != "") {
                                verifyOtp();
                              } else {
                                showSnackbar(context, "Please fill OTP");
                              }
                            },
                          )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
