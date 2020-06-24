import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  // Buscando os dados do FireBase
  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    productId = document.data['pid'] as String;
    quantity = document.data['quantity'] as int;
    size = document.data['size'] as String;

    // Pegando os dados do produto
    firestore
        .document('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }

  // Acessando o FireStore
  final Firestore firestore = Firestore.instance;

  // Armazendo os campos que ira salvar no FireBase
  String id;
  String productId;
  int quantity;
  String size;

  Product product;

  ItemSize get itemSize {
    // Verificando se o produto é nulo
    if (product == null) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  // Função para incrementar
  void increment() {
    quantity++;
    notifyListeners();
  }

  // Função para decrementar
  void decrement() {
    quantity--;
    notifyListeners();
  }
}