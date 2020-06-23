import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class CartManager {

  List<CartProduct> items = [];

  // Salvando o usuário logado
  User user;

  // Atualizando o usuário logado
  void updateUser(UserManeger userManeger){
    user = userManeger.user;
    items.clear();

    // Verificando se o usuário é diferente de nulo
    if(user != null){
      _loadCartItems();
    }
  }

  // Carregando as informações do carrinho do usuário logado
  Future<void>_loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    // Pegando os documentos
    items = cartSnap.documents.map((d) => CartProduct.fromDocument(d)).toList();
  }

  // Adicionando produto ao carrinho
  void addToCart(Product product) {
    try {
      // Procurando itens que podem empilhar (sendo iguais e com mesmo tamanho)
      final e = items.firstWhere((p) => p.stackable(product));
      e.quantity++;
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      // Transformando o produto em produto que pode adicionar ao carrinho
      items.add(cartProduct);

      // Salvando o carrinho
      user.cartReference.add(cartProduct.toCartItemMap());
    }
  }

}