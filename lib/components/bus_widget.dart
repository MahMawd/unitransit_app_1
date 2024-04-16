import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/voyage.dart';

class BusWidget extends StatefulWidget{
  final ListTile test;
  final String busId;
  const BusWidget({
    required this.test,
    super.key,
    required this.busId,
    });

  @override
  State<BusWidget> createState() => _BusWidgetState();
}

class _BusWidgetState extends State<BusWidget> {

  List<Voyage> availableBusTimes=[];
  Future<void> fetchTimes(String busId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('voyage')
          .where('busId', isEqualTo: busId)
          .get();
          if(querySnapshot.docs.isNotEmpty){
            setState(() {
              availableBusTimes = querySnapshot.docs.map((doc){
                return Voyage(
              departureTime: doc['departureTime'],
              arrivalTime: doc['arrivaltime'],
              fromStation: doc['fromStation'],
              toStation: doc['ToStation'],
                );
              }).toList();
            });
            debugPrint('$availableBusTimes');
          }else{
            debugPrint('no times available');
          }
    }catch(e){
      debugPrint('Error fetching times: $e');
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
          height: 70,
          width: 370,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.grey.shade300,),
          child:Row(
            children: [
              const Padding(
                padding:EdgeInsets.only(left:10.0),
                child: SizedBox(
                  width: 53,
                  height: 50,
                  
                  child: Icon(size: 50,
                    Icons.directions_bus,
                  ),
                ),
              ),
              const SizedBox(width: 7.0,),
              SizedBox(
                width: 240,
                child: widget.test),
              //const SizedBox(width: 180.0,),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(color: Colors.red)
                ),
                onPressed: ()async {
                  fetchTimes(widget.busId);
                   await Future.delayed(Duration(seconds: 1));
                  for(Voyage v in availableBusTimes){
                    print('departure: ${v.departureTime} from: ${v.fromStation} to: ${v.toStation}');
                  }
                },
                child:const Text("Embark"),
               ),

            ] 
          )
        );
  }
}