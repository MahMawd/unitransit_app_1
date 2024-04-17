import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/bus_widget.dart';
import 'package:unitransit_app_1/models/voyage.dart';

import '../models/bus.dart';

class MainPageChauffeur extends StatefulWidget {
  const MainPageChauffeur({super.key});

  @override
  State<MainPageChauffeur> createState() => _MainPageChauffeurState();
}

class _MainPageChauffeurState extends State<MainPageChauffeur> {
  late String driverId;
  List<Voyage> plannedTrips = [];
  List<Bus> availableSectors=[];
  
  late Future<String> driverState;
  @override
  void initState() {
    super.initState();
    
    fetchDriverId();
    driverState = checkIsDriverDrivingBus();
    fetchAvailableBuses();
  }

  Future<void> fetchDriverId() async {
    
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        driverId = user.uid;
      });
      await fetchPlannedTrips();
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
      }else {
        print('driver driving');
        return 'driving';
      }
    }catch(e){
      print('Error checking is driver driving bus: $e');
      return 'error occured';
    }
  }
  Future<void> fetchPlannedTrips() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('voyage')
          .where('driverId', isEqualTo: driverId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          plannedTrips = querySnapshot.docs.map((doc) {
            return Voyage(
              departureTime: doc['departureTime'],
              arrivalTime: doc['arrivaltime'],
              fromStation: doc['fromStation'],
              toStation: doc['ToStation'],
              busId: doc['busId'],
            );
          }).toList();
        });
      } else {
        debugPrint('No planned trips found for the driver.');
      }
    } catch (e) {
      debugPrint('Error fetching planned trips: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Driver Home Page'),
        
        actions: [
        ],
      ),
      body: 
    FutureBuilder<String>(
      future: driverState, 
      builder:(BuildContext context ,AsyncSnapshot<String> snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return Center(child: Text('Error ${snapshot.error}'));
        }
        else {
          String driverStateValue = snapshot.data ?? ''; // Get the value of the Future
          print(driverStateValue);
          if(driverStateValue == 'not_driving'){
            return availableSectors.isNotEmpty ?
              ListView.separated(
                separatorBuilder:(context,index){return const SizedBox(height: 10,);},
                itemCount: availableSectors.length,
                itemBuilder: (context, index) {
                  Bus aSector = availableSectors[index];
                  //fetchTimes(aSector.busId);
                  return BusWidget(
                    //busTimeList: availableBusTimes,
                    busId: aSector.busId,
                    test:ListTile(
                      title: Text('Sector: ${aSector.nom}'),
                      subtitle:const Text("Disponible"),
                      ),
                      );
                  },
              ):
        const Center(child: Text("no buses"),);
          }
          else {
            return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home Page'),
        actions: [
        ],
      ),
      body: plannedTrips.isNotEmpty
          ? ListView.builder(
              itemCount: plannedTrips.length,
              itemBuilder: (BuildContext context, int index) {
                Voyage currentVoyage = plannedTrips[index];
                return ListTile(
                  title: Text('Departure: ${currentVoyage.departureTime}'),
                  subtitle: Text(
                      'From: ${currentVoyage.fromStation} - To: ${currentVoyage.toStation}'),
                );
              },
            )
          : const Center(
              child: Text('No planned trips for the driver.'),
            ),
    );
          }
        }
      },
    ),);
  }
}
