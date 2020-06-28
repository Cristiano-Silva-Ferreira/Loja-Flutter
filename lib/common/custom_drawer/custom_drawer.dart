import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/drawer_tile.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'file:///E:/Documentos/Projetos/AndroidStudioProjects/loja_virtual/lib/common/custom_drawer/custom_drawer_header.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 203, 236, 241),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
          ListView(
            children: <Widget>[
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(
                iconData: Icons.home,
                title: 'Início',
                page: 0,
              ),
              DrawerTile(iconData: Icons.list,
                title: 'Produtos',
                page: 1,
              ),

              DrawerTile(iconData: Icons.playlist_add_check,
                title: 'Meus Pedidos',

                page: 2,),
              DrawerTile(iconData: Icons.location_on,
                title: 'Lojas',
                page: 3,
              ),

              Consumer<UserManeger>(
                builder: (_, userManeger, __) {
                  // Verificando se o usuário é admin
                  if (userManeger.adminEnabled) {
                    return Column(
                      children: <Widget>[
                        const Divider(),
                        DrawerTile(
                          iconData: Icons.settings,
                          title: 'Usuários',
                          page: 4,
                        ),

                        DrawerTile(
                          iconData: Icons.settings,
                          title: 'Pedidos',
                          page: 5,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )

            ],
          ),
        ],
      ),
    );
  }
}
