// ignore_for_file: avoid_print

import 'dart:async';

import 'package:app_lista_de_contatos/models/contatos_model.dart';
import 'package:app_lista_de_contatos/respositories/back4app_custom_dio.dart';

class ContatosBack4appRepository {
  final _customDio = Back4appCustomDio();

  ContatosBack4appRepository();

  Future<ContatosModel> obterContatos() async {
    var url = "/Contato";
    var result = await _customDio.dio.get(url);
    return ContatosModel.fromJson(result.data);
  }

  Future<bool> cadastrarContato(ContatosResults contato) async {
    try {
      var url = "/Contato";
      // ignore: unused_local_variable
      var dados = contato.toJson();
      var response = await _customDio.dio.post(url, data: contato.toJson());
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> excluirContato(String id) async {
    try {
      var url = "/Contato/$id";
      var response = await _customDio.dio.delete(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> atualizarCadastro(ContatosResults contato) async {
    try {
      var url = "/Contato/${contato.objectId}";

      Map<String, dynamic> dados = {
        'nome': contato.nome,
        'telefone': contato.telefone,
        'email': contato.email,
        'endereco': contato.endereco,
        'photopath': contato.photopath,
      };

      print("URL da requisição: $url");
      print("Dados enviados: $dados");

      if (contato.objectId == null || contato.objectId!.isEmpty) {
        print("Erro: objectId está ausente.");
        return false;
      }

      var response = await _customDio.dio.put(url, data: dados);

      return response.statusCode == 200;
    } catch (e) {
      print("Erro ao atualizar Contato: $e");
      return false;
    }
  }
}
