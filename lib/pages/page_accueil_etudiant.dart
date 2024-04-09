import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/pages/page_authentification.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> stations = ['Tunis Marine', 'Station 2', 'Station 3', 'Station 4']; // Add your station names here

    String selectedStation = 'Tunis Marine'; // Initially select the first station
  @override 
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(items:const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications),label: ''),
      ] ),
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
                       
                //notfication
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
               //bch tba3d choose your placement al box loc
              const SizedBox(height: 20,),
               //box locationn
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
                              value: selectedStation,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStation = newValue;
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
                              value: selectedStation,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStation = newValue;
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
                child: const Row(
                  children: [              
                    Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                    
                   Text(
                    'search',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
              child:  Center(
                child: Column(
                  children: [
                   const  Row(
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
                    const SizedBox(
                      height: 20,
                    ),
                    //list of time
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const ListTile(leading: Icon(Icons.timer),
                      title: Text('Departure'),
                      subtitle: Text('14:30'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                     Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const ListTile(leading: Icon(Icons.timer),
                      title: Text('Departure'),
                      subtitle: Text('15:30'),
                      ),
                    ),
                                      const SizedBox(
                      height: 20,
                    ),
                     Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const ListTile(leading: Icon(Icons.timer),
                      title: Text('Departure'),
                      subtitle: Text('16:30'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authentification())); // Return to the sign-in page
                  } catch (e) {
                    print('Failed to sign out: $e');
                  }
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      )
    );
  }
}