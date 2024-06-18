import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/snackbar.dart';

import 'main_screen.dart';
import 'otp_screen.dart';
import 'sign_up_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String authType = "EMAIL";
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController pswrdC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  bool showCPI = false;
  signInWithEmailAndPassword() async {
    setState(() {
      showCPI = true;
    });
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailC.text, password: pswrdC.text);
      User? user = result.user;

      if (user != null) {
        try {
          QuerySnapshot qs = await FirebaseFirestore.instance
              .collection("users")
              .where("user_email", isEqualTo: emailC.text)
              .get();
          String? token = await FirebaseMessaging.instance.getToken();

          prefs!.setString("user_id", user.uid);
          prefs!.setString("user_name", qs.docs[0]["name"]);
          prefs!.setString("user_profile", user.photoURL ?? "");
          prefs!.setString("user_token", token!);
          prefs!.setString("user_email", emailC.text);
          prefs!.setString("user_password", pswrdC.text);
          prefs!.setBool("user_login", true);
          goOff(context, MainScreen());
          showSnackbar(context, "Login Successfully");
        } catch (e) {
          setState(() {
            showCPI = false;
          });

          showSnackbar(context, e.toString());
        }
      }
    } catch (e) {
      setState(() {
        showCPI = false;
      });
      showSnackbar(context, e.toString());
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn();
  signInWithGoogle() async {
    try {
      GoogleSignInAccount? user = await googleSignIn.signIn();
      String? token = await FirebaseMessaging.instance.getToken();

      prefs!.setBool("user_login", true);
      prefs!.setString("user_id", user!.id);
      prefs!.setString("user_name", user.displayName ?? "");
      prefs!.setString("user_profile", user.photoUrl ?? "");
      prefs!.setString("user_phone", "");
      prefs!.setString("user_email", user.email);
      prefs!.setString("user_token", token!);
      prefs!.setString("user_password", "");

      await FirebaseFirestore.instance.collection("users").doc(user.id).set({
        "user_id": user.id,
        "user_name": user.displayName,
        "user_phone": "",
        "user_email": user.email,
        "user_token": token,
        "user_rating": 0,
        "user_reviews_by": [],
        "user_password": "",
        "user_blood_group": "",
        "user_profile": user.photoUrl??""
      });

      goOff(context, MainScreen());
    } catch (error) {
      print(error);
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //     child: Image.asset(
                    //   "images/logo.jpg",
                    //   height: 200,
                    // )),
                    // VGap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BoldText("Login", 28),
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

                    authType == "PHONE"
                        ? CustomTextField(
                            controller: phoneC,
                            validators: [
                              RequiredValidator(
                                  errorText: "This field is required"),
                              MinLengthValidator(10,
                                  errorText:
                                      "Phone Number should be 10 digits"),
                              MaxLengthValidator(10,
                                  errorText:
                                      "Phone Number should be 10 digits"),
                            ],
                            hintText: "Phone Number",
                            title: "Phone Number",
                            keyboardType: TextInputType.phone,
                          )
                        : CustomTextField(
                            controller: emailC,
                            validators: [
                              RequiredValidator(
                                  errorText: "This field is required"),
                              EmailValidator(
                                  errorText: "This is not a valid email")
                            ],
                            hintText: "Email",
                            title: "Email",
                            keyboardType: TextInputType.emailAddress,
                          ),
                    CustomTextField(
                      controller: pswrdC,
                      validators: [
                        RequiredValidator(errorText: "This field is required"),
                      ],
                      hintText: "Password",
                      isPassword: true,
                      title: "Password",
                    ),
                    VGap(10),
                    Row(
                      children: [
                        NormalText("Don't have an account?", 15),
                        TextButton(
                            onPressed: () {
                              goToWithoutBack(context, SignupScreen());
                            },
                            child: NAppText("Sign up now!", 15, blue))
                      ],
                    ),

                    VGap(40),
                    showCPI
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : PrimaryMaterialButton(context, "Sign In", () async {
                            if (formKey.currentState!.validate()) {
                              if (authType == "EMAIL") {
                                signInWithEmailAndPassword();
                              } else {
                                setState(() {
                                  showCPI = true;
                                });
                                QuerySnapshot qs = await FirebaseFirestore
                                    .instance
                                    .collection("users")
                                    .where("phone", isEqualTo: phoneC.text)
                                    .get();
                                print(qs.docs.length);
                                if (qs.docs.length > 0 &&
                                    pswrdC.text == qs.docs[0]["password"]) {
                                  goTo(
                                      context,
                                      OTPScreen(
                                        name: qs.docs[0]["user_name"],
                                        phoneNumber: qs.docs[0]["user_phone"],
                                        email: qs.docs[0]["user_email"],
                                        password: qs.docs[0]["user_password"],
                                        type: 1,
                                        rating: qs.docs[0]["user_rating"],
                                        reviews: qs.docs[0]["user_reviews_by"],
                                        profile: qs.docs[0]["user_profile"],
                                      ));
                                } else {
                                  showSnackbar(context,
                                      "Invalid Phone Number or Password");
                                }
                              }
                              setState(() {
                                showCPI = false;
                              });
                            } else {
                              setState(() {
                                showCPI = false;
                              });
                              showSnackbar(
                                  context, "Please Fill all fields correctly");
                            }
                          }),
                    VGap(15),

                    Center(child: NormalText("Or", 16)),
                    VGap(15),
                    MaterialButton(
                      minWidth: fullWidth(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      height: 45,
                      color: white,
                      onPressed: () {
                        signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/google.png",
                            width: 20,
                            height: 20,
                          ),
                          HGap(10),
                          Text(
                            "Sign In With Google",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    VGap(10),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
