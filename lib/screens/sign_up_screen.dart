import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:travel_gpt/screens/main_screen.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/snackbar.dart';
import 'otp_screen.dart';
import 'signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameC = new TextEditingController();

  TextEditingController phoneC = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  TextEditingController pswrdC = new TextEditingController();
  TextEditingController cnfrmPswrdC = new TextEditingController();
  String authType = "EMAIL";

  bool showCPI = false;
  Future signUpWithEmailAndPassword() async {
    setState(() {
      showCPI = true;
    });
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text, password: pswrdC.text);
      User? user = result.user;
      if (user != null) {
        String? token = await FirebaseMessaging.instance.getToken();
        prefs!.setString("user_id", user.uid);
        prefs!.setString("user_name", nameC.text);
        prefs!.setString("user_profile", user.photoURL ?? "");

        prefs!.setString("user_email", emailC.text);
        prefs!.setString("user_password", pswrdC.text);
        prefs!.setBool("user_login", true);
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "user_id": user.uid,
          "user_name": nameC.text,
          "user_phone": "",
          "user_email": emailC.text,
          "user_token": token,
          "user_rating": 0,
          "user_reviews_by": [],
          "user_password": "",
          "user_blood_group": "",
          "user_profile": user.photoURL ?? ""
        });
        goOff(context, MainScreen());
      }
    } catch (e) {
      setState(() {
        showCPI = false;
      });
      print(e);
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: fullWidth(context),
              height: fullHeight(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(child: Image.asset("images/logo.jpg",height: 200,)),
                  // VGap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoldText("Create Account", 28),
                      TextButton(
                          onPressed: () {
                            if (authType == "EMAIL") {
                              authType = "PHONE";
                            } else {
                              authType = "EMAIL";
                            }
                            setState(() {});
                          },
                          child: NAppText(authType, 15, blue))
                    ],
                  ),

                  CustomTextField(
                    controller: nameC,
                    validators: [
                      RequiredValidator(errorText: "This field is required")
                    ],
                    hintText: "Name",
                    title: "Name",
                  ),
                  authType == "PHONE"
                      ? CustomTextField(
                          controller: phoneC,
                          validators: [
                            RequiredValidator(
                                errorText: "This field is required"),
                            MinLengthValidator(10,
                                errorText: "Phone Number should be 10 digits"),
                            MaxLengthValidator(10,
                                errorText: "Phone Number should be 10 digits"),
                          ],
                          keyboardType: TextInputType.number,
                          hintText: "Phone Number",
                          title: "Phone Number",
                        )
                      : CustomTextField(
                          controller: emailC,
                          validators: [
                            RequiredValidator(
                                errorText: "This field is required"),
                            EmailValidator(errorText: "This is not valid Email")
                          ],
                          hintText: "Email",
                          title: "Email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                  CustomTextField(
                    controller: pswrdC,
                    validators: [
                      RequiredValidator(errorText: "This field is required")
                    ],
                    hintText: "Password",
                    isPassword: true,
                    title: "Password",
                  ),
                  Row(
                    children: [
                      NormalText("Already have an account?", 15),
                      TextButton(
                          onPressed: () {
                            goToWithoutBack(context, SigninScreen());
                          },
                          child: NAppText("Sign in!", 15, blue))
                    ],
                  ),
                  // CustomTextField(
                  //   controller: cnfrmPswrdC,
                  //   validators: [
                  //     RequiredValidator(errorText: "This field is required")
                  //   ],
                  //   hintText: "Confirm Password",
                  //   isPassword: true,
                  //   title: "Confirm Password",
                  // ),

                  VGap(20),
                  showCPI
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : PrimaryMaterialButton(context, "Sign Up", () async {
                          if (formKey.currentState!.validate()) {
                            if (authType == "EMAIL") {
                              signUpWithEmailAndPassword();
                            } else {
                              setState(() {
                                showCPI = true;
                              });
                              QuerySnapshot qs = await FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .where("phone", isEqualTo: phoneC.text)
                                  .get();
                              if (qs.docs.length > 0) {
                                showSnackbar(context,
                                    "The user for this phone number already exits.Please login");
                              } else {
                                goTo(
                                    context,
                                    OTPScreen(
                                      name: nameC.text,
                                      phoneNumber: phoneC.text,
                                      email: emailC.text,
                                      password: pswrdC.text,
                                      type: 0,
                                      rating: 0,
                                      reviews: [],
                                      profile: "",
                                    ));
                              }
                              setState(() {
                                showCPI = false;
                              });
                            }
                          } else {
                            setState(() {
                              showCPI = false;
                            });
                            showSnackbar(
                                context, "Please Fill all fields correctly");
                          }
                        })
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
