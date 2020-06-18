import 'package:flutter/cupertino.dart';

class PageManager {

  // Criando o construtor do PageController para ser usado
  PageManager(this._pageController);

  // Declarando o pageController como privado para não ser usado em qualquer parte do app
  final PageController _pageController;

  int page = 0;

  // Chamando o método setPage controlar a trocar de pagina
  void setPage(int value){
    // Verificando qual página estar
    if(value == page) return;
    page = value;
    _pageController.jumpToPage(value);
  }

}