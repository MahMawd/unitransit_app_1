import 'package:flutter/material.dart';
import 'package:unitransit_app_1/pages/page_accueil_chauffeur.dart';
import 'package:unitransit_app_1/pages/profile_chauffeur.dart';

class HomePageChauffeur extends StatefulWidget{
  const HomePageChauffeur({super.key});
  @override
  State<HomePageChauffeur> createState()=>_HomePageChauffeur();
}
class _HomePageChauffeur extends State<HomePageChauffeur>{
  int currentPage=0;
  List<Widget> pages=[
    const MainPageChauffeur(),
    ProfileScreenChauffeur(),
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage=value;
          });
        },
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.home),
          label: "Accueil"
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
          label: "Profil"
          ),
        ]
      ),
    );
  }
}