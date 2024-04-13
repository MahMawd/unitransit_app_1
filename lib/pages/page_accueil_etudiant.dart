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
  
    String selectedStationFrom = '0';
    String selectedStationTo = '0';
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
                      const SizedBox(width:5,),
                      SizedBox(
                        width: 264,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('station').snapshots(), 
                        builder:(context,snapshot){
                          List<DropdownMenuItem> stationItems = [];
                          if(!snapshot.hasData)
                          {
                            const CircularProgressIndicator();
                          }
                          else {
                            final stations =snapshot.data?.docs.reversed.toList();
                            stationItems.add(const DropdownMenuItem(
                              value: '0',
                              child: Text('Select Station'))
                              );
                            for(var s in stations!){
                              stationItems.add(DropdownMenuItem(
                                value: s.data()['nom'],
                                child: Text(s['nom']),
                                ),
                                );
                            }
                          }
                          return DropdownButton(items: stationItems,
                           onChanged: (sValue){
                            //print(sValue);
                            setState(() {
                              selectedStationFrom = sValue;
                            });
                           },
                           value:selectedStationFrom,
                           isExpanded: false,
                           );
                        }),
                      )
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
                      const SizedBox(width:20,),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('station').snapshots(), 
                      builder:(context,snapshot){
                        List<DropdownMenuItem> stationItems = [];
                        if(!snapshot.hasData)
                        {
                          const CircularProgressIndicator();
                        }
                        else {
                          final stations =snapshot.data?.docs.reversed.toList();
                          stationItems.add(const DropdownMenuItem(
                            value: '0',
                            child: Text('Select Station'))
                            );
                          for(var s in stations!){
                            stationItems.add(DropdownMenuItem(
                              value: s.data()['nom'],
                              child: Text(s['nom']),
                              ),
                              );
                          }
                        }
                        return DropdownButton(items: stationItems,
                         onChanged: (sValue){
                          //print(sValue);
                          setState(() {
                            selectedStationTo = sValue;
                          });
                         },
                         value:selectedStationTo,
                         isExpanded: false,
                         );
                      })
                      ],
                    ),
              ),
              const SizedBox(height: 25,),

               Container(
                /*decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),*/
                padding: const EdgeInsets.all(12),
                child: Row(
                  children:[              
                    /*const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),*/
                  const SizedBox(width: 20,),
                  const SizedBox(
                    height: 20,
                    width: 30,
                    child:Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 270,
                    child: ElevatedButton(onPressed: (){fetchData(selectedStationFrom,selectedStationTo);},
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.white,),
                     child: const Text("Search"),
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
                              'Times',
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
                            separatorBuilder:(context,index){
                              return const SizedBox(height: 10,);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              Voyage currentVoyage = voyage[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.timer),
                                  title: Text('Departure: ${currentVoyage.departureTime}'),
                                  subtitle: Text('From: ${currentVoyage.fromStation} - To: ${currentVoyage.toStation} \nArrival: ${currentVoyage.arrivalTime}'),
                                ),
                                
                              );
                            },
                          )
                        : const Text("No data"),
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
        debugPrint(stationFrom);
        debugPrint(stationTo);
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
      debugPrint('No matching documents.');
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
        stationName = querySnapshot.docs.map((doc) => doc['nom'] as String).toList();
        debugPrint('$stationName');
      });
    } catch (e) {
      debugPrint("Error fetching station names: $e");
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