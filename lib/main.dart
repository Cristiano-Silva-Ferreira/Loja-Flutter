import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/cart/cart_sreen.dart';
import 'package:lojavirtual/screens/login/login_screen.dart';
import 'package:lojavirtual/screens/product/product_screen.dart';
import 'package:lojavirtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

void main() async {
    runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Tela USUÁRIO
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManeger(),
          lazy: false,
        ),

        // Tela de PRODUTOS
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),

        // Tela HOME
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),

        // Tela do CARRINHO
        ChangeNotifierProxyProvider<UserManeger, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),
      ],
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
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login' :
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );
              case '/signup' :
              return MaterialPageRoute(
                builder: (_) => SignUpScreen()
              );
              case '/product' :
              return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  settings.arguments as Product
                )
              );
            case '/cart' :
              return MaterialPageRoute(
                  builder: (_) => CartScreen()
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


