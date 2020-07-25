import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/empty_cart.dart';
import 'package:lojavirtual/common/custom_drawer/login_cart.dart';
import 'package:lojavirtual/common/custom_drawer/price_card.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/screens/cart/components/cart_tile.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __) {
        // Verificando se o usuário esta logado
        if (cartManager.user == null) {
          return LoginCart();
        }

        // Verificando se tem itens para exibir no carrinho
        if (cartManager.items.isEmpty) {
          return EmptyCard(
            iconData: Icons.remove_shopping_cart,
            title: 'Nenhum produto no carrinho',
          );
        }

        return ListView(
          children: <Widget>[
            Column(
              children: cartManager.items
                  .map((cartProduct) => CartTile(cartProduct))
                  .toList(),
            ),
            PriceCard(
              buttonText: 'Continuar para Entrega',
              onPressed: cartManager.isCartValid ? () {
                  Navigator.of(context).pushNamed('/address');
                } : null,
              ),
            ],
          );
        }
      ),
    );
  }
}
