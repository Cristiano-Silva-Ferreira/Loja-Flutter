import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';
import'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/screens/edit_product/components/images_form.dart';
import 'package:lojavirtual/screens/edit_product/components/sizes_form.dart';
import 'package:provider/provider.dart';
import'package:lojavirtual/screens/edit_product/components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(this.product);

  final Product product;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme
        .of(context)
        .primaryColor;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
          appBar: AppBar(
            title: Text(ediling ? 'Editar Produto' : 'Criar Produto'),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                ImagesForm(product),
                // Editando o nome do produto
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Campo Titulo
                      TextFormField(
                        initialValue: product.name,
                        decoration: const InputDecoration(
                          hintText: 'Título',
                          border: InputBorder.none,
                        ),
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        validator: (name) {
                          if (name.length < 6) {
                            return 'Titulo muito curto';
                          }
                          return null;
                        },
                        onSaved: (name) => product.name = name,
                      ),

                      // Campo a partir de...
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'A partir de',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Campo preço
                      Text(
                        'R\$ ...',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),

                      // Campo descrição
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Descrição',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),

                      // Campo da descrição do produto
                      TextFormField(
                        initialValue: product.description,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                            hintText: 'Descrição', border: InputBorder.none),
                        maxLines: null,
                        validator: (desc) {
                          if (desc.length < 10) {
                            return 'Descrição muito curta';
                          }
                          return null;
                        },
                        onSaved: (desc) => product.description = desc,
                      ),

                      // Campos do tamanho
                      SizesForm(product),
                      const SizedBox(
                        height: 20,
                      ),
                      // Botão salvar
                      Consumer<Product>(
                        builder: (_, product, __) {
                          return SizedBox(
                            height: 44,
                            child: RaisedButton(
                              onPressed: !product.loading
                                  ? () async {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();

                                  await product.save();

                                  // Informando para o o ProductManger que houver alterações
                                  context
                                      .read<ProductManager>()
                                      .updade(product);

                                  Navigator.of(context).pop();
                                }
                              }
                                  : null,
                              textColor: Colors.white,
                              color: primaryColor,
                              disabledColor: primaryColor.withAlpha(100),
                              child: product.loading
                                  ? CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                              )
                                  : const Text(
                                'Salvar',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          =======
      return Scaffold(
      appBar: AppBar(
          title: const Text('Editar Anúncio'),
      centerTitle: true,
    ),
    backgroundColor: Colors.white,
    body: Form(
    key: formKey,
    child: ListView(
    children: <Widget>[
    ImagesForm(product),
    // Editando o nome do produto
    Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
    // Titulo do produto
    TextFormField(
    initialValue: product.name,
    decoration: const InputDecoration(
    hintText: 'Título',
    border: InputBorder.none,
    ),
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    validator: (name) {
    if (name.length < 6) {
    return 'Titulo muito curto';
    }
    return null;
    },
    ),

    // Campo a partir de...
    Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
    'A partir de',
    style: TextStyle(
    color: Colors.grey[600],
    fontSize: 13,
    ),
    ),
    ),

    // Campo preço
    Text(
    'R\$ ...',
    style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: primaryColor),
    ),

    // Campo descrição
    Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Text(
    'Descrição',
    style:
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
    ),

    // Campo da descrição do produto
    TextFormField(
    initialValue: product.description,
    style: const TextStyle(fontSize: 16),
    decoration: const InputDecoration(
    hintText: 'Descrição', border: InputBorder.none),
    maxLines: null,
    validator: (desc) {
    if (desc.length < 10) {
    return 'Descrição muito curta';
    }
    return null;
    },
    ),

    // Botão salvar
    RaisedButton(
    onPressed: () {
    if (formKey.currentState.validate()) {
    print('Válido!!!');
    }
    },
    child: const Text('Salvar'),
    ),
    ],
    ),
    )
    ],
    )
    ,
    )
    ,
    );
  }
}
