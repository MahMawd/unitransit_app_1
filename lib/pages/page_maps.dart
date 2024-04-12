import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/global/global_var.dart';

class MyMaps extends StatefulWidget{
  const MyMaps({super.key});

  @override
  State<MyMaps> createState() => _MyMapsState();
}

class _MyMapsState extends State<MyMaps> {
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;

  late Position currentPositionOfUser;

  void updateMapTheme (GoogleMapController controller){
    getJsonFileFromThemes ("themes/dark_style.json").then((value) => setGoogleMapStyle (value, controller));}

  Future<String> getJsonFileFromThemes (String mapStylePath) async{
    ByteData byteData = await rootBundle.load (mapStylePath);
    var list = byteData.buffer.asUint8List (byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);}

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller)
  {
    controller.setMapStyle (googleMapStyle);
  }

  getCurrentLiveLocationOfUSer()async{
    Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser=positionOfUser;
    LatLng positionOfUserInLatLng = LatLng(currentPositionOfUser.latitude,currentPositionOfUser.longitude);
    CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng , zoom: 15);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  @override 
  Widget build(BuildContext context){
    return  Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController){
              controllerGoogleMap=mapController;
              //updateMapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);   
              getCurrentLiveLocationOfUSer();       
            },
          )
        ],
      )
    );
  }
}