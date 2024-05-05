
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isPhone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppName(25, false),
                  VSpace(30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          boldText(
                              isPhone
                                  ? "Enter Phone Number"
                                  : "Enter Email Address",
                              14),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  isPhone = !isPhone;
                                });
                              },
                              child: nAppText(
                                  isPhone
                                      ? "Switch to Email"
                                      : "Switch to Phone Number",
                                  13,
                                  mc))
                        ],
                      ),
                      VSpace(10),
                      CustomTextField(
                        controller: emailController,
                        validators: [],
                        hintText: isPhone
                            ? "Enter Phone Number"
                            : "Enter Email Address",
                      ),
                    ],
                  ),
                 VSpace(40),
                  PrimaryMaterialButton(context, () {}, "Next"),
                 
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
