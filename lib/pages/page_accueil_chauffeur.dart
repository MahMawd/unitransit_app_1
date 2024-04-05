import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/bus.dart';
//import 'package:unitransit_app/components/bus_v2.dart';

class AccueilChauffeur extends StatelessWidget {
  const AccueilChauffeur({super.key});
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items:const [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications),label: ''),]),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(child: Column(
        children: [
            Container(
                color: Colors.black,
                padding: const EdgeInsets.all(20.0),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Text("Welcome",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Row(
              children: [
                Text("Choose bus",style: TextStyle(color: Colors.white,fontSize: 16,)),
                        ],
                      )
                  ],
                ),
              ),
              //const SizedBox(height: 7.0,),
            Container(  
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: const Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Buses available:",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                    //SizedBox(height: 8.0,),
                    Bus(),
                    Bus(),
                    Bus(),
                    Bus(),
                  ],
                ),
            )
        ],

      )),
    );
  }
}