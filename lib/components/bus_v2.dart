import 'package:flutter/material.dart';

class BusV2 extends StatelessWidget {
  BusV2({super.key});
  @override
  Widget build(BuildContext context){
    return Container(
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
           );
  }
}