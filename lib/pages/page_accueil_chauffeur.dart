import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/components/voyages_widget.dart';
import 'package:unitransit_app_1/models/voyage.dart';

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
  late Future<String> driverState;
  @override
  void initState() {
    super.initState();
    fetchDriverId();
    fetchPlannedVoyagesFromChauffeur();
  }
  
  Future<void> fetchDriverId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      driverId = user.uid;
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

      LatLng fromLatLng = const LatLng(0.0, 0.0);
      LatLng toLatLng = const LatLng(0.0, 0.0);

      if (fromSnapshot.docs.isNotEmpty && toSnapshot.docs.isNotEmpty) {
        DocumentSnapshot fromDoc = fromSnapshot.docs.first;
        DocumentSnapshot toDoc = toSnapshot.docs.first;

        fromLatLng = LatLng(fromDoc['lat'] as double, fromDoc['lng'] as double);
        toLatLng = LatLng(toDoc['lat'] as double, toDoc['lng'] as double);
      }

      return LatLngPair(fromLatLng, toLatLng);
    } catch (e) {
        debugPrint('Error fetching station coordinates: $e');
        return LatLngPair(const LatLng(0.0, 0.0), const LatLng(0.0, 0.0));
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
                          Text("Page d'accueil chauffeur",
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
                          ),
                          ),
                          Text('Bienvenue ',
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
                    : const SizedBox(height:500, child: Center(child: Text("Pas de voyages prévus, veuillez contacter l'administration.")))
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