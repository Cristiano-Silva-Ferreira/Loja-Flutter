import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lojavirtual/models/cepaberto_address.dart';

const token = 'df7c075b9462a096eed5045a6f7a890a';

class CepAbertoService {
  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    // Limpando o campo do CEP retirando ponto e traços
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    // Acessando o endpoint
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    // Utilizando o Token de acesso
    final Dio dio = Dio();

    // Especificando o Token
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {
      // Verificando se houver algum retorno
      final response = await dio.get<Map<String, dynamic>>(endpoint);

      if (response.data.isEmpty) {
        return Future.error('CEP Inválido');
      }

      // Obtendo o Address
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      // Retornando o Address
      return address;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
