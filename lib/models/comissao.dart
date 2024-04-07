class Comissao {
  final int id;
  final String uri;
  final String title;
  final int legislature;
  

  late final Map<String, dynamic> detalhes;
  late final List<dynamic> deputados;

  Comissao({
    required this.id,
    required this.uri,
    required this.title,
    required this.legislature,
    this.detalhes = const {},
    this.deputados = const [],
  });

  factory Comissao.fromMap(Map<String, dynamic> map) {
    return Comissao(
      id: map['id'],
      uri: map['uri'],
      title: map['titulo'],
      legislature: map['idLegislatura'],
    );
  }
}
