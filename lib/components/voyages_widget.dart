import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/models/voyage.dart';
//import 'package:unitransit_app_1/pages/page_accueil_chauffeur.dart';

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
  //DateTime dateTime = DateTime(year)
  late String driverId;
  Future<void> fetchDriverId() async {
    
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    setState(() {
      driverId = user.uid;
      });
    }
  }
  Future<void> updateBusIdForDriver(String busId) async {
    return FirebaseFirestore.instance.collection('chauffeur').doc(driverId).update({
      'busId':busId,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8.0),
          //   border: Border.all(width: 2.0)
          //   ),
          child: Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.vertical,
            children: [
              Text('Departure:${widget.voyage.departureTime}'),
              Text('\nFrom:${widget.voyage.fromStation}'),
              Text('\nTo:${widget.voyage.toStation}'),
              Text('\nbus Id: ${widget.voyage.busId}'),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    fetchDriverId();
                    updateBusIdForDriver(widget.voyage.busId);
                  }, child: const Text('Start')),
                  ElevatedButton(onPressed: (){}, child: const Text('Runnning late')),
                  ElevatedButton(onPressed: (){}, child: const Text('Malfunction')),
                  ElevatedButton(onPressed: (){
                    updateBusIdForDriver('');
                  }, child: const Text('Arrived')),
                ],
              )
              
            ],),
        )
      ],);
  }
}