
import 'package:flutter/material.dart';
import 'package:travel_gpt/constants/colors.dart';

import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController prePswrdController = TextEditingController();
  TextEditingController newPswrdController = TextEditingController();
  TextEditingController confirmPswrdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            goBack(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        title: boldText("Change Password", 22),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText("Enter Your Previous Password", 14),
                      VSpace(10),
                      CustomTextField(
                        controller: prePswrdController,
                        validators: [],
                        hintText: "Enter Your Previous Password",
                        isPassword: true,
                      ),
                    ],
                  ),
                  VSpace(30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText("Enter New Password", 14),
                      VSpace(10),
                      CustomTextField(
                        controller: newPswrdController,
                        validators: [],
                        hintText: "Enter New Password",
                        isPassword: true,
                      ),
                    ],
                  ),
                  VSpace(30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText("Confirm Password", 14),
                      VSpace(10),
                      CustomTextField(
                        controller: confirmPswrdController,
                        validators: [],
                        hintText: "confirm Password",
                        isPassword: true,
                      ),
                    ],
                  ),
                  VSpace(40),
                  PrimaryMaterialButton(context, () {
                    showSuccessAlertDialog(context,
                        "Password Changed Successfully", "Proceed to Sign In");
                  }, "Change Password")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
