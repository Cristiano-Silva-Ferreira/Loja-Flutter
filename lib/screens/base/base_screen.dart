import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {

  // Definindo o controlador do PageView
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: PageView(
        // Chamando o controlador do PageView
        controller: pageController,
        // Impedido que possa arrasta as páginas para trocar-las
        physics: const NeverScrollableScrollPhysics(),
        // Pagina pai
        // Página principal
        children: <Widget>[
          Scaffold(
            drawer: CustomDrawer() ,
            appBar: AppBar(
              title: const Text('Home'),
            ),
          ),
          Scaffold(
            drawer: CustomDrawer() ,
            appBar: AppBar(
              title: const Text('Home 2'),
            ),
          ),
          Scaffold(
            drawer: CustomDrawer() ,
            appBar: AppBar(
              title: const Text('Home 3'),
            ),
          ),
          Scaffold(
            drawer: CustomDrawer() ,
            appBar: AppBar(
              title: const Text('Home 4'),
            ),
          ),
          Container(color: Colors.red,),
          Container(color: Colors.yellow,),
          Container(color: Colors.green,),
        ],
      ),
    );
  }
}
