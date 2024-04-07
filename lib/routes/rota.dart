import 'package:deputados/pages/comissoes.dart';
import 'package:deputados/pages/deputados.dart';
import 'package:flutter/material.dart';

import '../models/deputado.dart';
import '../pages/deputado_detalhes.dart';
import '../pages/home.dart';

const String home = '/';
const String deputados = '/deputados';
const String deputado = '/deputado';
const String comissoes = '/comissoes';

Route controller(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Home());
    case '/deputados':
      return MaterialPageRoute(builder: (context) => const Deputados());
    case '/deputado':
      return MaterialPageRoute(
          builder: (context) =>
              DeputadoDetalhes(deputado: settings.arguments as Deputado));
    case '/comissoes':
      return MaterialPageRoute(builder: (context) => const Comissoes());
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}
