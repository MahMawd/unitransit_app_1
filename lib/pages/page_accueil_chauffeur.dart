import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/bus.dart';

class MainPageChauffeur extends StatefulWidget {
  const MainPageChauffeur({super.key});

  @override
  State<MainPageChauffeur> createState() => _MainPageChauffeurState();
}

class _MainPageChauffeurState extends State<MainPageChauffeur> {
  late String driverId; // Id of the current driver
  List<Voyage> plannedTrips = []; // List to hold planned trips
  List<Bus> availableBus=[];
  late Future<String> driverState;
  @override
  void initState() {
    super.initState();
    // Fetch the driver's ID once the widget initializes
    fetchDriverId();
    driverState = checkIsDriverDrivingBus();
    fetchAvailableBuses();
  }

  Future<void> fetchDriverId() async {
    // Fetch the current user's ID (assuming driver ID is stored in Firebase Auth)
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        driverId = user.uid;
      });
      // Once we have the driver's ID, fetch their planned trips
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
              availableBus = querySnapshot.docs.map((doc){
                return Bus(
                disponible: doc['disponible'],
                driverId: doc['driverId'],
                nom: doc['nom'],
                );
              }).toList();
            });
            print(availableBus);
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
      title: const Text('Main Page'),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Add your widgets here to decorate the space above the list view
        // For example:
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Welcome to the main page!',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
    
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
            return availableBus.isNotEmpty ?
              ListView.separated(
                separatorBuilder:(context,index){return const SizedBox(height: 10,);},
                itemCount: availableBus.length,
                itemBuilder: (context, index) {
                  Bus aBus = availableBus[index];
                  return BusWidget(
                    test:ListTile(
                      title: Text('Bus name: ${aBus.nom}'),
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
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/auth');
              } catch (e) {
                debugPrint('Failed to sign out: $e');
              }
            },
          ),
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
    )
    ]
  ),
  );
  }
}

class Voyage {
  final String departureTime;
  final String arrivalTime;
  final String fromStation;
  final String toStation;

  Voyage({
    required this.departureTime,
    required this.arrivalTime,
    required this.fromStation,
    required this.toStation,
  });
}
class Bus{
  bool disponible;
  String driverId;
  String nom;
  

  Bus({
    required this.disponible,
    required this.driverId,
    required this.nom,
});

}