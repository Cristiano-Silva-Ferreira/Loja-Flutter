import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_icon_button.dart';
import 'package:lojavirtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize(
      {Key key, this.size, this.onRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);

  final ItemSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // Campo do nome
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration:
                const InputDecoration(labelText: 'Título', isDense: true),
            validator: (name) {
              if (name.isEmpty) {
                return 'Sem Nome';
              }
              return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(
          width: 4,
        ),

        // Campo do tamanho
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock?.toString(),
            decoration:
                const InputDecoration(labelText: 'Estoque', isDense: true),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (int.tryParse(stock) == null) {
                return 'Inválido';
              }
              return null;
            },
            onChanged: (stock) => size.stock = int.tryParse(stock),
          ),
        ),
        const SizedBox(
          width: 4,
        ),

        // Campo do preço
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price) {
              if (num.tryParse(price) == null) {
                return 'Preço inválido';
              }
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
          ),
        ),

        // Botão Remover
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),

        // Botão mover para cima
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),

        // Botão mover para baixo
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),
      ],
    );
  }
}
