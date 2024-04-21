import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/global/global_var.dart';
import 'package:unitransit_app_1/pages/page_accueil_etudiant.dart'; // Import the page you want to navigate to

class MyMaps extends StatefulWidget {
  final LatLng fromStationLatLng;
  final LatLng toStationLatLng;

  const MyMaps({
    Key? key, // Add 'key' parameter here
    required this.fromStationLatLng,
    required this.toStationLatLng,
  }) : super(key: key); // Add 'key' parameter to the super constructor

  @override
  State<MyMaps> createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  late Position currentPositionOfUser;

  Set<Marker> markers = {}; // Set to hold markers

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
        // Update marker position
        markers = {
          Marker(
            markerId: const MarkerId('Marker 1'),
            icon: BitmapDescriptor.defaultMarker,
            position: positionOfUserInLatLng,
            infoWindow: InfoWindow(title: 'Marker 1'), // Add info window
          ),
          Marker(
            markerId: const MarkerId('Marker 2'),
            icon: BitmapDescriptor.defaultMarker,
            position: widget.toStationLatLng,
            infoWindow: InfoWindow(title: 'Marker 2'), // Add info window
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
            markers: markers, // Pass markers to GoogleMap widget
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              googleMapCompleterController.complete(controllerGoogleMap);
              getCurrentLiveLocationOfUser();
            },
          ),
          Positioned( // Add a positioned widget for overlay button
            top: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()), // Navigate to OtherPage
                );
              },
              child: Text('Go to Other Page'),
            ),
          ),
        ],
      ),
    );
  }
}
