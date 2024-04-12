import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/profile_widget.dart';
import 'package:unitransit_app_1/pages/page_authentification.dart';

class ProfileScreenChauffeur extends StatelessWidget{
  ProfileScreenChauffeur({super.key});
  final String? _uid=FirebaseAuth.instance.currentUser?.uid;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
        style: Theme.of(context).textTheme.headlineMedium ),
        actions: const [

        ],
      ),
      body:SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
               const SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                  ),
                ),
                const SizedBox(height:10),
                const SizedBox(height:20),
                /*SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() =>  UpdateProfile()), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, side: BorderSide.none, shape: const StadiumBorder(), ),
                child: const Text("Edit Profile",style: TextStyle(color: Colors.black),),             
                ),
                ),*/
                /*StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('etudiant').snapshots(),
                 builder: (context,snapshot){
                  List<Row> etudiantWidgets = [];
        
                  if (snapshot.hasData){
                    final etudiants = snapshot.data?.docs.reversed.toList();
                    for(var etud in etudiants!){
                      final etudiantWidget=Row(
                        children: [
                          Text(etud['username']),
                          ],);
                          etudiantWidgets.add(etudiantWidget);
                    }
                  }
                  return Expanded(
                    child: ListView(
                      children: etudiantWidgets,
                    ),
                  );
                 }
                 ),*/
                 GetProfile(_uid!,'chauffeur'),
                 //ProfileMenuWidget(title:"Log out" ,subtitle: 'goodbye',icon:Icons.logout ,onPress: (){},endIcon: false,textColor: Colors.red,),
                  ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Authentification())); // Return to the sign-in currentPage
                  } catch (e) {
                    debugPrint('Failed to sign out: $e');
                  }
                },
                child: const Text('Sign Out'),
              ),
              ],
            ),
          ),
      ),

    );
  }
}
