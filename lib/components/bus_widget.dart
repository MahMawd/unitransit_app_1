// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:unitransit_app_1/pages/page_voyages.dart';

// import '../models/voyage.dart';

// class BusWidget extends StatefulWidget{
//   final ListTile test;
//   final String busId;
//   const BusWidget({
//     required this.test,
//     super.key,
//     required this.busId,
//     });

//   @override
//   State<BusWidget> createState() => _BusWidgetState();
// }

// class _BusWidgetState extends State<BusWidget> {

//   List<Voyage> availableBusTimes=[];


//   // Future<void> fetchStationCoords(String stationFrom, String stationTo) async {
//   //   try {
//   //     QuerySnapshot fromSnapshot = await FirebaseFirestore.instance
//   //         .collection('station')
//   //         .where('nom', isEqualTo: stationFrom)
//   //         .get();
//   //     QuerySnapshot toSnapshot = await FirebaseFirestore.instance
//   //         .collection('station')
//   //         .where('nom', isEqualTo: stationTo)
//   //         .get();

//   //     if (fromSnapshot.docs.isNotEmpty && toSnapshot.docs.isNotEmpty) {
//   //       DocumentSnapshot fromDoc = fromSnapshot.docs.first;
//   //       DocumentSnapshot toDoc = toSnapshot.docs.first;

//   //       LatLng fromLatLng =
//   //           LatLng(fromDoc['lat'] as double, fromDoc['lng'] as double);
//   //       LatLng toLatLng =
//   //           LatLng(toDoc['lat'] as double, toDoc['lng'] as double);

//   //       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//   //           .collection('voyage')
//   //           .where('fromStation', isEqualTo: stationFrom)
//   //           .where('ToStation', isEqualTo: stationTo)
//   //           .get();

//   //       if (querySnapshot.docs.isNotEmpty) {
//   //         setState(() {
//   //           voyage = querySnapshot.docs.map((doc) {
//   //             return Voyage(
//   //               voyageId: doc.id,
//   //               departureTime: doc['departureTime'],
//   //               arrivalTime: doc['arrivaltime'],
//   //               fromStation: doc['fromStation'],
//   //               toStation: doc['ToStation'],
//   //               busId: doc['busId'],
//   //               fromStationLatLng: fromLatLng,
//   //               toStationLatLng: toLatLng,
//   //             );
//   //           }).toList();
//   //         });
//   //       } else {
//   //         setState(() {
//   //           voyage.clear();
//   //         });
//   //         debugPrint('No matching documents.');
//   //       }
//   //     } else {
//   //       debugPrint('One or both stations not found.');
//   //     }
//   //   } catch (e) {
//   //     debugPrint('Error fetching data: $e');
//   //   }
//   // }

//   Future<void> fetchTimes(String busId) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('voyage')
//           .where('busId', isEqualTo: busId)
//           .get();
//           if(querySnapshot.docs.isNotEmpty){
//             setState(() {
//               availableBusTimes = querySnapshot.docs.map((doc){
//                 return Voyage(
//                   voyageId: doc.id,
//               departureTime: doc['departureTime'],
//               arrivalTime: doc['arrivaltime'],
//               fromStation: doc['fromStation'],
//               toStation: doc['ToStation'],
//               busId: doc['busId'],
//               fromStationLatLng: doc['']
//                 );
//               }).toList();
//             });
//             debugPrint('$availableBusTimes');
//           }else{
//             debugPrint('no times available');
//           }
//     }catch(e){
//       debugPrint('Error fetching times: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context){
//     return Container(
//           height: 70,
//           width: 370,
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.grey.shade300,),
//           child:Row(
//             children: [
//               const Padding(
//                 padding:EdgeInsets.only(left:10.0),
//                 child: SizedBox(
//                   width: 53,
//                   height: 50,
                  
//                   child: Icon(size: 50,
//                     Icons.directions_bus,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 7.0,),
//               SizedBox(
//                 width: 220,
//                 child: widget.test),
//               //const SizedBox(width: 180.0,),
//               TextButton(
//                 style: TextButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     textStyle: const TextStyle(color: Colors.red)
//                 ),
//                 onPressed: ()async {
//                   fetchTimes(widget.busId);
//                    await Future.delayed(const Duration(seconds: 1));
//                    Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) =>PageVoyages(voyages: availableBusTimes,)), // Navigate to SignUp page
//             );
//                   // for(Voyage v in availableBusTimes){
//                   //   print('departure: ${v.departureTime} arrival:${v.arrivalTime} from: ${v.fromStation} to: ${v.toStation}');
//                   // }
//                 },
//                 child:const Text("Choose route"),
//                ),

//             ] 
//           )
//         );
//   }
// }