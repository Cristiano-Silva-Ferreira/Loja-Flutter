import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/screens/products/components/product_list_tile.dart';
import 'package:provider/provider.dart';

import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,

        // Adicionando os botões de pesquisa e adicionar produto Criando uma pesquisa local
        actions: <Widget>[
            // Botão de pesquisa
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // Exibindo o campo de pesquisa
              final search = await showDialog<String>(
                  context: context,
                  builder: (_) => SearchDialog());
              // Verificando se a pesquisa é diferente de nulo
              if(search != null){
                context.read<ProductManager>().search = search;
              }
            },
          )
        ],

      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
          return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: productManager.allProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(productManager.allProducts[index]);
            }
          );
        }
      ),
    );
  }
}
