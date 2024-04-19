import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
//import 'package:unitransit/add.alert.dart';
import 'package:unitransit_app_1/models/voyage.dart';
import 'package:unitransit_app_1/pages/main_page_chauff.dart';

class VoyagesWidget extends StatefulWidget {
  const VoyagesWidget({
    super.key,
    required this.voyage
    });
  final Voyage voyage;

  @override
  State<VoyagesWidget> createState() => _VoyagesWidgetState();
}

class _VoyagesWidgetState extends State<VoyagesWidget> {

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Container(
           padding: const EdgeInsets.all(20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
                children: [
              Text('Departure: ${widget.voyage.departureTime}'),
              Text('\n From:${widget.voyage.fromStation}'),
              Text('\n To:${widget.voyage.toStation}'),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                style: ButtonStyle(
                foregroundColor: getColor(Colors.black, Colors.white),
                backgroundColor: getColor(Colors.white, Colors.green),
                side: getBorder(Colors.blue, Colors.green)),
                child:const Text('Start'),
                onPressed: (){
                  fetchDriverId();
                    updateBusIdForDriver(widget.voyage.busId);
                    updateDriverIdforBus(driverId,widget.voyage.busId);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePageChauffeur()),);
                },),
              const SizedBox(width:25.0),
                  ElevatedButton(
                style: ButtonStyle(
                foregroundColor: getColor(Colors.black, Colors.white),
                backgroundColor: getColor(Colors.white, Colors.blue),
                side: getBorder(Colors.blue, Colors.blue)),
                child:const Text('Arrived'),
                onPressed: (){
                  updateBusIdForDriver('');
                    updateDriverIdforBus('',widget.voyage.busId);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const HomePageChauffeur()),);
                },),
              const SizedBox(width:40.0),
                ElevatedButton(
                style: ButtonStyle(
                foregroundColor: getColor(Colors.black, Colors.white),
                backgroundColor: getColor(Colors.white, Colors.red),
                side: getBorder(Colors.blue, Colors.red)),
                child:const Text('alert '),
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