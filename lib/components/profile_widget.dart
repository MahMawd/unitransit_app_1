import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/profile_menu_widget.dart';

class GetProfile extends StatelessWidget {
  final String documentId;
  final String collectionName;
  GetProfile(this.documentId,this.collectionName);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection(collectionName);

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