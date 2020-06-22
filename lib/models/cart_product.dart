import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';

class CartProduct {

  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  // Armazendo os campos que ira salvar no FireBase
  String productId;
  int quantity;
  String size;

  Product product;


  ItemSize get itemSize {
    // Verificando se o produto é nulo
    if(product == null) return null;
    product.findSize(size);
  }

  num get unitPrice {
    if(product == null) return 0;
    return itemSize.price ?? 0;
  }
}