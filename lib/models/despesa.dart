
class Despesa {

  final int year;
  final int month;
  final String type;
  final int documentCode;
  final String documentType;
  final String documentDate;
  final String documentNumber;
  final double documentValue;
  final String documentUrl;
  final String providerName;
  final String providerCnpj;

  Despesa({

    required this.year,
    required this.month,
    required this.type,
    required this.documentCode,
    required this.documentType,
    required this.documentDate,
    required this.documentNumber,
    required this.documentValue,
    required this.documentUrl,
    required this.providerName,
    required this.providerCnpj,

  });

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      year: map['ano'] ?? 0,
      month: map['mes'] ?? 0,
      type: map['tipoDespesa'] ?? '',
      documentCode: map['codDocumento'] ?? 0,
      documentType: map['tipoDocumento'] ?? '',
      documentDate: map['dataDocumento'] ?? '',
      documentNumber: map['numDocumento'] ?? '',
      documentValue: map['valorDocumento'] ?? 0.0,
      documentUrl: map['urlDocumento'] ?? '',
      providerName: map['nomeFornecedor'] ?? '',
      providerCnpj: map['cnpjCpfFornecedor'] ?? '',
    );
  }
}