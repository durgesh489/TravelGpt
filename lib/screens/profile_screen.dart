import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_gpt/screens/personal_information_screen.dart';
import 'package:travel_gpt/screens/signin_screen.dart';
import 'package:travel_gpt/screens/vehicles_screen.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

import '../constants/colors.dart';
import '../main.dart';
import 'sign_up_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(prefs!.getString("user_profile"));
  }

  @override
  Widget build(BuildContext context) {
    print(prefs!.getString("user_profile"));
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //     Stack(
                  //       children: [
                  //         ClipRRect(
                  //           borderRadius: BorderRadius.circular(100),
                  //           child: CachedNetworkImage(
                  //             imageUrl: prefs!.getString("profile") ?? "",
                  //             width: 80,
                  //             height: 80,
                  //             fit: BoxFit.cover,
                  //             placeholder: (context, url) {
                  //               return Container(
                  //                 width: 80,
                  //                 height: 80,
                  //                 decoration: BoxDecoration(
                  //                     color: white,
                  //                     borderRadius: BorderRadius.circular(80)),
                  //                 child: Icon(Icons.person, size: 40),
                  //               );
                  //             },
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //     HGap(20),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         BoldText(prefs!.getString("name") ?? "Unknown", 18),
                  //         Text(
                  //           prefs!.getString("email") ?? "unknown@gmail.com",
                  //           overflow: TextOverflow.ellipsis,
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //       ],
                  //     )
                  //   ],
                  // ),
                  // VGap(10),
                  // Divider(),
                  // VGap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldText("Account Settings", 20),
                      VGap(10),
                      DrawerItems(Icons.person_rounded, "Personal Information",
                          () {
                        goTo(context, PersonalInformationScreen());
                      }),
                      DrawerItems(Icons.car_rental, "Vehicles", () {
                        goTo(context, VehiclesScreen());
                      }),
                      DrawerItems(Icons.history, "History", () {}),
                    ],
                  ),
                  VGap(10),
                  Divider(),
                  VGap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldText("Help Support", 20),
                      VGap(10),
                      DrawerItems(Icons.help_outline, "Get Help", () {}),
                      DrawerItems(
                          Icons.feedback_outlined, "Give Us Feedback", () {}),
                      DrawerItems(Icons.query_stats, "Faqs", () {}),
                      DrawerItems(Icons.call, "Contact Us", () {}),
                      DrawerItems(Icons.info_outline, "About Us", () {}),
                    ],
                  ),
                  VGap(10),
                  Divider(),
                  VGap(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoldText("Legal", 20),
                      VGap(10),
                      DrawerItems(
                          Icons.assignment, "Terms and Condition", () {}),
                      DrawerItems(
                          Icons.policy_outlined, "Privacy Policy", () {}),
                      DrawerItems(Icons.logout, "Log Out", () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Are you sure to Logout ?",
                                  style: TextStyle(fontSize: 17),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        goBack(context);
                                      },
                                      child: Text("No")),
                                  TextButton(
                                      onPressed: () async {
                                        prefs!.clear();
                                        await GoogleSignIn().signOut();
                                        await FirebaseAuth.instance.signOut();
                                        goOff(context, SigninScreen());
                                      },
                                      child: Text("Yes")),
                                ],
                              );
                            });
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
