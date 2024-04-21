import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unitransit_app_1/pages/main_page_chauff.dart';
//import 'package:get/get.dart';

import '../models/voyage.dart';


class AddAlert extends StatefulWidget{
  final Voyage? voyage;

  const AddAlert({
    super.key,
    required this.voyage,
    });

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String busName='';
  @override
  void initState(){
    super.initState();
    fetchBusName(widget.voyage?.busId);
  }
    Set<String> _selected={'Late'};
     
    void updateSelected(Set<String> newSelection){
      setState(() {
        _selected = newSelection;
      });
    }

    Future<void> fetchBusName(String? busId) async {
      return _firestore.collection('bus').doc(busId).get().then((value) {
        setState(() {
          busName = value['nom'];
        });
      });
    }
    Future<void> updateNotification(Set<String>alert) async {
      String alertString= alert.toString();
      
      String currentDateTime = '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
      alertString=alertString.substring(1,alertString.length-1);
      // print(alertString);
      // print(alert);
      if(alertString=='Late'){
        // print(alertString);
        _firestore.collection('notifications').doc().set({
          'voyageId':widget.voyage?.voyageId,
          'title':'Retard',
          'message':"Nous sommes désolés d’annoncer que le bus de station ${widget.voyage?.fromStation} en direction à ${widget.voyage?.toStation} subira un retard.",
          'time':currentDateTime,
        });
      }
      else if(alertString=='Malfunction'){
        _firestore.collection('notifications').doc().set({
          'voyageId':widget.voyage?.voyageId,
          'title':'Panne',
          'message':'Nous sommes désolés, le bus de trajet station ${widget.voyage?.fromStation} à ${widget.voyage?.toStation} est actuellement hors service en raison d’une panne technique',
          'time':currentDateTime.toString(),
        });
      }
    }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: ()=> Get.to(() =>  const HomePageChauffeur()), icon: const Icon(Icons.arrow_back,color: Colors.white,)),
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
                  children: [Text('Ajouter alerte',style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold,),),
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
                      Text('Type d\'alerte',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
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
                          label: Text('En retard'),
                        ),
                        ButtonSegment<String>(
                          value: 'Malfunction',
                          icon: Icon(Icons.bus_alert),
                          label: Text('Panne')
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
                    child:const Text('Envoyer alerte'),
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