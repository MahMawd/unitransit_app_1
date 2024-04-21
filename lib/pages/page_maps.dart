import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/global/global_var.dart';
import 'package:unitransit_app_1/pages/page_accueil_etudiant.dart';

class MyMaps extends StatefulWidget {
  final LatLng fromStationLatLng;
  final LatLng toStationLatLng;

  const MyMaps({
    Key? key,
    required this.fromStationLatLng,
    required this.toStationLatLng,
  }) : super(key: key);

  @override
  State<MyMaps> createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  late Position currentPositionOfUser;

  Set<Marker> markers = {};

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/dark_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list =
        byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  void getCurrentLiveLocationOfUser() async {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentPositionOfUser = position;
        LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser.latitude, currentPositionOfUser.longitude);

        markers = {
          Marker(
            markerId: const MarkerId('Marker 1'),
            icon: BitmapDescriptor.defaultMarker,
            position: positionOfUserInLatLng,
            infoWindow: InfoWindow(title: 'Marker 1'),
          ),
          Marker(
            markerId: const MarkerId('Marker 2'),
            icon: BitmapDescriptor.defaultMarker,
            position: widget.toStationLatLng,
            infoWindow: InfoWindow(title: 'Marker 2'),
          ),
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            markers: markers,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              googleMapCompleterController.complete(controllerGoogleMap);
              getCurrentLiveLocationOfUser();
            },
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Go to Other Page'),
            ),
          ),
        ],
      ),
    );
  }
}
