import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/product.dart';

class ProductManager extends ChangeNotifier{

  // Construtor
  ProductManager(){
    _loadAllProducts();

  }

  // Instanciando o FireStore
  final Firestore firestore =  Firestore.instance;

  List<Product> _allProducts = [];

  // Declando o produto
  Future<void> _loadAllProducts() async{
    // Acessando o FireStore
    final QuerySnapshot snapProducts = await firestore.collection('products')
        .getDocuments();

    // Acessando os produtos
    _allProducts = snapProducts.documents.map(
            (d) => Product.fromDocument(d)).toList();

    notifyListeners();
  }
}