import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_gpt/main.dart';

import '../constants/colors.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameC = new TextEditingController();
  TextEditingController phoneC = new TextEditingController();
  TextEditingController emailC = new TextEditingController();
  TextEditingController bgC = new TextEditingController();
  bool isLoading = false;
  onInit() {
    nameC.text = prefs!.getString("user_name") ?? "";
    emailC.text = prefs!.getString("user_email") ?? "";
    phoneC.text = prefs!.getString("user_phone") ?? "";
    bgC.text = prefs!.getString("user_blood_group") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: isLoading
            ? SizedBox(
                width: 40,
                height: 40,
                child: Center(child: CircularProgressIndicator()),
              )
            : PrimaryMaterialButton(context, "Update", () async {
                setState(() {
                  isLoading = true;
                });

                if (formKey.currentState!.validate()) {
                  if (image != null) {
                    await imageUpload();
                  }

                  prefs!.setString("user_name", nameC.text);
                  prefs!.setString("user_phone", phoneC.text);
                  prefs!.setString("user_email", emailC.text);
                  prefs!.setString("user_blood_group", bgC.text);
                  if (image != null) {
                    prefs!.setString("user_profile", imageUrl ?? "");
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(prefs!.getString("user_id"))
                        .update({
                      "user_profile": imageUrl,
                    });
                  }
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(prefs!.getString("user_id"))
                      .update({
                    "user_name": nameC.text,
                    "user_email": emailC.text,
                    "user_phone": phoneC.text,
                    "user_blood_group": bgC.text
                  });
                  goBack(context);
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  showSnackbar(context, "Please Fill all fields correctly");
                }
              }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(130),
                            child: Image.file(
                              File(image!),
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ))
                        : Container(
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
                          ),
                    InkWell(
                      onTap: () async {
                        takeImage();
                      },
                      child: CircleAvatar(
                        backgroundColor: green,
                        radius: 18,
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                VGap(40),
                CustomTextField(
                  controller: nameC,
                  validators: [
                    RequiredValidator(errorText: "This field is required")
                  ],
                  hintText: "Name",
                  title: "Name",
                ),
                CustomTextField(
                  controller: phoneC,
                  validators: [
                    RequiredValidator(errorText: "This field is required"),
                    MinLengthValidator(10,
                        errorText: "Phone Number should be 10 digits"),
                    MaxLengthValidator(10,
                        errorText: "Phone Number should be 10 digits"),
                  ],
                  keyboardType: TextInputType.number,
                  hintText: "Phone Number",
                  title: "Phone Number",
                ),
                CustomTextField(
                  controller: emailC,
                  validators: [
                    RequiredValidator(errorText: "This field is required"),
                    EmailValidator(errorText: "This is not valid Email")
                  ],
                  hintText: "Email",
                  title: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: bgC,
                  validators: [],
                  hintText: "Blood Group",
                  title: "Blood Group",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? imageUrl;
  Future imageUpload() async {
    var imageName = File(image!).path.split('/').last;
    print(imageName);
    if (image == null) return;
    var imageStatus = await FirebaseStorage.instance
        .ref()
        .child('imageFile/$imageName')
        .putFile(File(image!));
    imageUrl = await imageStatus.ref.getDownloadURL();
  }

  String? image;
  bool isImageSelected = false;
  final ImagePicker picker = new ImagePicker();
  PermissionStatus? permissionStatus;
  Future getImageFromGallery() async {
    Navigator.of(context).pop();
    permissionStatus = await Permission.photos.request();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = pickedFile.path;
        isImageSelected = true;
      } else {
        print("no image selected");
      }
    });
  }

  Future captureImageFromCamera() async {
    Navigator.of(context).pop();
    permissionStatus = await Permission.photos.request();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = pickedFile.path;
        isImageSelected = true;
      } else {
        print("no image selected");
      }
    });
  }

  takeImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Select any option",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
                child: Text(
                  "Select Image from Gallery",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                onPressed: () async {
                  getImageFromGallery();
                }),
            SimpleDialogOption(
                child: Text(
                  "Capture Image from Camera",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                onPressed: () async {
                  captureImageFromCamera();
                }),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              onPressed: () {
                goBack(context);
              },
            ),
          ],
        );
      },
    );
  }
}
