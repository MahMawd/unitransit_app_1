import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/boutton.dart';
import 'package:unitransit_app_1/components/zone_texte.dart';
import 'package:unitransit_app_1/global/common/toast.dart';
import 'package:unitransit_app_1/pages/main_page.dart';
import 'package:unitransit_app_1/pages/main_page_chauff.dart';

import 'package:unitransit_app_1/pages/sign_up.dart';
class Authentification extends StatefulWidget{
   const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final FirebaseAuth auth=FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn() async {
  try {
    if (emailController.text == '') {
      throw EmptyEmailException();
    }
    if (passwordController.text == '') {
      throw EmptyPasswordException();
    }
    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    debugPrint('Signed in user: ${userCredential.user!.uid}');
    
    // Determine user type based on collection
    String userType = await _getUserType(userCredential.user!.uid);
    debugPrint(userType);
    // Navigate to appropriate page or perform actions based on user type
    if (userType == 'etudiant') {
      // Do something specific for 'etudiant' users
      _handleEtudiantSignIn();
    } else if (userType == 'chauffeur') {
      // Do something specific for 'chauffeur' users
      _handleChauffeurSignIn();
    } else {
      // Handle other user types if needed
    }
  } on FirebaseAuthException catch (e) {
    if(e.code =='invalid-credential'){
        showToast(message:'Invalid email or password');
      }else if(e.code=='channel-error'){
        showToast(message: 'Type in the email and password');
      }
      else{
        showToast(message:'Error: ${e.code}');
        debugPrint('ERROR:$e');
      }
  } on EmptyEmailException catch (e) {
    showToast(message:'Error: ${e.code}');
  } on EmptyPasswordException catch (e) {
    showToast(message:'Error: ${e.code}');
  } catch (e) {
    debugPrint('Failed to sign in: $e');
  }
}

void _handleEtudiantSignIn() {
  // Navigate to MainPage for 'etudiant' users
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MainPageEtudiant()),
  );
}

void _handleChauffeurSignIn() {
  // Do something specific for 'chauffeur' users
  // For example, navigate to a chauffeur-specific page
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomePageChauffeur()),
  );
}
Future<String> _getUserType(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot etudiantDoc = await firestore.collection('etudiant').doc(uid).get();
    DocumentSnapshot chauffeurDoc = await firestore.collection('chauffeur').doc(uid).get();

    if (etudiantDoc.exists) {
      return 'etudiant';
    } else {
      return 'chauffeur';
   }
  }
            
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor:Colors.white,
      body:SafeArea(
          child: Center(
            child:SingleChildScrollView(
            child: Column(
              /*mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,*/
              children: [
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(20.0),
                  child:const Image(image: AssetImage('lib/images/UniTransit_icon.png'),fit: BoxFit.cover,),
                ),
                Container(
                  //alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Text("UniTransit",
                  style: TextStyle(color: Colors.black,fontSize: 25.0),),
                ),
                const SizedBox(height: 30.0),
                ZoneTexte( 
                  controller: emailController,
                  obscureText: false,
                  hintText: "Email",
                ),
                const SizedBox(height: 30.0),
                ZoneTexte(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 25.0),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot password"),
                    ],
                  ),
                ),
              const SizedBox(height: 30.0),
              Boutton(
                onTap:()=>_signIn(),
                text: "Sign in",
              ),
              const SizedBox(height: 30.0),
              Boutton(
                text: "Create an account",
                onTap:(){
                   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUp()), // Navigate to SignUp page
            );
                },
              )
              ],
            ),
          ),
          ),
        ),
      );
  }

}