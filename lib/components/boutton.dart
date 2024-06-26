import 'package:flutter/material.dart';

class Boutton extends StatelessWidget{
final VoidCallback onTap;
  final String text;
  const Boutton({
    super.key,
    required this.text,
    required this.onTap,
    });
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () {
        onTap(); },
      child: Container(
        padding:const EdgeInsets.all(25),
        margin:const EdgeInsets.symmetric(horizontal: 75.0),
        decoration: BoxDecoration(
          color:Colors.black,
          borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(
          text,
        style:const TextStyle(
          color: Colors.white
          ),
        )
        )
      ),
    );
  }
}