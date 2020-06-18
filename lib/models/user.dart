//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {

  User({this.email, this.password, this.name, this.id});

  User.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;
  }

  String id;
  String name;
  String email;
  String password;

  String confirmPassword;

  // Referenciando os dodos
  DocumentReference get firestoreRef =>
    Firestore.instance.document('users/$id');

  // Salvando os dados do usuário
  Future<void> saveData() async{
    await firestoreRef.setData(toMap());
  }

  // Recuperando os dados do usuário e transformando em um mapa
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email':email,
    };
  }
}