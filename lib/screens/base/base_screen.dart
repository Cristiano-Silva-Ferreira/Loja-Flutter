import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/home/home_screen.dart';
import 'package:lojavirtual/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  // Definindo o controlador do PageView
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManeger>(
        builder: (_, userManager, __) {
          return PageView(
            // Chamando o controlador do PageView
            controller: pageController,
            // Impedido que possa arrasta as páginas para trocar-las
            physics: const NeverScrollableScrollPhysics(),
            // Pagina pai
            // Página principal
            children: <Widget>[
              // Tela HOME
              HomeScreen(),

              // Tela de PRODUTOS
              ProductsScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home 3'),
                ),
              ),

              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home 4'),
                ),
              ),
              if (userManager.adminEnabled) ...[
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Usuários'),
                  ),
                ),
                Scaffold(
                  drawer: CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Pedidos'),
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
