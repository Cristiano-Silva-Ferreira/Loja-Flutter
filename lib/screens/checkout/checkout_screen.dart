import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/price_card.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/checkout_manager.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

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
          key: scaffoldkey,
          appBar: AppBar(
            title: const Text('Pagamento'),
            centerTitle: true,
          ),

          // Tela de finalizar o pedido
          body: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              // Verificando se esta carregamento dos dados
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      )
                    ],
                  ),
                );
              }

              return ListView(
                children: <Widget>[
                  // Botão de Finalizar Pedido
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () {
                      checkoutManager.checkout(onStockFail: (e) {
                        Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/cart');
                      }, onSuccess: () {
                        Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/base');
                      });
                    },
                  )
                ],
              );
            },
          )),
    );
  }
}
