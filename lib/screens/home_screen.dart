import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_gpt/screens/services_screen.dart';
import 'package:travel_gpt/widgets/custom_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;

  void _getCurrentLocation() async {
    await Permission.location.request();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void getKitchens() async {
    await FirebaseFirestore.instance
        .collection("services")
        .get()
        .then((snapshot) => {
              for (DocumentSnapshot ds in snapshot.docs)
                {
                  _markers.add(
                    Marker(
                        onTap: () {
                          print(ds["vendor_id"]);
                          goTo(
                              context,
                              ServicesScreen(
                                id: ds.id,
                                vendorId:ds["vendor_id"],
                              ));
                        },
                        infoWindow: InfoWindow(title: ds["shop_name"]),
                        markerId: MarkerId(ds.id),
                        position: LatLng(ds["lat"], ds["long"])),
                  ),
                }
            });

    print(_markers);
    setState(() {});
  }

  // Define your markers
  Set<Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCurrentLocation();
    getKitchens();

    print(_markers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _markers == {} || _markers.length == 0
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                getKitchens();
                _controller.complete(controller);
              },
              onTap: (ll) {
                print(ll);
              },
            ),
    );
  }
}
