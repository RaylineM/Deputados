import 'package:flutter/material.dart';
import 'package:deputados/datas/despesa.dart';
import 'package:deputados/http/erros_http.dart';
import '../models/despesa.dart';

class DespesaAdd {
  final DespesaDatas datas;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Despesa>> state = ValueNotifier<List<Despesa>>([]);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  DespesaAdd({required this.datas});

  Future getDespesas(int id, int year, int month) async {
    isLoading.value = true;
    try {
      final result = await datas.getDespesas(id, year, month);
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
