import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/cart_product.dart';

class Order {
  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user.id;
    address = cartManager.address;
  }

  final Firestore firestore = Firestore.instance;

  Future<void> save() async {
    firestore.collection('orders').document(orderId).setData({
      // Pegando cada um dos itens do cartProduct e transformando eles em um
      // map e retornando uma lista com esse mapa para salvar na lista vazia
      'items': items.map((e) => e.toOrderItemMap()).toList(),
      'price': price,
      'user': userId,
      'address': address.toString(),
    });
  }

  String orderId;

  List<CartProduct> items;
  num price;

  String userId;

  Address address;

  Timestamp date;
}
