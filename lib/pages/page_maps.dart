import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/global/global_var.dart';

class MyMaps extends StatefulWidget {
  final LatLng fromStationLatLng;
  final LatLng toStationLatLng;

  const MyMaps({
    super.key,
    required this.fromStationLatLng,
    required this.toStationLatLng,
  });

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
        //CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 15);
        //controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        // Update marker position
        markers = {
          ...markers,
          Marker(
            markerId: const MarkerId('currentPosition'),
            icon: BitmapDescriptor.defaultMarker,
            position: positionOfUserInLatLng,
          ),
          Marker(
            markerId: const MarkerId('fromStation'),
            icon: BitmapDescriptor.defaultMarker,
            position: widget.fromStationLatLng,
          ),
          Marker(
            markerId: const MarkerId('toStation'),
            icon: BitmapDescriptor.defaultMarker,
            position: widget.toStationLatLng,
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
        ],
      ),
    );
  }
}
