import 'package:flutter/material.dart';
import 'package:deputados/datas/comissao.dart';
import 'package:deputados/http/erros_http.dart';
import '../models/comissao.dart';

class ComissaoAdd {
  final ComissaoDatas datas;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Comissao>> state = ValueNotifier<List<Comissao>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ComissaoAdd({required this.datas});

  Future getComissoes() async {
    isLoading.value = true;

    try {
      final result = await datas.getComissoes();
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
