import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/services/cepaberto_services.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  // Salvando o usuário logado
  User user;

  Address address;

  num productsPrice = 0.0;
  num deliveryPrince;

  // Calculando o valor total da venda
  num get totalPrice => productsPrice + (deliveryPrince ?? 0);

  final Firestore firestore = Firestore.instance;

  // Atualizando o usuário logado
  void updateUser(UserManeger userManeger) {
    user = userManeger.user;
    items.clear();

    // Verificando se o usuário é diferente de nulo
    if (user != null) {
      _loadCartItems();
    }
  }

  // Carregando as informações do carrinho do usuário logado
  Future<void>_loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    // Pegando os documentos
    items = cartSnap.documents.map(
            (d) =>
        CartProduct.fromDocument(d)
          ..addListener(_onItemUpdated)
    ).toList();
  }

  // Adicionando produto ao carrinho
  void addToCart(Product product) {
    try {
      // Procurando itens que podem empilhar (sendo iguais e com mesmo tamanho)
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      // Atualizando os itens do carrinho
      cartProduct.addListener(_onItemUpdated);
      // Transformando o produto em produto que pode adicionar ao carrinho
      items.add(cartProduct);

      // Salvando o carrinho
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  // Removendo o item do carrinho
  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    // Removendo do FireBase
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  // Atualizando a quantidade dos itens no FireBase
  void _onItemUpdated() {
    productsPrice = 0.0;

    // Acessando cada um dos itens no carrinho
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      // Verificando se o item é igual a zero
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  // Função para atualizar o carrinho
  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user.cartReference.document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
    }
  }

  // Função para Verificar se em todos os carrinho tem estoque o suficiente
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  // Função para verificar se o endereço e o preço são diferente de nulo
  bool get isAddressValid => address != null && deliveryPrince != null;

  // ADDRESS
  // Recebendo os dados do serviço de endereço
  Future<void> getAddress(String cep) async {
    final cepAbertoService = CepAbertoService();

    // Obtendo o endereço atraves do serviço
    try {
      // Obtendo os dados do CepAberto
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      // Transformando no ADDRESS do APP
      // Verificando se é nulo
      if (cepAbertoAddress != null) {
        address = Address(
            street: cepAbertoAddress.logradouro,
            district: cepAbertoAddress.bairro,
            zipCode: cepAbertoAddress.cep,
            city: cepAbertoAddress.cidade.nome,
            state: cepAbertoAddress.estado.sigla,
            lat: cepAbertoAddress.latitude,
            long: cepAbertoAddress.longitude);
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Função para set o endereço para calcular o frete
  Future<void> setAddress(Address address) async {
    // Salvando o endereço atualizado
    this.address = address;

    if (await calculateDelivery(address.lat, address.long)) {
      print('price $deliveryPrince');
      notifyListeners();
    } else {
      return Future.error('Endereço fora do raio de entrega :(');
    }
  }

  // Função para remover o CEP gravado
  void removeAddress() {
    address = null;
    deliveryPrince = null;
    notifyListeners();
  }

  // Função para calcular o valor do delivery
  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    // Obtendo os dados de latitude e longitude
    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;

    // Obtendo os dados do delivery
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxKm'] as num;

    // Calculando a disntancia
    double dis =
        await Geolocator().distanceBetween(latStore, longStore, lat, long);

    // Convertendeo a distancia de MT para KM
    dis /= 1000.0;

    // Verificando se a distancia esta no limite
    debugPrint('Distancia $dis');

    // Verificando a distancia
    if (dis > maxkm) {
      return false;
    }

    // Calculando o valor do frete
    deliveryPrince = base + dis * km;
    return true;
  }
}