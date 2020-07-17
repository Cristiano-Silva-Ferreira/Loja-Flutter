import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/product.dart';

class ProductManager extends ChangeNotifier {
  // Construtor
  ProductManager() {
    _loadAllProducts();
  }

  // Instanciando o FireStore
  final Firestore firestore = Firestore.instance;

  List<Product> allProducts = [];

  String _search = '';

  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  // Veridicando se estar pesquisando ou não
  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    // Aplicando os filtros na lista de pesquisa
    // Verificando se a lista esta vázia
    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      // Caso contrário adicionando os produtos cujo título contenha a pesquisa
      filteredProducts.addAll(allProducts
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  // Declando o produto
  Future<void> _loadAllProducts() async {
    // Acessando o FireStore
    final QuerySnapshot snapProducts =
        await firestore.collection('products').getDocuments();

    // Acessando os produtos
    allProducts =
        snapProducts.documents.map((d) => Product.fromDocument(d)).toList();

    notifyListeners();
  }

  Product findProductById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void updade(Product product) {
    // Removendo um da produto antigo da lista
    //allProducts.retainWhere((p) => p.id == product.id);
    final List<Product> newProducts = [];

    for (final currentProduct in allProducts) {
      if (currentProduct.id != product.id) {
        newProducts.add(currentProduct);
      }
    }
    // Limpando a lista de produtos
    allProducts.clear();
    // Adiciona o novo produto
    allProducts.addAll(newProducts);
    allProducts.add(product);
    notifyListeners();
  }
}
