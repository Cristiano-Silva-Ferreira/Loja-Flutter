import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/helpers/validator.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Recuperando os campos do formulário
  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                // Campo nome do formulário
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Nome Completo'),
                  validator: (name){
                    if(name.isEmpty){
                      return 'campo obrigatório';
                    } else if(name.trim().split(' ').length <= 1){
                      return 'Preencha seu Nome Completo';
                    }
                    return null;
                  },
                  onSaved: (name) => user.name = name,
                ),

                // Campo nome do e-mail
                const SizedBox(height: 16,),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (email){
                    if(email.isEmpty) {
                      return 'Campo obrigatório';
                    } else if(!emailValid(email)) {
                      return 'E-mail inválido!';
                    }
                    return null;
                  },
                  onSaved: (email) => user.email =  email,

                ),
                const SizedBox(height: 16,),

                // Campo nome do senha
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Senha'),
                  obscureText: true,
                  validator: (pass){
                    if(pass.isEmpty){
                      return 'Campo obrigatório.';
                    } else if(pass.length < 6){
                      return 'Senha muito curta.';
                    }
                    return null;
                  },
                  onSaved: (pass) => user.password = pass,
                ),
                const SizedBox(height: 16,),

                // Campo nome do confirma senha
                TextFormField(
                    decoration: const InputDecoration(hintText: 'Repita a Senha'),
                    obscureText: true,
                    validator: (pass){
                      if(pass.isEmpty){
                        return 'Campo obrigatório.';
                      } else if(pass.length < 6){
                        return 'Senha muito curta.';
                      }
                      return null;
                    },
                  onSaved: (pass) => user.confirmPassword = pass,

                ),
                const SizedBox(height: 16,),

                // Botão criar conta
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    color:  Theme.of(context).primaryColor,
                    disabledColor: Theme.of(context).primaryColor
                        .withAlpha(100),
                    textColor: Colors.white,
                    onPressed: (){
                      // Verificando se os campos do formulário são validos
                      if(formKey.currentState.validate()){
                        // Se estiver tudo certo chamar o método onSave de cada um dos forms
                        formKey.currentState.save();

                        // Verificando se as senhas são iguais
                        if(user.password != user.confirmPassword){
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: const Text('Senhas não coincidem!'),
                              backgroundColor: Colors.red,
                            )
                          );
                          return;
                        }

                        // usermanager
                        context.read<UserManeger>().signUp(
                          user: user,
                          onSuccess: (){
                            debugPrint('Sucesso');
                            // TODO: POP
                          },
                          onFail: (e){
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Falhar ao cadastrar: $e'),
                                backgroundColor: Colors.red,
                              )
                            );

                          }
                        );
                      }
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
