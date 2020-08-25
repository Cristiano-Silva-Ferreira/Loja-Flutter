import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager cartManager;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final Firestore firestore = Firestore.instance;

  // ignore: use_setters_to_change_properties
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  // Função para check o estoque, e indicando para o usuário que não tem o estoque
  // do produto sufiente
  Future<void> checkout({Function onStockFail, Function onSuccess}) async {
    loading = true;
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }

    // TODO: PROCESSAR PAGAMENTO

    // Obtendo o número do pagamento
    final orderId = await _getOrderId();

    // Declarando o objeto do pedido
    final order = Order.fromCartManager(cartManager);
    // Salvando o order no orderId
    order.orderId = orderId.toString();

    await order.save();

    // Limpando o carrinho de pedidos
    cartManager.clear();

    onSuccess();

    loading = false;
  }

  // Função para controlar a order dos pedidos dos produtos gerando seus IDs
  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    // Fazendo a transação
    try {
      final result = await firestore.runTransaction((tx) async {
        // Acessando a referência do documento
        final doc = await tx.get(ref);

        // Obtendo a contagem atual
        final orderId = doc.data['current'] as int;

        // Atualizando o contador
        await tx.update(ref, {'current': orderId + 1});

        // Retornando o orderId
        return {'orderId': orderId};
      }, timeout: const Duration(seconds: 10));
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  // Função para decrementar e verificar o estoque
  Future<void> _decrementStock() {
    // 1. Ler todos os estoques
    // 2. Decremento localmente os estoques
    // 3. salvar os estoques no firebase

    return firestore.runTransaction((tx) async {
      // Lista dos produtos para ser decrementado localmente
      final List<Product> productsToUpdate = [];

      final List<Product> productsWithoutStock = [];

      // Percorrendo cada um dos items
      for (final cartProduct in cartManager.items) {
        // Evitando que 2 produtos tenham o msm ID no productUpdate
        Product product;
        // Verificando se o cartProduct já esta na lista, se estiver ira pegar
        // da propria lista e não do firebase e colocar no productToUpdate
        if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
          product =
              productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
        } else {
          // Caso os produtos não esteja na lista ira pegar eles para
          // Recuperando o ID do cartProduct mais atualizado do BD
          final doc = await tx
              .get(firestore.document('products/${cartProduct.productId}'));
          // Transformondo os dados obtidos em um objeto do tipo produto
          product = Product.fromDocument(doc);
        }

        // Setando o produto mais atualizado para verificar caso achar problema em algum pedido
        cartProduct.product = product;

        // Verificando o estoque para obter o tamanho do produto
        final size = product.findSize(cartProduct.size);

        // Verificando o nivel do estoque
        if (size.stock - cartProduct.quantity < 0) {
          // FALHAR
          productsWithoutStock.add(product);
        } else {
          // Decrementando a quantidade do estoque
          size.stock -= cartProduct.quantity;

          // Adicionando o produto na lista para ser atualizada
          productsToUpdate.add(product);
        }
      }

      // Verificar se a lista de produto que tem estoque não esteja vazia
      if (productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque o suficiente');
      }

      // Passando por cada um dos produtos no estoque e salvando no BD a nova quantidade
      for (final product in productsToUpdate) {
        tx.update(firestore.document('products/${product.id}'),
            {'sizes': product.exportSizeList()});
      }
    });
  }
}
