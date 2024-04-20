import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/profile_menu_widget.dart';

class GetProfile extends StatelessWidget {
  final String documentId;
  final String collectionName;
  const GetProfile(this.documentId,this.collectionName, {super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection(collectionName);

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return const Text("Quelque chose s'est mal passé");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Le document n'existe pas.");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          if(collectionName=='chauffeur'){
            return Column(children: [
            const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"Nom d'utilisateur" ,subtitle: '${data['username']}',icon:Icons.account_box ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"E-mail" ,subtitle: '${data['email']}',icon:Icons.email ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"Mot de passe" ,subtitle: '${data['password']}',icon:Icons.fingerprint ,onPress: (){},endIcon: false,textColor: Colors.black,),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"ID" ,subtitle: '${data['ID']}',icon:Icons.edit ,onPress: (){},endIcon: false,textColor: Colors.black,),
          ],);
          }else {
            return Column(children: [
            const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"Nom d'utilisateur" ,subtitle: '${data['username']}',icon:Icons.account_box ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"E-mail" ,subtitle: '${data['email']}',icon:Icons.email ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"Mot de passe" ,subtitle: '${data['password']}',icon:Icons.fingerprint ,onPress: (){},endIcon: false,textColor: Colors.black,),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"CIN" ,subtitle: '${data['CIN']}',icon:Icons.edit ,onPress: (){},endIcon: false,textColor: Colors.black,),
          ],);
          }
          
        }
        return const Column(
          children: [
            SizedBox(height: 30),
              Divider(),
              SizedBox(height: 10),
            Text("Chargement"),
            CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}