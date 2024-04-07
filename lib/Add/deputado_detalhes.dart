import 'package:deputados/datas/deputado_detalhes.dart';
import 'package:flutter/material.dart';

import '../models/deputado_detalhes.dart';

class DeputadoDetalhesAdd {
  final DeputadoDetalhesDatas datas;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<DeputadoDetalhes> state =
      ValueNotifier<DeputadoDetalhes>(DeputadoDetalhes());
  final ValueNotifier<String> error = ValueNotifier<String>('');

  DeputadoDetalhesAdd({required this.datas});

  Future getDeputadoDetalhes(int id) async {
    isLoading.value = true;
    try {
      final result = await datas.getDeputado(id);
      state.value = result;
    } on Exception catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
