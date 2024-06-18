import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_gpt/widgets/custom_buttons.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../widgets/custom_widgets.dart';

class BookingScreen extends StatefulWidget {
  final String id, vendorId;
  const BookingScreen({super.key, required this.id, required this.vendorId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<Map<String, String>> images = [
    {"image": "", "image_url": ""},
    {"image": "", "image_url": ""},
    {"image": "", "image_url": ""},
  ];
  List<String> issues = [
    "Accidental Issue",
    "Body Isuue",
    "Engine Issue",
    "Electrical Issue",
    "Other Issue"
  ];
  String? selectedIsssue;
  bool isLoading = false;
  TextEditingController issueDescC = new TextEditingController();
  String vendorName = "";
  String vendorPhone = "";
  String vendorEmail = "";
  String vendorToken = "";
  String vendorProfile = "";
  onInit() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("vendors")
        .where("vendor_id", isEqualTo: widget.vendorId)
        .get();
    vendorName = qs.docs[0]["vendor_name"];
    vendorEmail = qs.docs[0]["vendor_email"];
    vendorPhone = qs.docs[0]["vendor_phone"];
    vendorToken = qs.docs[0]["vendor_token"];
    vendorProfile = qs.docs[0]["vendor_profile"];


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
      appBar: AppBar(
        title: Text("Booking Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            BoldText("Issue Images", 16),
            VGap(10),
            GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10),
                itemCount: images.length + 1,
                itemBuilder: ((context, index) {
                  return images.length == index
                      ? IconButton(
                          onPressed: () {
                            images.add({"image": "", "imageUrl": ""});
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            size: 40,
                          ))
                      : InkWell(
                          onTap: () async {
                            images[index]["image"] =
                                await getImageFromGallery();
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
                                      Icons.add_a_photo,
                                      size: 40,
                                    ),
                                  ),
                          ),
                        );
                })),
            VGap(15),
            SizedBox(
              child: DropdownButtonFormField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  value: selectedIsssue,
                  hint: Text("Select Vehicle Issue"),
                  isExpanded: true,
                  items: issues
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    selectedIsssue = val;
                    setState(() {});
                  }),
            ),
            VGap(30),
            TextField(
              controller: issueDescC,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Describe Your Issue"),
              maxLines: 3,
            ),
            VGap(30),
            isLoading
                ? Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : PrimaryMaterialButton(
                    context,
                    "Continue",
                    () async {
                      setState(() {
                        isLoading = true;
                      });
                      print(images);
                      for (var e in images) {
                        if (e["image"] != "") {
                          e["image_url"] = await imageUpload(e["image"] ?? "");
                        }
                      }
                      print(images);

                      await FirebaseFirestore.instance
                          .collection("bookings")
                          .add({
                        "id": widget.id,
                        "user_id": prefs!.getString("user_id"),
                        "user_name": prefs!.getString("user_name"),
                        "user_phone": prefs!.getString("user_phone"),
                        "user_email": prefs!.getString("user_email"),
                        "user_token": prefs!.getString("user_token"),
                        "user_profile": prefs!.getString("user_profile"),
                        "images": images,
                        "vendor_id": widget.vendorId,
                        "vendor_name": vendorName,
                        "vendor_phone": vendorPhone,
                        "vendor_email": vendorEmail,
                        "vendor_token": vendorToken,
                        "vendor_profile": vendorProfile,
                        "issue": selectedIsssue,
                        "issue_desc": issueDescC.text
                      });
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
          ]),
        ),
      ),
    );
  }

  String imageUrl = "";

  Future<String> imageUpload(String img) async {
    var imageName = File(img).path.split('/').last;
    var imageStatus = await FirebaseStorage.instance
        .ref()
        .child('imageFile/$imageName')
        .putFile(File(img));
    imageUrl = await imageStatus.ref.getDownloadURL();

    setState(() {});
    return imageUrl;
  }

  final ImagePicker picker = new ImagePicker();

  Future<String> getImageFromGallery() async {
    String image = "";

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
}
