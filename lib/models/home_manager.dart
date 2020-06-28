import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  // Carregando todas as seções
  HomeManager() {
    _loadSections();
  }

  // Criando a lista de seções
  List<Section> sections = [];

  // Acessando o FireStore
  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    // Habilitando o modo atualizar a tela do usuário instalaneamente quando houver alterações pelo o ADM
    firestore.collection('home').snapshots().listen((snapshot) {
      // Limpando a lista das seções
      sections.clear();
      // Acessando cada um dos documentos
      for (final DocumentSnapshot document in snapshot.documents) {
        // Criando uma nova seção
        sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }
}
