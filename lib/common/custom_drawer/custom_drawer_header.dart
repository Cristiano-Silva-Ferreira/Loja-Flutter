import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mostrando o nome principal da loja
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManeger>(
        builder: (_, userManger, __){
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: <Widget>[
             Text(
               'Loja do\nCristiano',
               style: TextStyle(
                 fontSize: 34,
                 fontWeight: FontWeight.bold,
               ),
             ),
            // Verificando se o usuário esta logado
             Text(
               'Ola, ${userManger.user?.name ?? ''}',
               overflow: TextOverflow.ellipsis,
               maxLines: 2,
               style: TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
               ),
             ),
             // Inserindo o botão Entrar/Sair
             GestureDetector(
               onTap: (){
                  // Verificando se estar logado ou não
                 if(userManger.isLoggedIn){
                   userManger.signOut();

                 // Caso não esteja logado irá leva para a tela do login
                 } else {
                   Navigator.of(context).pushNamed('/login');
                 }
               },
               child: Text(
                  userManger.isLoggedIn
                      ? 'Sair'
                      : 'Entre ou cadastra-se >',
                 style: TextStyle(
                   color: Theme.of(context).primaryColor,
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             )
           ],
         );
        },
      ),
    );
  }
}
