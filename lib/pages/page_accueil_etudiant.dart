import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unitransit_app_1/models/voyage.dart';
import 'package:unitransit_app_1/pages/page_maps.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String etudiantId;
  List<String> stations = [
    'Campus Manar',
    'El Menzah',
    'Station 3',
    'Station 4'
  ];
  List<String> stationName = [];

  String selectedStationFrom = '0';
  String selectedStationTo = '0';
  final TextEditingController searchController = TextEditingController();
  List<Voyage> voyage = [];
  @override
  void initState() {
    super.initState();
    fetchStationNames();
  }
  bool loading=false;
  void _toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }
  Future<void> fetchEtudiantId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      etudiantId = user.uid;
      //await fetchPlannedTrips();
    }
  }

  Future<bool> checkEtudiantSubs(String voyage) async {
    fetchEtudiantId();
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('etudiant').doc(etudiantId).get();
      List<dynamic> firestoreArray = documentSnapshot['voyages'];
      print(firestoreArray);
      if(firestoreArray.contains(voyage)){
        return true;
      }else{
        return false;
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      //greeting row
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recherche de bus',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Choisissez votre emplacement !',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.location_on, color: Colors.black),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("De"),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 220,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('station')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    List<DropdownMenuItem> stationItems = [];
                                    if (!snapshot.hasData) {
                                      const CircularProgressIndicator();
                                    } else {
                                      final stations =
                                          snapshot.data?.docs.reversed.toList();
                                      stationItems.add(const DropdownMenuItem(
                                          value: '0',
                                          child: Text('Selectionner Station')));
                                      for (var s in stations!) {
                                        stationItems.add(
                                          DropdownMenuItem(
                                            value: s.data()['nom'],
                                            child: Text(s['nom']),
                                          ),
                                        );
                                      }
                                    }
                                    return DropdownButton(
                                      items: stationItems,
                                      onChanged: (sValue) {
                                        setState(() {
                                          selectedStationFrom = sValue;
                                        });
                                      },
                                      value: selectedStationFrom,
                                      isExpanded: false,
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.location_on, color: Colors.black),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("À"),
                            const SizedBox(
                              width: 18,
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('station')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  List<DropdownMenuItem> stationItems = [];
                                  if (!snapshot.hasData) {
                                    const CircularProgressIndicator();
                                  } else {
                                    final stations =
                                        snapshot.data?.docs.reversed.toList();
                                    stationItems.add(const DropdownMenuItem(
                                        value: '0',
                                        child: Text('Selectionner Station')));
                                    for (var s in stations!) {
                                      stationItems.add(
                                        DropdownMenuItem(
                                          value: s.data()['nom'],
                                          child: Text(s['nom']),
                                        ),
                                      );
                                    }
                                  }
                                  return DropdownButton(
                                    items: stationItems,
                                    onChanged: (sValue) {

                                      setState(() {
                                        selectedStationTo = sValue;
                                      });
                                    },
                                    value: selectedStationTo,
                                    isExpanded: false,
                                  );
                                })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 40,
                            ),
                            SizedBox(
                              height: 50,
                              width: 270,
                              child: ElevatedButton(
                                onPressed: ()async {
                                  _toggleLoading();
                                  await fetchData(
                                      selectedStationFrom, selectedStationTo);
                                      _toggleLoading();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child:loading ? CircularProgressIndicator() : Text("Rechercher"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.all(25),
                  color: Colors.grey[100],
                  child: Center(
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Voyages',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                        const SizedBox(height: 20),
                        voyage.isNotEmpty
                            ? ListView.separated(
                                shrinkWrap: true,
                                itemCount: voyage.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  Voyage currentVoyage = voyage[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Navigate to maps page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyMaps(
                                            fromStationLatLng:
                                                currentVoyage.fromStationLatLng,
                                            toStationLatLng:
                                                currentVoyage.toStationLatLng,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ListTile(
                                        leading: const Icon(Icons.timer),
                                        title: Text(
                                            'Departure: ${currentVoyage.departureTime}'),
                                        subtitle: Text(
                                            'From: ${currentVoyage.fromStation} - To: ${currentVoyage.toStation} \nArrival: ${currentVoyage.arrivalTime}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () async {
                                            bool check = await checkEtudiantSubs(currentVoyage.voyageId);
                                            if(!check){
                                              addTripToNotifications(currentVoyage);
                                            }else {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vous suivez déjà ce voyage')),);
                                            }
                                            
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Text("Pas de données"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> fetchData(String stationFrom, String stationTo) async {
    try {
      QuerySnapshot fromSnapshot = await FirebaseFirestore.instance
          .collection('station')
          .where('nom', isEqualTo: stationFrom)
          .get();
      QuerySnapshot toSnapshot = await FirebaseFirestore.instance
          .collection('station')
          .where('nom', isEqualTo: stationTo)
          .get();

      if (fromSnapshot.docs.isNotEmpty && toSnapshot.docs.isNotEmpty) {
        DocumentSnapshot fromDoc = fromSnapshot.docs.first;
        DocumentSnapshot toDoc = toSnapshot.docs.first;

        LatLng fromLatLng =
            LatLng(fromDoc['lat'] as double, fromDoc['lng'] as double);
        LatLng toLatLng =
            LatLng(toDoc['lat'] as double, toDoc['lng'] as double);

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('voyage')
            .where('fromStation', isEqualTo: stationFrom)
            .where('ToStation', isEqualTo: stationTo)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            voyage = querySnapshot.docs.map((doc) {
              return Voyage(
                voyageId: doc.id,
                departureTime: doc['departureTime'],
                arrivalTime: doc['arrivaltime'],
                fromStation: doc['fromStation'],
                toStation: doc['ToStation'],
                busId: doc['busId'],
                fromStationLatLng: fromLatLng,
                toStationLatLng: toLatLng,
              );
            }).toList();
          });
        } else {
          setState(() {
            voyage.clear();
          });
          debugPrint('No matching documents.');
        }
      } else {
        debugPrint('One or both stations not found.');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchStationNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('station').get();

      setState(() {
        stationName =
            querySnapshot.docs.map((doc) => doc['nom'] as String).toList();
        debugPrint('$stationName');
      });
    } catch (e) {
      debugPrint("Error fetching station names: $e");
    }
  }

  Future<void> addTripToNotifications(Voyage voyage) async {
  try {

    String userId = FirebaseAuth.instance.currentUser!.uid;


    DocumentReference userRef = FirebaseFirestore.instance.collection('etudiant').doc(userId);


    await userRef.update({
      'voyages': FieldValue.arrayUnion([voyage.voyageId])
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voyage ajouté')),
    );
  } catch (e) {
    debugPrint('Error adding trip to notifications: $e');

  }
}

}
