import 'package:flutter/material.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {

  const SizeWidget({this.size});

  final ItemSize size;

  @override
  Widget build(BuildContext context) {

    // Acessando o produto selecionado
    final product = context.watch<Product>();
    // Verificando se o produto estar selecionado
    final selected = size == product.selectedSize;

    // Definindo a cor
    Color color;
   if(!size.hasStock) {
     // Se não tem no estoque
     color = Colors.red.withAlpha(50);
   } else if(selected) {
     // Se tem estoque é estar selecionado
     color = Theme.of(context).primaryColor;
   } else {
     // Se tem estoque
     color = Colors.grey;
   }

    return GestureDetector(
      onTap: (){
        // Verificando se tem estoque
        if(size.hasStock){
          product.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: !size.hasStock ? Colors.red.withAlpha(50) : Colors.grey
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

