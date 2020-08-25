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

  //Função para informa que os dados estão sendo carregados
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  // Atualizando o usuário logado
  void updateUser(UserManeger userManeger) {
    user = userManeger.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    // Verificando se o usuário é diferente de nulo
    if (user != null) {
      // Carregando os itens do carrinho
      _loadCartItems();

      // Carregando o usuário logado e os dados do seu endereço
      _loadUserAddress();
    }
  }

  // Carregando as informações do carrinho do usuário logado
  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    // Pegando os documentos
    items = cartSnap.documents
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  // Metódo para carregar os dados do endereço para calcular frete
  Future<void> _loadUserAddress() async {
    // Verificando se o endereço do usuário é diferente de nulo
    if (user.address != null &&
        await calculateDelivery(user.address.lat, user.address.long)) {
      address = user.address;
      notifyListeners();
    }
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

  // Função para limpar o carrinho
  void clear() {
    // Percorrendo cada um dos carrinhos
    for (final cartProduct in items) {
      user.cartReference.document(cartProduct.id).delete();
    }
    // Apagando a lista local
    items.clear();
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
    loading = true;

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
      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP inválido');
    }

  }

  // Função para set o endereço para calcular o frete
  Future<void> setAddress(Address address) async {
    loading = true;

    // Salvando o endereço atualizado
    this.address = address;

    if (await calculateDelivery(address.lat, address.long)) {
      // Acessando o usuário para salvar o endereço
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
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