import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/products/components/product_list_tile.dart';
import 'package:provider/provider.dart';
import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager,__){
            // Verificando se a pesquisa estar vázia
            if(productManager.search.isEmpty){
              return const Text('Produtos');
            } else {
              return LayoutBuilder(
                builder: (_, constraints){
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(context: context,
                          builder: (_) => SearchDialog(
                            productManager.search
                          ));
                      if(search != null){
                        productManager.search = search;
                      }
                    },
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(
                          productManager.search,
                      textAlign: TextAlign.center,
                      )
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        // Adicionando os botões de pesquisa e adicionar produto Criando uma pesquisa local
        actions: <Widget>[
            // Botão de pesquisa
          Consumer<ProductManager>(
              builder: (_, productManager, __){
                // Verificando se estar fazendo pesquisa
                if(productManager.search.isEmpty){
                  return IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      // Exibindo o campo de pesquisa
                      final search = await showDialog<String>(
                          context: context,
                          builder: (_) => SearchDialog(
                            productManager.search
                          ));
                      // Verificando se a pesquisa é diferente de nulo
                      if(search != null){
                        productManager.search = search;
                      }
                    },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    productManager.search = '';
                  },
                );
              }
            },
          ),

          // Botão de adicionar
          Consumer<UserManeger>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit_product',
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ],

      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __){
        final filteredProducts = productManager.filteredProducts;
        return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductListTile(filteredProducts[index]);
            });
      }),
      // Adicionando um botão do carrinho
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
