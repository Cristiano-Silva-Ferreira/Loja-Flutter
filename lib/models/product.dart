import 'package:cloud_firestore/cloud_firestore.dart';

class Product {

  Product.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    // Transformando uma lista dinâmica em lista de string
    images = List<String>.from(document.data['images'] as List<dynamic>);
  }

  // Declarando os dados do FireBase
  String id;
  String name;
  String description;
  List<String> images;
}