import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_gpt/main.dart';

import '../constants/colors.dart';
import '../widgets/custom_buttons.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_widgets.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicleScreen> {
  bool isLoading = false;
  TextEditingController vehicleNameC = new TextEditingController();
  TextEditingController vehicleModelC = new TextEditingController();
  TextEditingController vehicleNumberC = new TextEditingController();
  TextEditingController vehicleColorC = new TextEditingController();
  List<String> colors = [
    "Black",
    "White",
    "Red",
    "Yellow",
    "Green",
    "Blue",
    "Purple"
  ];
  String? selectedColor;
  List<Map<String, String>> images = [
    {"image": "", "image_url": ""},
    {"image": "", "image_url": ""},
    {"image": "", "image_url": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Vehicles"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 10),
                  itemCount: images.length,
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            images[index]["image"] =
                                (await getImageFromGallery())!;
                            images[index]["image_url"] =
                                await imageUpload(images[index]["image"]);
                            setState(() {});
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: grey2,
                            ),
                            child: images[index]["image"] != ""
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(images[index]["image"] ?? ""),
                                      fit: BoxFit.cover,
                                    ))
                                : Center(
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 40,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  })),
              kPrimaryOutlineButton(context, "Add More", () {
                images.add({"image": "", "imageUrl": ""});
                setState(() {});
              }),
              VGap(20),
              CustomTextField(
                controller: vehicleNameC,
                validators: [
                  RequiredValidator(errorText: "This field is required")
                ],
                hintText: "Vehicle Name",
                title: "Vehicle Name",
              ),
              CustomTextField(
                controller: vehicleModelC,
                validators: [
                  RequiredValidator(errorText: "This field is required")
                ],
                hintText: "Vehicle Model",
                title: "Vehicle Model",
              ),
              CustomTextField(
                controller: vehicleNumberC,
                validators: [
                  RequiredValidator(errorText: "This field is required")
                ],
                hintText: "Vehicle Number",
                title: "Vehicle Number",
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(border: UnderlineInputBorder()),
                  value: selectedColor,
                  hint: Text("Vehicle Color"),
                  isExpanded: true,
                  items: colors
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    selectedColor = val;
                    setState(() {});
                  }),
              VGap(10),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: isLoading
            ? SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : PrimaryMaterialButton(
                context,
                "Add",
                () async {
                  setState(() {
                    isLoading = true;
                  });

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(prefs!.getString("user_id"))
                      .collection("vehicles")
                      .add({
                    "images": images,
                    "name": vehicleNameC.text,
                    "model": vehicleModelC.text,
                    "number": vehicleNumberC.text,
                    "color": selectedColor,
                  });
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
              ),
      ),
    );
  }

  String? imageUrl;
  bool imageLoader = false;
  Future imageUpload(String? img) async {
    if (img != null) {
      imageLoader = true;
    }

    var imageName = File(img!).path.split('/').last;
    print(imageName);
    if (img == null) return;
    var imageStatus = await FirebaseStorage.instance
        .ref()
        .child('imageFile/$imageName')
        .putFile(File(img));
    imageUrl = await imageStatus.ref.getDownloadURL();
    imageLoader = false;
    setState(() {});
    return imageUrl;
  }

  String? image;

  final ImagePicker picker = new ImagePicker();

  Future<String?> getImageFromGallery() async {
    String? image;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = pickedFile.path;
      } else {
        print("no image selected");
      }
    });
    return image;
  }

  Future captureImageFromCamera() async {
    Navigator.of(context).pop();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = pickedFile.path;
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
