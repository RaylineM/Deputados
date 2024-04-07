import 'dart:convert';

import '../models/ocupacao.dart';
import '../http/cliente_http.dart';
import '../http/erros_http.dart';

abstract class OcupacaoInterface {
  Future<List<Ocupacao>> getOcupacoes(int id);
}

class OcupacaoDatas implements OcupacaoInterface {
  final HttpInterface cliente;

  OcupacaoDatas({required this.cliente});

  @override
  Future<List<Ocupacao>> getOcupacoes(int id) async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/ocupacoes',
    );

    if (response.statusCode == 200) {
      final List<Ocupacao> ocupacoes = [];
      final body = jsonDecode(response.body);

      body['dados'].map((ocupacao) {
        ocupacoes.add(Ocupacao.fromMap(ocupacao));
      }).toList();

      return ocupacoes;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
