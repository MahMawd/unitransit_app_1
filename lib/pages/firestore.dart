import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FirestoreService {
  final CollectionReference etudiants = FirebaseFirestore.instance.collection('etudiant');

  /*Query<Object?> getEtudiantStream(String id){
    final etudiantStream = etudiants.where(etudiants.id, isEqualTo: id);
    return etudiantStream;
  }*/
  Stream<QuerySnapshot> getEtudiantStream(String id){
    final etudiantStream=
    etudiants.snapshots();
    return etudiantStream;
  }
  /*late FirebaseAuth _auth;
  final _user=Rxn<User>();
  late Stream<User?> _authStateChanges;
  void initAuth() async{
    _auth=FirebaseAuth.instance;
    _authStateChanges=_auth.authStateChanges();
    _authStateChanges.listen((User? user){
      _user.value=user;
      print("user id ${user?.uid}...");
    });
  }
  User? getUser() {
    _user.value = _auth.currentUser;
    return _user.value;
  }*/
}