import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/components/bus_widget.dart';
import 'package:unitransit_app_1/components/voyages_widget.dart';
import 'package:unitransit_app_1/models/voyage.dart';
import 'package:unitransit_app_1/pages/page_voyages.dart';

import '../models/bus.dart';

class MainPageChauffeur extends StatefulWidget {
  const MainPageChauffeur({super.key});

  @override
  State<MainPageChauffeur> createState() => _MainPageChauffeurState();
}


class _MainPageChauffeurState extends State<MainPageChauffeur> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String driverId;
  late String currentBusId;
  List<Voyage> plannedTrips = [];
  List<Bus> availableSectors=[];
 

  Voyage? voy;
  late List<String> plannedVoyagesDocs;
  //late String driverStateV;
  late Future<String> driverState;
  @override
  void initState() {
    super.initState();
    fetchDriverId();
    fetchPlannedVoyagesFromChauffeur();
    //driverState = checkIsDriverDrivingBus();
    //handleDriverState();
    //fetchAvailableBuses();
  }
  
  Future<void> fetchDriverId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      driverId = user.uid;
      //await fetchPlannedTrips();
    }
  }
  Future<void> fetchDriversBusId() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('chauffeur').doc(driverId).get();

      if(documentSnapshot.exists){

          currentBusId=documentSnapshot['busId'];

      }
    }catch(e){
      print('error occured fetching drivers current bus id $e');
    }
  }

  Future<void> handleDriverState() async {
    String driverStateV = await driverState;
    if(driverStateV=='driving'){
      await fetchDriversBusId();
      fetchPlannedTrips(currentBusId);
    }
  }

  Future<void> fetchAvailableBuses() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bus')
          .where('disponible', isEqualTo: true)
          .where('driverId', isEqualTo: '')
          .get();
          if(querySnapshot.docs.isNotEmpty){
            setState(() {
              availableSectors = querySnapshot.docs.map((doc){
                return Bus(
                busId: doc.id,
                disponible: doc['disponible'],
                driverId: doc['driverId'],
                nom: doc['nom'],
                );
              }).toList();
            });
            print('Sectors:');
            print(availableSectors);
          }else{
            debugPrint('no buses available');
          }
    }catch(e){
      debugPrint('Error fetching available buses: $e');
    }
  }
  Future<String> checkIsDriverDrivingBus() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('chauffeur')
      .doc(driverId)
      .get();
      if(documentSnapshot.exists && documentSnapshot['busId']==''){
        print('driver not driving');
        return 'not_driving';
      }else if(documentSnapshot.exists && documentSnapshot['busId']!=''){
        print('driver driving');
        return 'driving';
      }
      else {
        print('unknown error in checkIsDriverDrivingBus');
        return 'unkown error';
      }
    }catch(e){
      print('Error checking is driver driving bus: $e');
      return 'error occured';
    }
  }
  Future<LatLngPair> fetchStationCoords(String stationFrom, String stationTo) async {
    try {
      QuerySnapshot fromSnapshot = await FirebaseFirestore.instance
          .collection('station')
          .where('nom', isEqualTo: stationFrom)
          .get();
      QuerySnapshot toSnapshot = await FirebaseFirestore.instance
          .collection('station')
          .where('nom', isEqualTo: stationTo)
          .get();

      LatLng fromLatLng = LatLng(0.0, 0.0);
      LatLng toLatLng = LatLng(0.0, 0.0);

      if (fromSnapshot.docs.isNotEmpty && toSnapshot.docs.isNotEmpty) {
        DocumentSnapshot fromDoc = fromSnapshot.docs.first;
        DocumentSnapshot toDoc = toSnapshot.docs.first;

        fromLatLng = LatLng(fromDoc['lat'] as double, fromDoc['lng'] as double);
        toLatLng = LatLng(toDoc['lat'] as double, toDoc['lng'] as double);
      }

      return LatLngPair(fromLatLng, toLatLng);
    } catch (e) {
        debugPrint('Error fetching station coordinates: $e');
        return LatLngPair(LatLng(0.0, 0.0), LatLng(0.0, 0.0));
      }
    }
  Future<void> fetchPlannedTrips(String driverBusId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('voyage')
        .where('busId', isEqualTo: driverBusId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        LatLngPair stationCoords = await fetchStationCoords(doc['fromStation'], doc['ToStation']);
        plannedTrips.add(Voyage(
          voyageId: doc.id,
          departureTime: doc['departureTime'],
          arrivalTime: doc['arrivaltime'],
          fromStation: doc['fromStation'],
          toStation: doc['ToStation'],
          busId: doc['busId'],
          fromStationLatLng: stationCoords.first,
          toStationLatLng: stationCoords.second,
        ));
      }
      setState(() {});
    } else {
      debugPrint('No planned trips found for the driver.');
    }
  } catch (e) {
    debugPrint('Error fetching planned trips: $e');
  }
}
  bool isLoading = true;

  Future<void> fetchPlannedVoyagesFromChauffeur() async {
    try{
      DocumentSnapshot documentSnapshot = await _firestore.collection('chauffeur').doc(driverId).get();
      await Future.delayed(const Duration(milliseconds: 500));
      if(documentSnapshot.exists){
        print("slm");
        List<dynamic> firestoreArray = documentSnapshot['voyages'];
        
        setState(() {
          plannedVoyagesDocs=firestoreArray.map((element) => element.toString()).toList();
          isLoading = false;
        });
        print(plannedVoyagesDocs);
      }
      else{
        setState(() {
          plannedVoyagesDocs=[];
          isLoading = false;
        });
        print('document not found');
      }
    }
    catch(e){
      print("error occured in fetchDriverBusList $e");
    }
  }
  

  Future<Voyage?> fetchVoyage(String docId,) async {
    print('ahla');
  try {
    DocumentSnapshot documentSnapshot = await _firestore.collection('voyage').doc(docId).get();
    if (documentSnapshot.exists) {
      print(documentSnapshot['fromStation']);
      LatLngPair coords=await fetchStationCoords(documentSnapshot['fromStation'], documentSnapshot['ToStation']);
      return Voyage(
        voyageId: docId,
        departureTime: documentSnapshot['departureTime'],
        arrivalTime: documentSnapshot['arrivaltime'],
        fromStation: documentSnapshot['fromStation'],
        toStation: documentSnapshot['ToStation'],
        busId: documentSnapshot['busId'],
        fromStationLatLng: coords.first,
        toStationLatLng: coords.second,
      );
    } else {
      return null;
    }
  } catch (e) {
    print('error in fetchVoyage $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   //leading: IconButton(onPressed: ()=> Get.to(() =>  VoyagesWidget()), icon: const Icon(Icons.arrow_back,color: Colors.white,)),
      //   title: Text("Driver Home Page",
      //   style: Theme.of(context).textTheme.headlineMedium ),
      //   actions: [
          
      //   ],
      // ),
      body:
            SafeArea(
              child: Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Home Page Driver",
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
                          ),
                          ),
                          Text('Welcome ',
                          style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  !isLoading ?
                  plannedVoyagesDocs.isNotEmpty ?
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10,);
                      },
                      itemCount: plannedVoyagesDocs.length,
                      itemBuilder:(context, index){
                        String voyageId = plannedVoyagesDocs[index];
                        print(voyageId);
                        //LatLng fromS=new LatLng(0.0, 0.0);LatLng toS=new LatLng(0.0, 0.0);
                        print("9bal future builder");
                        return 
                        FutureBuilder(
                          future: fetchVoyage(voyageId), 
                          builder:(BuildContext context, AsyncSnapshot<Voyage?> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData || snapshot.data == null) {
                              return Container();
                            } else {
                              return VoyagesWidget(voyage: snapshot.data!);
                            }
                          },);
                      },
                      
                      ),
                  )
                    : const SizedBox(height:500, child: Center(child: Text("No planned trips contact administration")))
                     : const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
              


  
    );
  }
}
class LatLngPair {
  final LatLng first;
  final LatLng second;

  LatLngPair(this.first, this.second);
}