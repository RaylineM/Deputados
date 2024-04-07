import 'package:deputados/Add/deputado.dart';
import 'package:deputados/datas/deputado.dart';
import 'package:flutter/material.dart';

import '../http/cliente_http.dart';
import '../models/deputado.dart';
import '../routes/rota.dart' as routes;

class Deputados extends StatefulWidget {
  const Deputados({Key? key}) : super(key: key);

  @override
  State<Deputados> createState() => _DeputadosState();
}

class _DeputadosState extends State<Deputados> {
  final DeputadoAdd add = DeputadoAdd(
    datas: DeputadoDatas(
      cliente: HttpCliente(),
    ),
  );

  String query = '';

  @override
  void initState() {
    super.initState();
    add.getDeputados();
  }

  List<Deputado> filterDeputados(List<Deputado> deputados) {
    return deputados
        .where((deputado) =>
            deputado.name.toLowerCase().contains(query.toLowerCase()) ||
            deputado.party.toLowerCase().contains(query.toLowerCase()) ||
            deputado.uf.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Deputados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange, 
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25), 
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar Deputados...',
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              onChanged: (value) => setState(() {
                query = value;
              }),
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge(
          [
            add.isLoading,
            add.state,
            add.error,
          ],
        ),
        builder: (context, child) {
          if (add.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            );
          }

          if (add.error.value.isNotEmpty) {
            return Center(
              child: Text(add.error.value),
            );
          }

          if (add.state.value.isEmpty) {
            return const Center(
              child: Text('Nenhum deputado encontrado.'),
            );
          }

          final filteredDeputados = filterDeputados(add.state.value);

          return ListView.builder(
            itemCount: filteredDeputados.length,
            itemBuilder: (context, index) {
              final deputado = filteredDeputados[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    routes.deputado,
                    arguments: deputado,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white, 
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), 
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), 
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.deepOrange,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              deputado.photo,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.black, 
                            fontSize: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deputado.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${deputado.party} - ${deputado.uf}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
