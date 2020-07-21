import 'package:flutter/material.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget(this.homeManager);

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: () {
                homeManager.addSection(Section(type: 'List'));

                FocusScope.of(context).requestFocus(FocusNode());
              },
              textColor: Colors.white,
              child: const Text('Adicionar Modo Lista'),
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () {
                homeManager.addSection(Section(type: 'Staggered'));
              },
              textColor: Colors.white,
              child: const Text('Adicionar Modo Grade'),
            ),
          )
        ],
      ),
    );
  }
}
