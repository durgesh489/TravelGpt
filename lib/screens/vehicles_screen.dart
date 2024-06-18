import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_gpt/constants/colors.dart';
import 'package:travel_gpt/main.dart';
import 'package:travel_gpt/screens/add_vehicle_screen.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey2,
      appBar: AppBar(
        title: Text("Vehicles"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goTo(context, AddVehicleScreen());
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(prefs!.getString("user_id"))
                .collection("vehicles")
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? snapshot.data!.docs.length == 0
                      ? Center(
                          child: Text("No Vehicles"),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, i) {
                            DocumentSnapshot vehicle = snapshot.data!.docs[i];
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
                                        itemCount: vehicle["images"].length,
                                        itemBuilder: (context, j) {
                                        return Image.network(
                                          vehicle["images"][j]["image_url"],
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
                                        for(int i=0;i<vehicle["images"].length;i++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          child: Container(
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BoldText(vehicle["name"], 18),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all()),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Text(vehicle
                                                        ["number"]),
                                                  )),
                                            ],
                                          ),
                                          Text(vehicle["model"] +
                                              " " +
                                              vehicle["color"] +
                                              " Color"),
                                        ],
                                      ),
                                    ),
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
