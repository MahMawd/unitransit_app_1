import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/boutton.dart';
import 'package:unitransit_app_1/components/zone_texte.dart';
import 'package:unitransit_app_1/global/common/toast.dart';
import 'package:unitransit_app_1/pages/page_accueil_etudiant.dart';
import 'package:unitransit_app_1/pages/sign_up.dart';
class Authentification extends StatefulWidget{
   Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final FirebaseAuth auth=FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      if(emailController.text==''){
        throw EmptyEmailException();
      }
      if(passwordController.text==''){
        throw EmptyPasswordException();
      }
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
        );
    print('Signed in user: ${userCredential.user!.uid}');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace 'NextPage' with the page you want to navigate to
      );
    }on FirebaseAuthException catch(e){
      if(e.code =='invalid-credential'){
        showToast(message:'Email ou mot de passe invalide');
      }else if(e.code=='channel-error'){
        showToast(message: 'Remplir les champs email et mot de passe');
      }
      else{
        showToast(message:'Erreur: ${e.code}');
        print('ERROR:$e');
      }
      }on EmptyEmailException catch(e){
        showToast(message:'Erreur:${e.code}');
        }on EmptyPasswordException catch(e){
          showToast(message:'Erreur:${e.code}');
          }catch (e) {
            print('Failed to sign in: $e');
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
                  hintText: "Mot de passe",
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 25.0),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Mot de Passe oublié"),
                    ],
                  ),
                ),
              const SizedBox(height: 30.0),
              Boutton(
                onTap:()=>_signIn(),
                text: "Se connecter",
              ),
              const SizedBox(height: 30.0),
              Boutton(
                text: "Créer nouveau compte",
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