import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPageChauffeur extends StatefulWidget {
  const MainPageChauffeur({super.key});

  @override
  State<MainPageChauffeur> createState() => _MainPageChauffeurState();
}

class _MainPageChauffeurState extends State<MainPageChauffeur> {
  late String driverId; // Id of the current driver
  List<Voyage> plannedTrips = []; // List to hold planned trips

  @override
  void initState() {
    super.initState();
    // Fetch the driver's ID once the widget initializes
    fetchDriverId();
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
