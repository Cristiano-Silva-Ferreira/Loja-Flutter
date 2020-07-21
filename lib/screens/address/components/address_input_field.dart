import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/models/address.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    // Validador dos compos do endereço
    String emptyValidator(String text) =>
        text.isEmpty ? 'Campo obrigatório' : null;

    return Column(
      children: <Widget>[
        // Campo da Rua
        TextFormField(
          initialValue: address.street,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Rua/Avenida',
            hintText: 'Av.Brasil',
          ),
          validator: emptyValidator,
          onSaved: (t) => address.street = t,
        ),

        Row(
          children: <Widget>[
            Expanded(
              // Campo do Número
              child: TextFormField(
                initialValue: address.number,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Número', hintText: '123'),
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                validator: emptyValidator,
                onSaved: (t) => address.number = t,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              // Campo complemento
              child: TextFormField(
                initialValue: address.complement,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Complemento',
                  hintText: 'Opcional',
                ),
                onSaved: (t) => address.complement = t,
              ),
            )
          ],
        ),

        // Campo do Bairro
        TextFormField(
          initialValue: address.district,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Bairro',
            hintText: 'Bom Sucesso',
          ),
          validator: emptyValidator,
          onSaved: (t) => address.district = t,
        ),

        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              // Campo Cidade
              child: TextFormField(
                enabled: false,
                initialValue: address.city,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Rio de Janeiro'),
              ),
            )
          ],
        )
      ],
    );
  }
}
