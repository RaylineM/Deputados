import 'dart:convert';
import '../models/deputado_detalhes.dart';
import '../http/cliente_http.dart';
import '../http/erros_http.dart';

abstract class DeputadoDetalhesInterface {
  Future<DeputadoDetalhes> getDeputado(int id);
}

class DeputadoDetalhesDatas implements DeputadoDetalhesInterface {
  final HttpInterface cliente;

  DeputadoDetalhesDatas({required this.cliente});

  @override
  Future<DeputadoDetalhes> getDeputado(int id) async {
    final response = await cliente.get(
      url: 'https://dadosabertos.camara.leg.br/api/v2/deputados/$id',
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return DeputadoDetalhes.fromMap(body['dados']);
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não foi encontrada');
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
