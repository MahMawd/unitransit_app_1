import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unitransit_app_1/pages/update_profile.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
        style: Theme.of(context).textTheme.headlineMedium ),
        actions: const [
          //IconButton(onPressed: (){}, icon: Icon(isDark? LineAwesomeIcons.sun : LineAwesomeIcons.noon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
             const SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  //borderRadius: BorderRadius.circular(100),child: const Image(image: AssetImage(tprofileimage)),
                ),
              ),
              const SizedBox(height:10),
              Text("Mahmoud", style: Theme.of(context).textTheme.headlineMedium),
              Text("mahmoud@gmail.com", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height:20),
              SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => Get.to(() =>  UpdateProfile()), 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, side: BorderSide.none, shape: const StadiumBorder(), ),
              child: const Text("Edit Profile",style: TextStyle(color: Colors.black),),             
              ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"Username" ,subtitle: 'mahmoud',icon:Icons.account_box ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"Email" ,subtitle: 'mahmoud@gmail.com',icon:Icons.email ,onPress: (){},endIcon: false,textColor: Colors.black,),
              ProfileMenuWidget(title:"Password" ,subtitle: '*******',icon:Icons.fingerprint ,onPress: (){},endIcon: false,textColor: Colors.black,),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title:"Numéro d'inscription" ,subtitle: '1235698',icon:Icons.edit ,onPress: (){},endIcon: false,textColor: Colors.black,),
               ProfileMenuWidget(title:"Log out" ,subtitle: 'mahmoud',icon:Icons.logout ,onPress: (){},endIcon: false,textColor: Colors.red,),
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