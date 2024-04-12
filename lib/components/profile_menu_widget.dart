import 'package:flutter/material.dart';

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