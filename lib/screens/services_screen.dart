import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_gpt/constants/colors.dart';
import 'package:travel_gpt/main.dart';
import 'package:travel_gpt/screens/booking_screen.dart';
import 'package:travel_gpt/widgets/custom_buttons.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

class ServicesScreen extends StatefulWidget {
  final String id, vendorId;
  const ServicesScreen({super.key, required this.id, required this.vendorId});

  @override
  State<ServicesScreen> createState() => _ServicesScreen();
}

class _ServicesScreen extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      appBar: AppBar(
        title: Text("Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("services")
                .doc(widget.id)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              DocumentSnapshot service = snapshot.data;
              return snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        color: white,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: service["images"].length,
                                    itemBuilder: (context, j) {
                                      return Image.network(
                                        service["images"][j]["image_url"],
                                        width: fullWidth(context),
                                        height: 170,
                                        fit: BoxFit.cover,
                                      );
                                    }),
                              ),
                              VGap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0;
                                      i < service["images"].length;
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
                                                BorderRadius.circular(10)),
                                      ),
                                    )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        BoldText(service["shop_name"], 18),
                                        NormalText(
                                            "(" +
                                                service["business_type"] +
                                                ")",
                                            17)
                                      ],
                                    ),
                                    NormalText(
                                        service["address"] +
                                            ", " +
                                            service["city"],
                                        14),
                                    VGap(5),
                                    Divider(),
                                    BoldText("Service that you provide", 16),
                                    VGap(10),
                                    GridView.count(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        for (int k = 0;
                                            k <
                                                service["service_providers"]
                                                    .length;
                                            k++)
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(
                                                    service["service_providers"]
                                                            [k]["logo"] ??
                                                        ""),
                                              ),
                                              VGap(5),
                                              Text(service["service_providers"]
                                                      [k]["name"] ??
                                                  ""),
                                            ],
                                          )
                                      ],
                                    ),
                                    Divider(),
                                    BoldText("Specialist", 16),
                                    VGap(10),
                                    GridView.count(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children: [
                                        for (int k = 0;
                                            k < service["specialist"].length;
                                            k++)
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(
                                                    service["specialist"][k]
                                                            ["logo"] ??
                                                        ""),
                                              ),
                                              VGap(5),
                                              Text(service["specialist"][k]
                                                      ["name"] ??
                                                  ""),
                                            ],
                                          )
                                      ],
                                    ),
                                    VGap(5),
                                    Divider(),
                                    service["pickup_or_drop_service"] == true
                                        ? Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: NormalText(
                                                  "Pick or Drop Service Available",
                                                  13),
                                            ),
                                          )
                                        : SizedBox(),
                                    VGap(5),
                                    service["spare_service"] == true
                                        ? Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: NormalText(
                                                  "Spare Service Available",
                                                  13),
                                            ),
                                          )
                                        : SizedBox(),
                                    VGap(5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        children: [
                                          NormalText("Timing ", 13),
                                          NormalText(
                                              service["opening_time"], 13),
                                          Text(" - "),
                                          NormalText(
                                              service["closing_time"], 13),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
      bottomNavigationBar: PrimaryMaterialButton(
        context,
        "Book",
        () {
          goTo(context, BookingScreen(id: widget.id, vendorId: widget.vendorId));
        },
      ),
    );
  }
}
