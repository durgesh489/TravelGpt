import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../main.dart';
import '../widgets/custom_widgets.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("bookings")
                .where("user_id", isEqualTo: prefs!.getString("user_id"))
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? snapshot.data!.docs.length == 0
                      ? Center(
                          child: Text("No Services"),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, i) {
                            DocumentSnapshot ds = snapshot.data!.docs[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                color: white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 170,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: ds["images"].length,
                                          itemBuilder: (context, j) {
                                            return Image.network(
                                              ds["images"][j]["image_url"],
                                              width: fullWidth(context),
                                              height: 170,
                                              fit: BoxFit.cover,
                                            );
                                          }),
                                    ),
                                    VGap(10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < ds["images"].length;
                                            i++)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                  color: black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BoldText(ds["issue"], 18),
                                          NormalText(ds["issue_desc"], 14),
                                          VGap(5),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BoldText("Vendor Details", 18),
                                          VGap(5),
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(130),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      ds["vendor_profile"] ??
                                                          "",
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) {
                                                    return Container(
                                                      width: 80,
                                                      height: 80,
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
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Container(
                                                      width: 80,
                                                      height: 80,
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
                                              HGap(10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  NormalText(
                                                      ds["vendor_name"], 14),
                                                  NormalText(
                                                      ds["vendor_email"], 14),
                                                  NormalText(
                                                      ds["vendor_phone"], 14),
                                                ],
                                              )
                                            ],
                                          ),
                                          VGap(5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }
}
