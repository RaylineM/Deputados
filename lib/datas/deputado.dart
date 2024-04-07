import 'dart:convert';
import 'package:deputados/http/cliente_http.dart';
import '../models/deputado.dart';
import '../http/erros_http.dart';

abstract class DeputadoInterface {
  Future<List<Deputado>> getDeputados();
}

class DeputadoDatas implements DeputadoInterface {
  final HttpInterface cliente;

  DeputadoDatas({
    required this.cliente,
  });

  @override
  Future<List<Deputado>> getDeputados() async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados',
    );

    if (response.statusCode == 200) {
      final List<Deputado> deputados = [];
      final body = jsonDecode(response.body);

      body['dados'].map((deputado) {
        deputados.add(Deputado.fromMap(deputado));
      }).toList();

      return deputados;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
