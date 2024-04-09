import 'package:flutter/material.dart';
class ZoneTexte extends StatelessWidget{
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;
  const ZoneTexte({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    });
  @override
  Widget build(BuildContext context){
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])
          ),
        ),
    );
  }
}