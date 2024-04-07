import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/bus.dart';

class Accueil extends StatelessWidget{
  const Accueil({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body:SafeArea(child:Column(
        children: [for(int i=0;i<5;i++) const Bus()],
      )
      )
    );
  }
}