import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unitransit_app_1/pages/update_profile.dart';

class ProfileScreen extends StatelessWidget{
  ProfileScreen({super.key});
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
                 GetEtudiant(_uid!),
                 ProfileMenuWidget(title:"Log out" ,subtitle: 'goodbye',icon:Icons.logout ,onPress: (){},endIcon: false,textColor: Colors.red,),
              ],
            ),
          ),
      ),

    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    required this.title,
    required this.icon,
    required this.endIcon,
    required this.onPress,
    required this.textColor,
    required this.subtitle,
    super.key,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,

      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.withOpacity(0.1),
     
        ),
        child: Icon(icon, color:Colors.black),
      ),
      title: Text(title, style:Theme.of(context).textTheme.bodySmall?.apply(color: textColor)),
      trailing: endIcon? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        
        child: Icon(icon, size: 18,color: Colors.grey,),
      ):null,
      subtitle: Text(subtitle, style:Theme.of(context).textTheme.bodySmall?.apply(color: textColor)),
    );
  }
}
class GetEtudiant extends StatelessWidget {
  final String documentId;

  GetEtudiant(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('etudiant');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(children: [
            const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"Username" ,subtitle: '${data['username']}',icon:Icons.account_box ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"Email" ,subtitle: '${data['email']}',icon:Icons.email ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"Password" ,subtitle: '${data['password']}',icon:Icons.fingerprint ,onPress: (){},endIcon: false,textColor: Colors.black,),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"CIN" ,subtitle: '${data['CIN']}',icon:Icons.edit ,onPress: (){},endIcon: false,textColor: Colors.black,),
          ],);
        }
        return Text("loading");
      },
    );
  }
}
/*class ShowEtudiant extends StatelessWidget{
  final FirestoreService _fs = FirestoreService();
  final String documentId;
  ShowEtudiant(this.documentId);
  Widget build(BuildContext context){
  return Column(
    children: [StreamBuilder<QuerySnapshot>(
      stream: _fs.getEtudiantStream(documentId),
      builder: (context, snapshot) {
        debugPrint('$documentId');
        if(snapshot.hasData){
          debugPrint("ane fel if");
          List etudiantList=snapshot.data!.docs;
          debugPrint("$etudiantList");
          return ListView.builder(
            itemCount: etudiantList.length,
            itemBuilder: (context, index) {
              
              DocumentSnapshot document= etudiantList[index];
              String docID=document.id;
              debugPrint("$docID");
              Map<String,dynamic> data = document.data() as Map<String,dynamic>;
              String noteText = data['etudiant'];
              print(noteText);
              return ListTile(
                title: Text(noteText),
              );
            },
          );
        }else {
          debugPrint("ane fel else");
          return Text("NO");
        }
      },
      )
    ]
  );
}
}*/