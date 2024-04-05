import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/bus_v2.dart';
import 'package:unitransit_app_1/pages/page_authentification.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override 
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(items:const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications),label: ''),
      ] ),
      body: SafeArea(
        child: Column(
          children: [
            //begin search bar
             Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
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
              //end search bar
              const SizedBox(height: 7.0,),
          //begin busV2 widget
          BusV2(),
          SizedBox(height: 7.0,),
          BusV2(),
          /*
           Container(
            height: 210,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),color: Colors.black,),
             child: Padding(
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
                  'Bus name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                               ),
                               SizedBox(
                  height: 8,
                               ),
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
              const SizedBox(
                height: 20,
               ),
               //box locationn
                         Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12), //el kober mta3 box from
                // fi west box fih location
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black),
                      SizedBox(
                        width:10,
                      ),
                    Text('From     Tunis Marine',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    ),
                 ],
                ),
                         ),
                         const SizedBox(height: 20,), 
               Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12), //el kober mta3 box from
                // fi west box fih location
                child: const Row(
                  children: [              
                    Icon(
                      Icons.location_on,
                      color: Colors.black),
                     SizedBox(
                        width:10,
                      ),
                    Text('To     Faculty of sciences',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    ),
                 ],
                ),
                         ),
                         const SizedBox(height: 25,),
                ],
               ),
             ),
           ),
           */
           //end busV2 widget
           /*const SizedBox(
            height: 25,
           ),
          Expanded(
            child:  Container(
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
          ),*/
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Authentification())); // Return to the sign-in page
                } catch (e) {
                  print('Failed to sign out: $e');
                }
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      )
    );
  }

}