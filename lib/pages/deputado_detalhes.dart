import 'package:flutter/material.dart';
import 'package:deputados/Add/deputado_detalhes.dart';
import 'package:deputados/Add/despesa.dart';
import 'package:deputados/Add/ocupacao.dart';
import 'package:deputados/models/deputado.dart';
import '../datas/deputado_detalhes.dart';
import '../datas/despesa.dart';
import '../datas/ocupacao.dart';
import '../http/cliente_http.dart';

class DeputadoDetalhes extends StatefulWidget {
  final Deputado deputado;
  const DeputadoDetalhes({Key? key, required this.deputado}) : super(key: key);

  @override
  State<DeputadoDetalhes> createState() => _DeputadoDetalhesState();
}

class _DeputadoDetalhesState extends State<DeputadoDetalhes> {
  final DeputadoDetalhesAdd detalhesAdd = DeputadoDetalhesAdd(
    datas: DeputadoDetalhesDatas(
      cliente: HttpCliente(),
    ),
  );

  final DespesaAdd despesaAdd = DespesaAdd(
    datas: DespesaDatas(
      cliente: HttpCliente(),
    ),
  );

  final OcupacaoAdd ocupacaoAdd = OcupacaoAdd(
    datas: OcupacaoDatas(
      cliente: HttpCliente(),
    ),
  );

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    detalhesAdd.getDeputadoDetalhes(widget.deputado.id);
    despesaAdd.getDespesas(widget.deputado.id, _selectedYear, _selectedMonth);
    ocupacaoAdd.getOcupacoes(widget.deputado.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes do Deputado',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepOrange, 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              _buildDeputadoDetails(),

              SizedBox(height: 24),

         
              _buildDespesas(),

              SizedBox(height: 24),

              
              _buildOcupacoes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeputadoDetails() {
    return ValueListenableBuilder(
      valueListenable: detalhesAdd.state,
      builder: (context, state, child) {
        if (detalhesAdd.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    widget.deputado.photo,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.deputado.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Partido: ${widget.deputado.party}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Estado: ${widget.deputado.uf}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16),

           
            Text(
              'Outras informações:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Legislatura: ${widget.deputado.legislature}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              'Email: ${widget.deputado.email}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              'URI: ${widget.deputado.uri}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDespesas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<int>(
              value: _selectedYear,
              items: List.generate(6, (index) {
                return DropdownMenuItem<int>(
                  value: DateTime.now().year - index,
                  child: Text('${DateTime.now().year - index}'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value!;
                });
                despesaAdd.getDespesas(widget.deputado.id, _selectedYear, _selectedMonth);
              },
            ),
            DropdownButton<int>(
              value: _selectedMonth,
              items: List.generate(12, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(_monthToString(index + 1)),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value!;
                });
                despesaAdd.getDespesas(widget.deputado.id, _selectedYear, _selectedMonth);
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: despesaAdd.state,
          builder: (context, state, child) {
            if (despesaAdd.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrange,
                ),
              );
            }

            if (despesaAdd.state.value.isEmpty) {
              return Text(
                'Nenhuma despesa encontrada',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Despesas:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: despesaAdd.state.value.map((despesa) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tipo: ${despesa.type}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Fornecedor: ${despesa.providerName}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Valor: ${despesa.documentValue}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Data: ${despesa.documentDate}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildOcupacoes() {
    return ValueListenableBuilder(
      valueListenable: ocupacaoAdd.state,
      builder: (context, state, child) {
        if (ocupacaoAdd.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        }

        if (ocupacaoAdd.state.value.isEmpty) {
          return Text(
            'Nenhuma ocupação encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ocupações:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ocupacaoAdd.state.value.map((ocupacao) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome: ${ocupacao.title}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Entidade: ${ocupacao.entity == '' ? 'Não informado' : ocupacao.entity}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Data de início: ${ocupacao.startYear == 'null' ? 'Não informado' : ocupacao.startYear}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Data de fim: ${ocupacao.startYear == 'null' && ocupacao.endYear == 'null' ? 'Não Informado' : ocupacao.endYear == 'null' ? 'Até o momento' : ocupacao.endYear}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  String _monthToString(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Janeiro';
      case 2:
        return 'Fevereiro';
      case 3:
        return 'Março';
      case 4:
        return 'Abril';
      case 5:
        return 'Maio';
      case 6:
        return 'Junho';
      case 7:
        return 'Julho';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setembro';
      case 10:
        return 'Outubro';
      case 11:
        return 'Novembro';
      case 12:
        return 'Dezembro';
      default:
        return 'Sem seleção';
    }
  }
}
