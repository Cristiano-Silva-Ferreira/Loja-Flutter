import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {

  // Declarando o construstor
  const DrawerTile({this.iconData, this.title, this.page});

  // Passando por parametro
  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    // Obtendo a página atual
    final int curPage = context.watch<PageManager>().page;
    // Alterando a cor principal do menu selecionado
    final Color primaryColor = Theme.of(context).primaryColor;

    return InkWell( // Permite que possa tocar nos ícones do menu para um evento
      onTap: (){
        // Chamando a PageManager para controlar a trocar de página
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox( // Criar um caixa de espaçamento entre os objetos
        height: 60,
        child: Row( // Coloca os itens em forma de linha
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: curPage == page ? Colors.red : Colors.grey[700],
              ),
            ),


            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: curPage == page ? Colors.red : Colors.grey[700],
              ),
            )
          ],
        ),
      ),
    );
  }
}
