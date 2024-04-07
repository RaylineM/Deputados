import 'dart:convert';

import '../http/cliente_http.dart';
import '../http/erros_http.dart';
import '../models/despesa.dart';

abstract class DespesaInterface {
  Future<List<Despesa>> getDespesas(int id, int year, int month);
}

class DespesaDatas implements DespesaInterface {
  final HttpInterface cliente;

  DespesaDatas({required this.cliente});

  @override
  Future<List<Despesa>> getDespesas(int id, int year, int month) async {
    final response = await cliente.get(
      url:
          'https://dadosabertos.camara.leg.br/api/v2/deputados/$id/despesas?ano=&mes=$month',
    );

    if (response.statusCode == 200) {
      final List<Despesa> despesas = [];
      final body = jsonDecode(response.body);

      body['dados'].map((despesa) {
        despesas.add(Despesa.fromMap(despesa));
      }).toList();

      return despesas;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
