import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/models/address.dart';

class User {
  User({this.email, this.password, this.name, this.id});

  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    email = document.data['email'] as String;

    // Verificando se o endereço esta sendo usando
    if (document.data.containsKey('address')) {
      address =
          Address.fromMap(document.data['address'] as Map<String, dynamic>);
    }
  }

  String id;
  String name;
  String email;
  String password;

  String confirmPassword;

  bool admin = false;

  Address address;

  // Referenciando os dodos
  DocumentReference get firestoreRef =>
      Firestore.instance.document('users/$id');

  // Referenciando a coleção do usuário
  CollectionReference get cartReference => firestoreRef.collection('cart');

  // Salvando os dados do usuário
  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  // Recuperando os dados do usuário e transformando em um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      // Verificando seu o endereço é diferente de nulo
      if (address != null)
        'address': address.toMap(),
    };
  }

  // Setando o endereço para usar em outras partes app
  void setAddress(Address address) {
    this.address = address;

    // Salvando no banco de dados
    saveData();
  }
}