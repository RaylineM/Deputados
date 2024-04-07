import 'package:deputados/datas/deputado.dart';
import 'package:deputados/http/erros_http.dart';
import 'package:flutter/material.dart';

import '../models/deputado.dart';

class DeputadoAdd {
  final DeputadoDatas datas;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Deputado>> state = ValueNotifier<List<Deputado>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  DeputadoAdd({required this.datas});

  Future getDeputados() async {
    isLoading.value = true;

    try {
      final result = await datas.getDeputados();
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
