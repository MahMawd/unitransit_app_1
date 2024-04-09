import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatelessWidget{
   UpdateProfile ({super.key});
    final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: ()=> Get.back(),icon: const Icon(Icons.arrow_back_rounded)),
        title: Text("Modify",
        style: Theme.of(context).textTheme.headlineMedium ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),//child: const Image(image: AssetImage(assetName))
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color:Colors.grey
                          ),
                          child: const Icon(Icons.edit,
                            color: Colors.black,
                            size: 20,
                            )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height:50),
                Form(child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Username"),prefixIcon: Icon(Icons.edit)),
                    ),
                    const SizedBox(height: 20),
                      TextFormField(
                      decoration: const InputDecoration(label: Text("Email"),prefixIcon: Icon(Icons.mail)),
                    ),
                    const SizedBox(height: 20),
                      TextFormField(
                      decoration: const InputDecoration(label: Text("Password"),prefixIcon: Icon(Icons.password)),
                    ),
                    const SizedBox(height: 20),
                      TextFormField(
                      decoration: const InputDecoration(label: Text("Numéro d'inscription"),prefixIcon: Icon(Icons.numbers)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),),
                SizedBox(
              width: 200,
              child: ElevatedButton(
                
                onPressed: () => Get.to(() =>  UpdateProfile()), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, side: BorderSide.none, shape: const StadiumBorder(), ),
              child: const Text("Edit Profile",style: TextStyle(color: Colors.black),),             
              ),
              ),
              ],
            ),
          ),
        ),
    );
  }
}