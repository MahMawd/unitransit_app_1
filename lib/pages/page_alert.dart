import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/voyage.dart';
//import 'package:unitransit/driver.dart';

class AddAlert extends StatefulWidget{
  
  AddAlert({
    super.key,
    });

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Voyage voyage= Voyage(
    voyageId: 'voyageId', 
    departureTime: '8:00', 
    arrivalTime: '10:00', 
    fromStation: 'Campus Manar', 
    toStation: 'Oued El Lil', 
    busId: 'busId');
    Set<String> _selected={'Late'};

    void updateSelected(Set<String> newSelection){
      setState(() {
        _selected = newSelection;
      });
    }
    Future<void> updateNotification(Set<String>alert) async {
      String alertString= alert.toString();
      String message='${voyage.busId} will arive late to its destination ${voyage.toStation} ';
      String currentDateTime = '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
      alertString=alertString.substring(1,alertString.length-1);
      print(alertString);
      print(alert);
      if(alertString=='Late'){
        print(alertString);
        _firestore.collection('notifications').doc().set({
          'voyageId':voyage.voyageId,
          'title':'Late',
          'message':message,
          'time':currentDateTime,
        });
      }
      else if(alertString=='Malfunction'){
        _firestore.collection('notifications').doc().set({
          'voyageId':voyage.voyageId,
          'title':'Malfunction',
          'message':'${voyage.busId} has broken down during its voyage from ${voyage.fromStation} to ${voyage.toStation} ',
          'time':currentDateTime.toString(),
        });
      }
    }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        //leading: IconButton(onPressed: ()=> Get.to(() =>  VoyagesWidget()), icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text("",
        style: Theme.of(context).textTheme.headlineMedium ),
      ),   
        backgroundColor: Colors.black,          
        body: SafeArea(     
        child: Column(
        children:[
       const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
            children:  [ 
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:  [
               Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Add Alert',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),),
              SizedBox(height: 8,),],
                     ),
              ],
             ),
            SizedBox(height: 20,),],
             ),
           ),
           
 Expanded(
            child:  Container( padding: const EdgeInsets.all(25),color: Colors.grey[100],
            child:  Center(              
              child: Column(                
                children: [
                 const  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Kind of alert',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                      Icon(Icons.more_horiz),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(16), ),
                     child://const ListTile(leading: Icon(Icons.bus_alert),title: Text('choose alert'),),
                     SegmentedButton(
                      onSelectionChanged: updateSelected,
                      segments: const <ButtonSegment<String>>[
                        ButtonSegment<String>(
                          value: 'Late',
                          icon: Icon(Icons.bus_alert),
                          label: Text('Running Late'),
                        ),
                        ButtonSegment<String>(
                          value: 'Malfunction',
                          icon: Icon(Icons.bus_alert),
                          label: Text('Malfunction')
                        ),

                      ], 
                      selected: _selected)
                     
                          
                  ),
                  const SizedBox(height: 20,),
                    ElevatedButton(
                    style: ButtonStyle(
                    foregroundColor: getColor(Colors.black, Colors.white),
                    backgroundColor: getColor(Colors.white, Colors.red),
                    side: getBorder(Colors.blue, Colors.red)),
                    child:const Text('Envoye alert'),
                    onPressed: (){updateNotification(_selected);},),
                ],
              ),
            ),
          ),
          ),
            ],
             ),
             ),
    );
    
  }

  MaterialStateProperty<Color> getColor (Color color, Color colorPressed){
    getColor(Set<MaterialState> states){
      if(states.contains(MaterialState.pressed)){
        return colorPressed;
      }else{
        return color;
      }
    }
    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder (Color color, Color colorPressed){
    getBorder(Set<MaterialState> states){
      if (states.contains(MaterialState.pressed)){
        return BorderSide(color: colorPressed, width: 2);
      }else{
        return BorderSide(color: color, width: 2);
      }
    }
     return MaterialStateProperty.resolveWith(getBorder);
    }
}