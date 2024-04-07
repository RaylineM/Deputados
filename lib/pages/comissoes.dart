import 'package:flutter/material.dart';
import '../models/comissao.dart';
import '../datas/comissao.dart';
import '../Add/comissao.dart';
import '../http/cliente_http.dart';

import 'package:deputados/routes/rota.dart' as routes;

class Comissoes extends StatefulWidget {
  const Comissoes({Key? key}) : super(key: key);

  @override
  State<Comissoes> createState() => _ComissoesState();
}

class _ComissoesState extends State<Comissoes> {
  final ComissaoAdd add = ComissaoAdd(datas: ComissaoDatas(cliente: HttpCliente()));

  @override
  void initState() {
    super.initState();
    add.getComissoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Comissões',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation: add.isLoading,
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

          return ListView.builder(
            itemCount: add.state.value.length,
            itemBuilder: (context, index) {
              final Comissao comissao = add.state.value[index];
              return Card(
                margin: const EdgeInsets.all(8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showComissaoDetails(context, comissao),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comissao.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, routes.home);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }

  void _showComissaoDetails(BuildContext context, Comissao comissao) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.deepOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comissao.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: add.datas.getComissaoDetalhes(comissao.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    final Map<String, dynamic> details =
                        snapshot.data as Map<String, dynamic>;
                    return _buildComissaoDetails(details);
                  },
                ),
                FutureBuilder(
                  future: add.datas.getComissaoDeputados(comissao.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    final List<dynamic> deputados =
                        snapshot.data as List<dynamic>;
                    return _buildDeputadosList(deputados);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComissaoDetails(Map<String, dynamic> details) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalhes',
            style: TextStyle(
                color: Color.fromARGB(255, 18, 18, 18),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Titulo: ${details['dados']['titulo']}',
            style: const TextStyle(
                color: Color.fromARGB(255, 20, 20, 20), fontWeight: FontWeight.bold),
          ),
          Text(
            'Telefone: ${details['dados']['telefone']}',
            style: const TextStyle(
                color: Color.fromARGB(255, 17, 17, 17), fontWeight: FontWeight.bold),
          ),
          Text(
            'Email: ${details['dados']['email']}',
            style: const TextStyle(
                color: Color.fromARGB(255, 21, 20, 20), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDeputadosList(List<dynamic> deputados) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200], 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Membros',
            style: TextStyle(
                color: Color.fromARGB(255, 23, 23, 23),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (var deputado in deputados)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(deputado['urlFoto']),
                    radius: 20, 
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deputado['nome'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${deputado['titulo']} - ${deputado['siglaPartido']} - ${deputado['siglaUf']}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}