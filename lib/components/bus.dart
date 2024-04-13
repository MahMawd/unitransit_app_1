import 'package:flutter/material.dart';

class BusWidget extends StatelessWidget{
  final ListTile test;
  const BusWidget({
    required this.test,
    super.key

    });
  @override
  Widget build(BuildContext context){
    return Container(
          height: 70,
          width: 370,
          //color: Colors.black,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.grey.shade300,),
          child:Row(
            children: [
              const Padding(
                padding:EdgeInsets.only(left:10.0),
                child: SizedBox(
                  width: 53,
                  height: 50,
                  //decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(5.0)),
                  child: Icon(size: 50,
                    Icons.directions_bus,
                  ),
                ),
              ),
              const SizedBox(width: 7.0,),
              SizedBox(
                width: 240,
                child: test),
              //const SizedBox(width: 180.0,),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(color: Colors.red)
                ),
                onPressed: () {},
                child:const Text("Start"),
               ),

            ] 
          )
        );
  }
}