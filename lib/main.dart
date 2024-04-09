import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unitransit_app_1/pages/page_authentification.dart';
import 'package:unitransit_app_1/pages/page_maps.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
//import 'package:unitransit_app/pages/page_accueil.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.locationWhenInUse.isDenied.then((valueOfPermission)
  {
    if (valueOfPermission){
      Permission.locationWhenInUse.request();
    }
    
  });
  runApp(const UniTransitApp());
}

class UniTransitApp extends StatelessWidget{
  const UniTransitApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authentification(),
    );
  }
}