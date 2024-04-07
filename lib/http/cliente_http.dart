import 'package:http/http.dart' as http;

abstract class HttpInterface {
  Future get({required String url});
}

class HttpCliente implements HttpInterface {
  final cliente = http.Client();

  @override
  Future get({required String url}) async {
    return await cliente.get(Uri.parse(url));
  }
}
