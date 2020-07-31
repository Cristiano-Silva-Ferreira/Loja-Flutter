import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/price_card.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      // Informando qdo houver uma alteração no CartManager ira chamar o
      // updateCart passando o cartManager
      update: (_, cartManager, checkoutManager) =>
          checkoutManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Pagamento'),
            centerTitle: true,
          ),

          // Tela de finalizar o pedido
          body: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              return ListView(
                children: <Widget>[
                  // Botão de Finalizar Pedido
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () {
                      checkoutManager.checkout();
                    },
                  )
                ],
              );
            },
          )),
    );
  }
}
