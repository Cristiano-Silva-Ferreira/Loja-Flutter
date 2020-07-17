import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/item_size.dart';
import 'package:uuid/uuid.dart';

class Product extends ChangeNotifier {
  Product({this.id, this.name, this.description, this.images, this.sizes}) {
    images = images ?? [];
    sizes = sizes ?? [];
  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;

    // Transformando uma lista dinâmica em lista de string
    images = List<String>.from(document.data['images'] as List<dynamic>);

    // Pegando o tamanho das camisetas
    sizes = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Recebendo a referência do documento existente
  DocumentReference get firestoreRef => firestore.document('products/$id');

  StorageReference get storageRef => storage.ref().child('products').child(id);

  // Declarando os dados do FireBase
  String id;
  String name;
  String description;
  List<String> images;
  List<ItemSize> sizes;

  List<dynamic> newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ItemSize _selectedSize;

  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  // Verificando a quantidade total do estoque
  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  // Verificando se tem item no estoque
  bool get hasStock {
    return totalStock > 0;
  }

  // Configurando a base do preço e achando o menor preço
  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  // Exportando a lista com os tamanhos
  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  // Salvando no Firebase os produtos
  Future<void> save() async {
    loading = true;

    // Transformando os dados do produto em um mapa
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    // Verificando se o produto já existe ou se é novo
    if (id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      // Atualizando os dados do produto existente
      await firestoreRef.updateData(data);
    }

    // Atualizando a lista de imagem
    final List<String> updateImages = [];

    // Precorrendo cada elemento do newImage e verificar se esta no image
    for (final newImage in newImages) {
      // Verificando se o image contém a image
      if (images.contains(newImage)) {
        // Caso a imagem esteja contida no URL newImage adiciona ela no updateImage
        updateImages.add(newImage as String);
      } else { // Caso não esteja contida
        // Acessando a pasta do produto e gerando uma chave única
        final StorageUploadTask task = storageRef.child(Uuid().v1())
            .putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        // Obtendo a URL da imagem
        final String url = await snapshot.ref.getDownloadURL() as String;
        // Adicionando a URL da imagem no firebase
        updateImages.add(url);
      }
    }

    // Verficando se cada uma das imagens existe no newImage
    for (final image in images) {
      // Verificando se não existe mais a imagem
      if (!newImages.contains(image)) {
        try {
          // Recebendo a referência da imagem
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    // Salvando a lista de products no images
    await firestoreRef.updateData({'images': updateImages});

    // Copiando o updateImages para o images
    images = updateImages;

    loading = false;
  }

  // Metodo para clonar o produto
  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, '
        'images: $images, sizes: $sizes, newImages: $newImages}';
  }
}