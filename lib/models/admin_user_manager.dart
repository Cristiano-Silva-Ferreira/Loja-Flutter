import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class AdminUserManager extends ChangeNotifier {
  List<User> users = [];

  final Firestore firestore = Firestore.instance;

  // Finalizando a obtenção da atualização dos novos usuários
  StreamSubscription _subscription;

  // Verificando se o usuário é um admin
  void updateUser(UserManeger userManeger) {
    _subscription?.cancel();
    if (userManeger.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  // Obtendo a lista de usuários
  void _listenToUsers() {
    /* ESSE METODO É FEITO PARA RECEBER SOMENTE UMA FEZ A LISTA DOS USUÁRIOS SEM
    MOSTRAR HOUVER ATUALIZAÇÃO COM NOVOS USUÁRIOS ADICIONADOS

    firestore.collection('users').getDocuments().then((snapshot){
      users = snapshot.documents.map((e) => User.fromDocument(e)).toList();

    });
      // Ordenando os usuário por ordem alfabetica
      users.sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase())) ;
      notifyListeners();
  */
    // CASO QUEIRA VER A ATUALIZAÇÃO EM TEMPO REAL DOS USUÁRIOS NOVOS
    _subscription =
        firestore.collection('users').snapshots().listen((snapshot) {
      users = snapshot.documents.map((e) => User.fromDocument(e)).toList();
    });
    // Ordenando os usuário por ordem alfabetica
    users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
