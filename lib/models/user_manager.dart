import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/helpers/firebase_errors.dart';
import 'package:lojavirtual/models/user.dart';

class UserManeger extends ChangeNotifier{

  // Carregando o usuário
  UserManeger(){
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  // Salvando o usuário atual
  FirebaseUser user;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {

    // Informando que estar carregando a informação
    loading = true;

    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email.trim(), password: user.password);

      // Salvando o usuário atual
      this.user = result.user;

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }

    loading = false;
  }

  // Método para salvar os dados do User no Firebase
  Future<void> signUp({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email.trim(), password: user.password);

      this.user = result.user;

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    // Retornando o usuário que estar logado
    final FirebaseUser currentUser = await auth.currentUser();
    // Verificando o usuario atual
    if(currentUser != null){
      user = currentUser;
    }
    notifyListeners();
  }

}