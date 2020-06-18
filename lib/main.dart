import 'package:lojavirtual/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() async {
    runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserManeger(),
      child: MaterialApp(
          title: 'Loja do Cristiano',
          // Retirando o icone do debug
          debugShowCheckedModeBanner: false,
          theme: ThemeData(

          // Definindo uma cor primária
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          // Definindo a cor do background
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          // Retirando a elevação da AppBar
          appBarTheme: const AppBarTheme(
            elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

      initialRoute: '/base',
      onGenerateRoute: (setting){
        switch(setting.name){
            case '/signup' :
            return MaterialPageRoute(
              builder: (_) => SignUpScreen()
            );
          case '/base':
          default:
            return MaterialPageRoute(
                builder: (_) => BaseScreen()
            );
          }
        },
      ),
    );
  }
}


