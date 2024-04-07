import 'package:flutter/material.dart';
import 'package:deputados/datas/ocupacao.dart';
import 'package:deputados/http/erros_http.dart';

import '../models/ocupacao.dart';

class OcupacaoAdd {
  final OcupacaoDatas datas;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Ocupacao>> state = ValueNotifier<List<Ocupacao>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  OcupacaoAdd({required this.datas});

  Future getOcupacoes(int id) async {
    isLoading.value = true;
    try {
      final result = await datas.getOcupacoes(id);
      state.value = result;
    } on NotFoundException catch (e) {
      error.value = e.message;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
