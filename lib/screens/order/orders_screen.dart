import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/common/custom_drawer/empty_cart.dart';
import 'package:lojavirtual/common/custom_drawer/login_cart.dart';
import 'package:lojavirtual/models/order_manager.dart';
import 'package:lojavirtual/screens/order/components/order_tile.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, orderManager, __) {
          // Verificando se o usuário esta logado
          if (orderManager.user == null) {
            return LoginCart();
          }

          // Verificando se há algum pedido
          if (orderManager.orders.isEmpty) {
            return EmptyCard(
              title: 'Nenhuma compra encontrada!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
              itemCount: orderManager.orders.length,
              itemBuilder: (_, index) {
                return OrderTile(orderManager.orders.reversed.toList()[index]);
              });
        },
      ),
    );
  }
}
