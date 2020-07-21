import 'package:flutter/material.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/section.dart';
import 'package:lojavirtual/screens/home/components/add_tile_widget.dart';
import 'package:lojavirtual/screens/home/components/item_tile.dart';
import 'package:lojavirtual/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  const SectionList(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),
            SizedBox(
                height: 150,
                child: Consumer<Section>(
                  builder: (_, section, __) {
                    return ListView.separated(
                      // Definindo a direção da rolagem
                      scrollDirection: Axis.horizontal,
                      // Acessando as imagens do item
                      itemBuilder: (_, index) {
                        // Verificando a quantidade de itens exibidos
                        if (index < section.items.length) {
                          return ItemTile(section.items[index]);
                        } else {
                          return AddTileWidget();
                        }
                      },
                      // Definindo a separação entre os itens
                      separatorBuilder: (_, __) =>
                      const SizedBox(width: 4,
                      ),
                      // Quantidade de itens que a lista terá
                      itemCount: homeManager.editing
                          ? section.items.length + 1
                          : section.items.length,
                    );
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}
