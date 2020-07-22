import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/common/custom_drawer/custom_icon_button.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {
  CepInputField(this.address);

  final Address address;

  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Verificando se o CEP - zipCode
    if (address.zipCode == null) {
      return GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Campo para digitar o CEP
            TextFormField(
              controller: cepController,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'CEP',
                hintText: '12.345-678',
              ),

              // Bloqueando os campos que não válidos do teclado numerico
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CepInputFormatter(),
              ],
              // Especificando o tipo do teclado
              keyboardType: TextInputType.number,
              validator: (cep) {
                // Verificando se o campo do CEP é vázio
                if (cep.isEmpty) {
                  return 'Campo obrigatório';
                } else if (cep.length != 10) {
                  return 'CEP inválido';
                }
                return null;
              },
            ),

            // Botão de buscar o CEP
            RaisedButton(
              onPressed: () {
                if (Form.of(context).validate()) {
                  context.read<CartManager>().getAddress(cepController.text);

                  FocusScope.of(context).requestFocus(FocusNode());
                }
              },
              textColor: Colors.white,
              color: primaryColor,
              disabledColor: primaryColor.withAlpha(100),
              child: const Text('Buscar CEP'),
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          // Widget que deixar CEP fixo tela e habilita a edição do mesmo
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${address.zipCode}',
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: () {
                // Removendo o CEP
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
    }
  }
}
