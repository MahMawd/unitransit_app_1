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
    if (emailController.text.trim() == '') {
      throw EmptyEmailException();
    }
    if (passwordController.text == '') {
      throw EmptyPasswordException();
    }
    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    debugPrint('Signed in user: ${userCredential.user!.uid}');
    
    String userType = await _getUserType(userCredential.user!.uid);
    debugPrint(userType);

    if (userType == 'etudiant') {

      _handleEtudiantSignIn();
    } else if (userType == 'chauffeur') {

      _handleChauffeurSignIn();
    } else {

    }
  } on FirebaseAuthException catch (e) {
    if(e.code =='invalid-credential'){
        showToast(message:'Email ou mot de passe invalide');
      }else if(e.code=='channel-error'){
        showToast(message: 'Saisissez l\'e-mail et le mot de passe.');
      }
      else{
        showToast(message:'Erreur : ${e.code}');
        debugPrint('ERROR:$e');
      }
  } on EmptyEmailException catch (e) {
    showToast(message:'Erreur: ${e.code}');
  } on EmptyPasswordException catch (e) {
    showToast(message:'Erreur: ${e.code}');
  } catch (e) {
    debugPrint('Failed to sign in: $e');
  }
}
Future<void> _resetPassword() async {
    try {
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      showToast(message: 'Email de réinitialisation du mot de passe envoyé. Veuillez vérifier votre boîte de réception');
    } catch (e) {
      showToast(message: 'Échec de l\'envoi de l\'e-mail de réinitialisation du mot de passe: $e');
    }
  }
void _handleEtudiantSignIn() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const MainPageEtudiant()),
  );
}

void _handleChauffeurSignIn() {
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
                  hintText: "Mot de passe",
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 25.0),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Mot de passe oublié"),
                    ],
                  ),
                ),
              const SizedBox(height: 30.0),
              Boutton(
                onTap:()=>_signIn(),
                text: "Connexion",
              ),
              const SizedBox(height: 30.0),
              Boutton(
                text: "Créer un compte",
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