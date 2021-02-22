import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@lazySingleton
class ApiHeaders {
  final _client = http.Client();
  Client get client => _client;

  setTokenHeaders({String token}) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      
  setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
