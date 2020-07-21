import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/home/components/add_section_widget.dart';
import 'package:lojavirtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

import 'components/section_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: const [
              Color.fromARGB(255, 211, 118, 130),
              Color.fromARGB(255, 253, 181, 168)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                snap: true,
                floating: true,
                //elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja do Cristiano'),
                  centerTitle: true,
                ),

                // Adicionando o icone do carrinho
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),

                  // Adicionando o botão para edição
                  Consumer2<UserManeger, HomeManager>(
                    builder: (_, userManager, homeManager, __) {
                      // Verificando se é um usuário ADMIN
                      if (userManager.adminEnabled && !homeManager.loading) {
                        // Verificando se estar em modo de edição
                        if (homeManager.editing) {
                          return PopupMenuButton(
                            onSelected: (e) {
                              // Verificando a opção selecionada
                              if (e == 'Salvar') {
                                homeManager.saveEditing();
                              } else {
                                homeManager.discardEditing();
                              }
                            },
                            itemBuilder: (_) {
                              return ['Salvar', 'Descartar'].map((e) {
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: homeManager.enterEditing,
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  )

                ],
              ),

              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  // Verificando se estar carregando
                  if (homeManager.loading) {
                    return SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }

                  // Verificando o tipo da lista recebida
                  final List<Widget> children =
                  homeManager.sections.map<Widget>((section) {
                    // Verificando o tipo da seção
                    switch (section.type) {
                    // Verificando se é tipo List
                      case 'List':
                        return SectionList(section);
                      case 'Staggered':
                        return SectionStaggered(section);
                      default:
                        return Container();
                    }
                  }).toList();

                  // Verificando se esta em modo de edição para adicionar novo widget
                  if (homeManager.editing) {
                    children.add(AddSectionWidget(homeManager));
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
