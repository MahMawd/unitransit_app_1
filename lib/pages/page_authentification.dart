import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/boutton.dart';
import 'package:unitransit_app_1/components/zone_texte.dart';
import 'package:unitransit_app_1/pages/sign_up.dart';


class Authentification extends StatelessWidget{
   Authentification({super.key});
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
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
                onTap:()=>{},
                text: "Se connecter",
              ),
              const SizedBox(height: 30.0),
              Boutton(
                text: "Créer nouveau compte",
                onTap:(){
                   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()), // Navigate to SignUp page
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