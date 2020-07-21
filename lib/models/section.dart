import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/section_item.dart';
import 'package:uuid/uuid.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document.data['name'] as String;
    type = document.data['type'] as String;
    // Obtendo os itens do documento é transformando na lista de itens
    items = (document.data['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.document('home/$id');

  StorageReference get storageRef => storage.ref().child('home/$id');

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;

  String get error => _error;

  set error(String value) {
    _error = value;
    notifyListeners();
  }

  // Adicionando um novo item
  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  // Função para salvamento
  Future<void> save(int pos) async {
    // Transformandos os dados em um mapa
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'pos': pos,
    };

    // Verificando se a seção já existe ou é uma nova
    if (id == null) {
      // Se a seção for nula adiciona a nova seção
      final doc = await firestore.collection('home').add(data);
      id = doc.documentID;

      // Caso a seção exista atualizar suas informações
    } else {
      await firestoreRef.updateData(data);
    }

    // Percorrendo os items atuais
    for (final item in items) {
      // Verificando o tipo da imagem se for um arquivo => FILE
      if (item.image is File) {
        // Criando um item no Storage
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(item.image as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        item.image = url;
      }
    }

    // Verificando se excluiu algum item
    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref =
              await storage.getReferenceFromUrl(original.image as String);
          await ref.delete();
          // ignore: empty_catches
        } catch (e) {}
      }
    }

    // Salvando a URL dos items no FireStore
    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.updateData(itemsData);
  }

  // Deletendo as imagens e a seções
  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      try {
        final ref = await storage.getReferenceFromUrl(item.image as String);
        await ref.delete();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  // Removendo item
  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  // Verificando a validação da seção
  bool valid() {
    // Verificando se nome estar vázio
    if (name == null || name.isEmpty) {
      error = 'Título inválido';

      // Verificando se tem alguma imagem valida
    } else if (items.isEmpty) {
      error = 'Insirar ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  // Clonando a seção
  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
