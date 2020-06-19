import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  // Recebendo por parâmetro o texto pesquisado
  const SearchDialog(this.initialText);

  final String initialText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              initialValue: initialText,
              // Transformando o botão de pesquisa do teclado
              textInputAction: TextInputAction.search,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                // Icone do botão sair
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
              ),
              // Recebendo o texto digitado na barra de pesquisa
              onFieldSubmitted: (text){
                Navigator.of(context).pop(text);
              },
            ),
          ),
        )
      ],
    );
  }
}
