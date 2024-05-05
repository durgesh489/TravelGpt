import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_gpt/constants/colors.dart';
import 'package:travel_gpt/screens/details_screesn.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey2,
        appBar: AppBar(
          title: Text("Travel GPT"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("places").snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];

                        return InkWell(
                          onTap: () {
                            goto(context, DetailsScreen(id: ds.id));
                          },
                          child: Card(
                            color: white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    child: Image.network(ds["image"]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  VSpace(5),
                                  boldText(ds["title"], 17),
                                  VSpace(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      normalText(ds["start_point"], 15),
                                      normalText("--->", 15),
                                      normalText(ds["end_point"], 15),
                                    ],
                                  ),
                                  VSpace(10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      normalText(
                                          "Duration: " +
                                              ds["duration"].toString() +
                                              " days",
                                          16),
                                      PrimaryOutlineButton((){}, "Play Video", 140)
                                    ],
                                  ),
                                  VSpace(10),
                                  

                                  boldText("Highlights", 15),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: ds["highlights"].length,
                                      itemBuilder: (context, j) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            normalText(
                                                (j + 1).toString() +
                                                    ". " +
                                                    ds["highlights"][j],
                                                15),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ));
  }
}
