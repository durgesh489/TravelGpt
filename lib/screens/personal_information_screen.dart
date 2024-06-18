import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_gpt/screens/edit_profile_screen.dart';
import 'package:travel_gpt/widgets/custom_buttons.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../widgets/custom_widgets.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Personal Information",
          style: TextStyle(color: black),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: PrimaryMaterialButton(context, "Edit Profile", () {
          goTo(context, EditProfileScreen());
        }),
      ),
      body: StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(prefs!.getString("user_id"))
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            var ds = snapshot.data;
            return snapshot.hasData
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          VGap(20),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(130),
                            child: CachedNetworkImage(
                              imageUrl: ds["user_profile"] ?? "",
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                                );
                              },
                            ),
                          ),
                          VGap(40),
                          Item(
                            "Name",
                            ds["user_name"] ?? "Unknown",
                          ),
                          Item(
                            "Email",
                            ds["user_email"] ?? "unknown@gmail.com",
                          ),
                          Item(
                            "Phone Number",
                            ds["user_phone"] ?? "No Phone Number",
                          ),
                          Item(
                            "Blood Group",
                            ds["user_blood_group"] ?? "No Blood Group",
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  
  Widget Item(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoldText(title, 16),
        VGap(10),
        Container(
          width: fullWidth(context),
          decoration: BoxDecoration(
            color: white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: NormalText(value, 17),
          ),
        ),
        VGap(20)
      ],
    );
  }

  
}
