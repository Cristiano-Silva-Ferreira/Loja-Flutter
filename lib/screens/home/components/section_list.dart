import 'package:flutter/material.dart';
import 'package:lojavirtual/models/section.dart';
import 'package:lojavirtual/screens/home/components/item.tile.dart';
import 'package:lojavirtual/screens/home/components/section_header.dart';

class SectionList extends StatelessWidget {
  const SectionList(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionHeader(section),
          SizedBox(
            height: 150,
            child: ListView.separated(
                // Definindo a direção da rolagem
                scrollDirection: Axis.horizontal,
                // Acessando as imagens do item
                itemBuilder: (_, index) {
                  return ItemTile(section.items[index]);
                },
                // Definindo a separação entre os itens
                separatorBuilder: (_, __) => const SizedBox(
                      width: 4,
                    ),
                // Quantidade de itens que a lista terá
                itemCount: section.items.length),
          )
        ],
      ),
    );
  }
}
