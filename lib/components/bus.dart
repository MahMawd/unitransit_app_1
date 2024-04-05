import 'package:flutter/material.dart';

class Bus extends StatelessWidget{
  const Bus({super.key});
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 70,
          width: 370,
          //color: Colors.black,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.grey.shade300,),
          child:Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:10.0),
                child: Container(
                  width: 53,
                  height: 50,
                  //decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(5.0)),
                  child: const Icon(size: 50,
                    Icons.directions_bus,
                  ),
                ),
              ),
              const SizedBox(width: 7.0,),
              const Text("38B",style: TextStyle(fontSize: 24,),),
              const SizedBox(width: 180.0,),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(color: Colors.red)
                ),
                onPressed: () {},
                child:const Text("Start"),
               ),
              /*const Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
              const Text("demarrer",style: TextStyle(color: Colors.white),),
              //SizedBox(width: 50.0,),
              const Column(
                children: [
                  SizedBox(height: 20.0,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 45.0)),
                  Text(".......",style: TextStyle(color: Colors.white,fontSize: 40.0)),
                ],
              ),
              const Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
              const Text("destination",style: TextStyle(color: Colors.white),),*/
            ] 
          )
        ),
    );
  }
}