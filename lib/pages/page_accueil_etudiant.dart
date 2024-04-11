import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> stations = ['Campus Manar', 'El Menzah', 'Station 3', 'Station 4'];
  List<String> stationName =[];
  
    String selectedStationFrom = 'Campus Manar';
    String selectedStationTo = 'El Menzah';
    final TextEditingController searchController = TextEditingController();
    List<Voyage> voyage = [];
    @override
  void initState() {
    super.initState();
    fetchStationNames();
  }
  @override 
  Widget build(BuildContext context){
    return  Scaffold(
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
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                       Text(
                  'Search Bus',
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
                  'choose your placement !',
                  style: TextStyle(color: Colors.white),
                )
               ],
                       ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,), 
                )
                ],
               ),
              const SizedBox(height: 20,),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                    child:Row(
                      children: <Widget>[
                        const Icon(
                      Icons.location_on,
                      color: Colors.black),
                     const SizedBox(width:10,),
                      const Text("From"),
                      const SizedBox(width:10,),
                        SizedBox(
                          height: 60.0,
                          width: 250.0,
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0),)
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              value: selectedStationFrom,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStationFrom = newValue;
                                    });
                                  }
                                },
                                items: stations.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                    );
                                  }).toList(),
                              ),
                          ),
                        ),
                      ],
                    ),

              ),
              const SizedBox(height: 20,),    
              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                    child:Row(
                      children: <Widget>[
                        const Icon(
                      Icons.location_on,
                      color: Colors.black),
                     const SizedBox(width:10,),
                      const Text("To"),
                      const SizedBox(width:25,),
                        SizedBox(
                          height: 60.0,
                          width: 250.0,
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0),)
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              value: selectedStationTo,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStationTo = newValue;
                                    });
                                  }
                                },
                                items: stations.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                    );
                                  }).toList(),
                              ),
                          ),
                        ),
                      ],
                    ),
              ),
              const SizedBox(height: 25,),

               Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12), //el 3ordh mta3 box 
                // fi west box search
                child: Row(
                  children:[              
                    const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 20,),
                  SizedBox(
                    height: 50,
                    width: 270,
                    child: ElevatedButton(onPressed: (){fetchData(selectedStationFrom,selectedStationTo);}, child: const Text("search"))
                    )
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
                  height: 235,
                  color: Colors.grey[100],
                  child: Center(
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Times',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                        SizedBox(height: 20),
                        voyage.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: voyage.length,
                            itemBuilder: (BuildContext context, int index) {
                              Voyage currentVoyage = voyage[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  leading: Icon(Icons.timer),
                                  title: Text('Departure: ${currentVoyage.departureTime}'),
                                  subtitle: Text('From: ${currentVoyage.fromStation} - To: ${currentVoyage.toStation}'),
                                ),
                              );
                            },
                          )
                        : Text("No data"),
                                ],
                              ),
                            ),
                          ),
                                      ],
                                    ),
                                  ),
                                )
                              );
                            }
  
 Future<void> fetchData(String stationFrom,String stationTo) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('voyage')
        .where('fromStation', isEqualTo: stationFrom)
        .where('ToStation', isEqualTo: stationTo)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      //var document = querySnapshot.docs.first.data();
      setState(() {
        voyage = querySnapshot.docs.map((doc) {
          return Voyage(
            departureTime: doc['departureTime'],
            arrivalTime: doc['arrivaltime'],
            fromStation: doc['fromStation'],
            toStation: doc['ToStation'],
          );
        }).toList();
      });
    } else {
      setState(() {
        voyage.clear();
      });
      print('No matching documents.');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
}
Future<void> fetchStationNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('station').get();

      setState(() {
        stationName = querySnapshot.docs.map((doc) => doc['nom'] as String).toList();
        print(stationName);
      });
    } catch (e) {
      print("Error fetching station names: $e");
    }
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