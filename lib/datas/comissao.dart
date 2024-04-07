import 'dart:convert';

import '../models/comissao.dart';
import '../http/cliente_http.dart';
import '../http/erros_http.dart';

abstract class ComissaoInterface {
  Future<List<Comissao>> getComissoes();
}

class ComissaoDatas implements ComissaoInterface {
  final HttpInterface cliente;

  ComissaoDatas({required this.cliente});

  Future<Map<String, dynamic>> getComissaoDetalhes(int id) async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes/$id',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> getComissaoDeputados(int id) async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes/$id/membros',
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['dados'];
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Future<List<Comissao>> getComissoes() async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/frentes',
    );

    if (response.statusCode == 200) {
      final List<Comissao> comissoes = [];
      final body = jsonDecode(response.body);

      body['dados'].map((comissao) {
        comissoes.add(Comissao.fromMap(comissao));
      }).toList();

      return comissoes;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
