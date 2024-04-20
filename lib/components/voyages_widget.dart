import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:unitransit_app_1/global/common/toast.dart';
//import 'package:unitransit/add.alert.dart';
import 'package:unitransit_app_1/models/voyage.dart';
import 'package:unitransit_app_1/pages/main_page_chauff.dart';

class VoyagesWidget extends StatefulWidget {
  const VoyagesWidget({
    super.key,
    required this.voyage
    });
  final Voyage? voyage;

  @override
  State<VoyagesWidget> createState() => _VoyagesWidgetState();
}

class _VoyagesWidgetState extends State<VoyagesWidget> {
  final _firestore = FirebaseFirestore.instance;
  late String driverId;
  void initState(){
    super.initState();
    fetchDriverId();
  }
  Future<void> fetchDriverId() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
      driverId = user.uid;
    }
  }

  Future<void> updateBusIdForDriver(String busId) async {
    return FirebaseFirestore.instance.collection('chauffeur').doc(driverId).update({
      'busId':busId,
    });
  }
  Future<void> updateDriverIdforBus(String id, String busId) async {
    return FirebaseFirestore.instance.collection('bus').doc(busId).update({
      'driverId':id,
    });
  }

  Future<void> updateCurrentVoyageForDriver(String voyageId) async {
    return _firestore.collection('chauffeur').doc(driverId).update({
      'currentVoyage':voyageId
    });
  }
  Future<void> updateVoyagesListForDriver(String voyageId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('chauffeur').doc(driverId).get();
      await Future.delayed(Duration(milliseconds: 500));
      if(documentSnapshot.exists){
        List<dynamic> voyagesList = documentSnapshot['voyages'];
        voyagesList.remove(voyageId);
        await _firestore.collection('chauffeur').doc(driverId).update({'voyages':voyagesList});
      }
    }
    catch(e){
      print("error finishing voyage");
    }
  }
  void updateUI(){
   setState(() {
      //You can also make changes to your state here.
    });
  }

  Future<void> handleStart(String voyId) async {
    try {
      DocumentSnapshot documentSnapshot= await _firestore.collection('chauffeur').
    doc(driverId).get();
    String state =await documentSnapshot['currentVoyage'];
    if(state==voyId){
      throw AlreadyStartedException();
    }
    else {
      updateCurrentVoyageForDriver(widget.voyage!.voyageId);
    }
    }on AlreadyStartedException catch(e){
      showToast(message: e.code);
    }
    catch(e){

    }
  }
  Future<void> handleArrival(String voyId) async {
    try {
      DocumentSnapshot documentSnapshot= await _firestore.collection('chauffeur').
    doc(driverId).get();
    String state =await documentSnapshot['currentVoyage'];
    if(state!=voyId){
      throw NotCurrentBusException();
    }
    else{
      updateCurrentVoyageForDriver('');
      updateVoyagesListForDriver(voyId);
    }
    }on NotCurrentBusException catch(e){
      showToast(message: 'You are not driving this bus');
      print(e.code);
    }
    catch(e){
      print('error fetch currentVoyage $e');
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8.0)

            ),
           padding: const EdgeInsets.all(20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
                children: [
              Text('Departure: ${widget.voyage?.departureTime}'),
              Text('\n From:${widget.voyage?.fromStation}'),
              Text('\n To:${widget.voyage?.toStation}'),
              //Text('\n Voyage id: ${widget.voyage?.voyageId}'),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                style: ButtonStyle(
                foregroundColor: getColor(Colors.black, Colors.white),
                backgroundColor: getColor(Colors.green, Colors.white),
                side: getBorder(Colors.blue, Colors.green)),
                child:const Text('Start'),
                onPressed: (){
                  fetchDriverId();
                  handleStart(widget.voyage!.voyageId);
                    //updateBusIdForDriver(widget.voyage!.busId);
                    //updateDriverIdforBus(driverId,widget.voyage!.busId);
                    //Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePageChauffeur()),);
                },),
              const SizedBox(width:25.0),
                  ElevatedButton(
                style: ButtonStyle(
                foregroundColor: getColor(Colors.black, Colors.white),
                backgroundColor: getColor(Colors.white, Colors.blue),
                side: getBorder(Colors.blue, Colors.blue)),
                child:const Text('Arrived'),
                onPressed: (){
                  handleArrival(widget.voyage!.voyageId);
                  
                
                  // updateBusIdForDriver('');
                  //   updateDriverIdforBus('',widget.voyage!.busId);
                //Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePageChauffeur()),);
                },),
              const SizedBox(width:40.0),
                ElevatedButton(
                style: ButtonStyle(
                foregroundColor: getColor(Colors.white, Colors.black),
                backgroundColor: getColor(Colors.red, Colors.white),
                side: getBorder(Colors.blue, Colors.red)),
                child:const Text('Alert '),
                onPressed: (){}//()=> Get.to(() =>  const AddAlert()),
                
                )
                ],
              ), 
                ],
            ),
        ),
      ],
      );
  }

  MaterialStateProperty<Color> getColor (Color color, Color colorPressed){
    getColor(Set<MaterialState> states){
      if(states.contains(MaterialState.pressed)){
        return colorPressed;
      }else{
        return color;
      }
    }
    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder (Color color, Color colorPressed){
    getBorder(Set<MaterialState> states){
      if (states.contains(MaterialState.pressed)){
        return BorderSide(color: colorPressed, width: 2);
      }else{
        return BorderSide(color: color, width: 2);
      }
    }
     return MaterialStateProperty.resolveWith(getBorder);
    }
}
class NotCurrentBusException implements Exception{
  String code ="You have not started this voyage";
}
class AlreadyStartedException implements Exception{
  String code = "You have already started this voyage";
}