import 'package:flutter/material.dart';
import 'package:unitransit_app_1/pages/notification_etudiant.dart';
import 'package:unitransit_app_1/pages/page_accueil_etudiant.dart';
import 'package:unitransit_app_1/pages/profile.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});
  @override
  State<MainPage> createState()=>_MainPageState();
}
class _MainPageState extends State<MainPage>{
  int currentPage=0;
  List<Widget> pages=[
    const HomePage(),
    const ProfileScreen(),
    const NotificationView(),
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
          BottomNavigationBarItem(icon: Icon(Icons.notifications),
          label: "Notifications"
          ),
        ]
      ),
    );
  }
}