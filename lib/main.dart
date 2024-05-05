
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_gpt/authentication/login_screen.dart';
import 'package:travel_gpt/main_screen.dart';
// import 'firebase_options.dart';
import 'constants/colors.dart';
import 'services/auth_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    
  );
  runApp(const MyApp());
}

SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mc,
        primarySwatch: Colors.red,
        backgroundColor: white,
        appBarTheme: AppBarTheme(
          backgroundColor: mc,
          elevation: 0
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
      ),
      home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (context, snapshot) {
            return snapshot.hasData ? MainScreen() : LogInScreen();
          }),
    );
  }
}
