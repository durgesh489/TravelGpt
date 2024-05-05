import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:travel_gpt/constants/colors.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

class DetailsScreen extends StatefulWidget {
  final String id;
  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: grey2,
        appBar: AppBar(
          title: Text("Details"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryMaterialButton(context, (){}, "Chat with us"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("places")
                .where("id", isEqualTo: widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data!.docs[index];

                        return InkWell(
                          onTap: () {},
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
                                  VSpace(5),
                                  normalText(
                                      "Duration: " +
                                          ds["duration"].toString() +
                                          " days",
                                      16),
                                  VSpace(10),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: ds["details"].length,
                                      itemBuilder: (context, i) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            boldText(
                                                "Day " +
                                                    (i + 1).toString() +
                                                    " " +
                                                    ds["details"][i]["title"],
                                                17),
                                            ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: ds["details"][i]
                                                        ["activities"]
                                                    .length,
                                                itemBuilder: (context, j) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      normalText(
                                                          (j + 1).toString() +
                                                              ". " +
                                                              ds["details"][i][
                                                                  "activities"][j],
                                                          16),
                                                    ],
                                                  );
                                                }),
                                            Divider()
                                          ],
                                        );
                                      }),
                                  boldText("Additional Notes", 15),
                                  ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: ds["additional_notes"].length,
                                      itemBuilder: (context, j) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            normalText(
                                                (j + 1).toString() +
                                                    ". " +
                                                    ds["additional_notes"][j],
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
