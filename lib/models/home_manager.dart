import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/section.dart';

class HomeManager extends ChangeNotifier {
  // Carregando todas as seções
  HomeManager() {
    _loadSections();
  }

  // Criando a lista de seções
  final List<Section> _sections = [];

  // Clonando a seção
  List<Section> _editingSections = [];

  // Informando se estar no modo de edição
  bool editing = false;

  // Informando que esta salvando
  bool loading = false;

  // Acessando o FireStore
  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    // Habilitando o modo atualizar a tela do usuário instalaneamente quando houver alterações pelo o ADM
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
      // Limpando a lista das seções
      _sections.clear();
      // Acessando cada um dos documentos
      for (final DocumentSnapshot document in snapshot.documents) {
        // Criando uma nova seção
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  // Função para criar uma nova seção
  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  // Removendo uma seção
  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  // Função para verificar em qual modo estar
  List<Section> get sections {
    if (editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  // Função para quando for entrar no modo de edição
  void enterEditing() {
    editing = true;

    _editingSections = _sections.map((s) => s.clone()).cast<Section>().toList();

    notifyListeners();
  }

  Future<void> saveEditing() async {
    bool valid = true;
    // Verificando se todos os dados são validos
    for (final section in _editingSections) {
      if (!section.valid()) valid = false;
    }
    // Verificando se tudo é valido
    if (!valid) return;

    // Informando que esta salvando
    loading = true;
    notifyListeners();

    // Setando a variavel da posição
    int pos = 0;

    // Passando por cada uma seção para ela se salvar
    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    // Removendo a seção e as imagens do banco de dados após salvo
    // Passando por todas a seções e conferindo se ela ainda existe
    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
