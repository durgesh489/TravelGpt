import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travel_gpt/main.dart';
import 'package:travel_gpt/screens/main_screen.dart';
import 'package:travel_gpt/screens/signin_screen.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

import '../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      goOff(context,
          prefs!.getBool("user_login") == true ? MainScreen() : SigninScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      body: Container(
        color: black,
        child: Center(
            child: Image.asset(
          "images/logo.jpg",
          width: 200,
          height: 200,
        )),
      ),
    );
  }
}
