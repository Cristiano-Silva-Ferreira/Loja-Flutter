import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/item_size.dart';

class Product extends ChangeNotifier{

  Product.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    // Transformando uma lista dinâmica em lista de string
    images = List<String>.from(document.data['images'] as List<dynamic>);
    // Pegando o tamanho das camisetas
    sizes = (document.data['sizes'] as List<dynamic> ?? []).map(
            (s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();

  }

  // Declarando os dados do FireBase
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value){
    _selectedSize = value;
    notifyListeners();
  }

  // Verificando a quantidade total do estoque
  int get totalStock {
   int stock = 0;
   for(final size in sizes){
     stock += size.stock;
   }
   return stock;
  }

  // Verificando se tem item no estoque
  bool get hasStock {
    return totalStock > 0;
  }


  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }
}