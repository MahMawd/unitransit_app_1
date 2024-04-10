import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unitransit_app_1/global/common/toast.dart';
import 'package:unitransit_app_1/pages/page_authentification.dart';
import '../components/boutton.dart';
import '../components/zone_texte.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController cinController = TextEditingController();
  Future<void> _signUp() async {
    try {
      if(nameController.text==''){
        throw EmptyNameException();
      }
      if(usernameController.text==''){
        throw EmptyUsernameException();
      }
      if(emailController.text==''){
        throw EmptyEmailException();
      }
      if(passwordController.text==''){
        throw EmptyPasswordException();
      }
      if(confirmPasswordController.text==''){
        throw EmptyConfirmPasswordException();
      }
      if(confirmPasswordController.text!=passwordController.text){
        throw PasswordMisMatchException();
      }
      if(cinController.text==''){
        throw EmptyCINException();
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Get the user's ID
    final String userId = userCredential.user!.uid;

    // Create a new document in Firestore for the user
    await FirebaseFirestore.instance.collection('etudiant').doc(userId).set({
      'CIN':cinController.text,
      'email': emailController.text,
      'name':nameController.text,
      'password':passwordController.text,
      'username':usernameController.text,
      // Add other user information as needed
    });

    // Sign up success, navigate to next page or do something else
    debugPrint('Signed up user: $userId');
    showToast(message: 'Compte créé');
  }on FirebaseAuthException catch(e){
    if(e.code=='email-already-in-use'){
      showToast(message:'Cette adresse email est déjà utilisée');
    }else if(e.code=='invalid-email'){
      showToast(message:'Email invalide');
    }
    else if(e.code=='weak-password'){
      showToast(message: 'Le mot de passe doit contenir au moins 6 caractères');
    }
    else {
      showToast(message:'Erreur:${e.code}');
    }
  }on EmptyNameException catch(e){
    showToast(message:'Erreur:${e.code}');
  }on EmptyUsernameException catch(e){
    showToast(message:'Erreur:${e.code}');
  }on EmptyEmailException catch(e){
    showToast(message:'Erreur:${e.code}');
  }
  on EmptyPasswordException catch(e){
    showToast(message:'Erreur:${e.code}');
  }
  on EmptyConfirmPasswordException catch(e){
    showToast(message:'Erreur:${e.code}');
  }
  on PasswordMisMatchException catch(e){
    showToast(message:'Erreur:${e.code}');
  }
  on EmptyCINException catch(e){
    showToast(message:'Erreur:${e.code}');
  }
   catch (e) {
    // Show error message
    debugPrint('Failed to sign up: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(20.0),
                  child: const Image(
                    image: AssetImage('lib/images/UniTransit_icon.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Text(
                    "UniTransit",
                    style: TextStyle(color: Colors.black, fontSize: 25.0),
                  ),
                ),
                const SizedBox(height: 30.0),
                ZoneTexte(
                  controller: nameController,
                  obscureText: false,
                  hintText: "Nom complet",
                ),
                const SizedBox(height: 20.0),
                ZoneTexte(
                  controller: usernameController,
                  obscureText: false,
                  hintText: "Nom d'utilisateur",
                ),
                const SizedBox(height: 20.0),
                ZoneTexte(
                  controller: emailController,
                  obscureText: false,
                  hintText: "Email",
                ),
                const SizedBox(height: 20.0),
                ZoneTexte(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Mot de passe",
                ),
                const SizedBox(height: 20.0),
                ZoneTexte(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: "Confirmer le mot de passe",
                ),
                const SizedBox(height: 20.0),
                ZoneTexte(
                  controller: cinController,
                  obscureText: false,
                  hintText: "CIN",
                ),
                const SizedBox(height: 30.0),
                Boutton(
                  onTap:_signUp,
                  text: "Créer un compte",
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Déjà un compte? "),
                    GestureDetector(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Authentification())); // Navigate to SignUp page
                          },
                      child: const Text(
                        "Connectez-vous",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class EmptyCINException implements Exception {
  String code ='Remplir le CIN';
}
class EmptyConfirmPasswordException implements Exception {
  String code ='Confirmer le mot de passe';
}
class EmptyPasswordException implements Exception {
  String code ='Remplir mot de passe';
}
class EmptyEmailException implements Exception {
  String code ='Remplir Email';
}
class EmptyUsernameException implements Exception {
  String code='Remplir le nom d\'utilisateur';
}

class EmptyNameException implements Exception {
  String code='Remplir le nom complet';
}

class PasswordMisMatchException implements Exception{
  String errorMessage() =>'Les mots de passe ne correspondent pas';
  String code='Les mots de passe ne correspondent pas';
}


