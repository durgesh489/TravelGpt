import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../main_screen.dart';
import '../services/database_methods.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPswrdController = TextEditingController();
  TextEditingController pswrdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  bool showCPI = false;
  Future signUpWithEmailAndPassword() async {
    setState(() {
      showCPI = true;
    });
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: pswrdController.text);
      User? user = result.user;
      if (user != null) {
        prefs!.setString("id", user.uid);
        prefs!.setString("name", nameController.text);

        prefs!.setString("email", emailController.text);
        prefs!.setString("password", pswrdController.text);
        prefs!.setString("phone", phoneController.text);
        prefs!.setBool("islogin", true);
        DatabaseMethods().addUserInfoToDB(
            user.uid, {"email": emailController.text}).then((value) {
          goOff(context, MainScreen());
          showSnackbar(context, "Registration Successfully Welcome to Estate");
        });
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
      backgroundColor: mc,
      body: SafeArea(
        child: Container(
          width: fullWidth(context),
          height: fullHeight(context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: signUpKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    VSpace(40),
                    Image.asset(
                      "images/destination.png",
                      width: 150,
                      height: 150,
                    ),
                    VSpace(30),
                    CustomTextField(
                      controller: nameController,
                      validators: [
                        RequiredValidator(errorText: "This Field is Required"),
                      ],
                      hintText: "Enter Name",
                    ),
                    VSpace(10),
                    CustomTextField(
                      controller: phoneController,
                      validators: [
                        RequiredValidator(errorText: "This Field is Required"),
                        MinLengthValidator(10,
                            errorText: "Phone Number be should be 10 digits"),
                        MaxLengthValidator(10,
                            errorText: "Phone Number be should be 10 digits")
                      ],
                      hintText: "Enter Phone Number",
                      keyboardType: TextInputType.phone,
                    ),
                    VSpace(10),
                    CustomTextField(
                      controller: emailController,
                      validators: [
                        RequiredValidator(errorText: "This Field is Required"),
                        EmailValidator(errorText: "This is not a valid email")
                      ],
                      hintText: "Enter Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    VSpace(10),
                    CustomTextField(
                      controller: pswrdController,
                      validators: [
                        RequiredValidator(errorText: "This Field is Required"),
                        MinLengthValidator(8,
                            errorText: "Password should be atleast 8 digits")
                      ],
                      hintText: "Enter Password",
                      isPassword: true,
                    ),
                    VSpace(40),
                    showCPI
                        ? CircularProgressIndicator()
                        : PrimaryMaterialButton(context, () {
                            if (signUpKey.currentState!.validate()) {
                              signUpWithEmailAndPassword();
                            } else {
                              showSnackbar(
                                  context, "Please fill all fields correctly");
                            }
                          }, "SIGN UP"),
                    VSpace(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        nAppText("Already Registered ?", 17, white),
                        TextButton(
                            onPressed: () {
                              gotoWithoutBack(context, LogInScreen());
                            },
                            child: nAppText("Login", 17, green)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
