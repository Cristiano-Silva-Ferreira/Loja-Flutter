import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';

class CartManager {

  List<CartProduct> items = [];

  // Adicionando produto ao carrinho
  void addToCart(Product product){
    // Transformando o produto em produto que pode adicionar ao carrinho
    items.add(CartProduct.fromProduct(product));
  }
}