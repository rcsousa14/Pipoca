import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/constants/api_helpers/app_exception.dart';
import 'package:pipoca/src/interfaces/repository_interface.dart';

@lazySingleton
class ApiBaseHelper implements IRepository {
  final _client = http.Client(
    
  );
  Client get client => _client;

  final String _heroku = "https://pipoca-ao.herokuapp.com/v1";

  @override
  Future delete(
      {required String query, required Map<String, String> header}) async {
    var responseJson;
    try {
      var uri = Uri.encodeFull('$_heroku/$query');
      var url = Uri.parse(uri);
      var response = await client.delete(url, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Sem conexão com a Internet🌐');
    } on HttpException {
      throw FetchDataException('O que procuras não existe🤷');
    } on FormatException {
      throw FetchDataException('Formato de resposta ruim📛');
    } on TimeoutException {
      throw FetchDataException('O pedido demorou muito.⏲️ Tente novamente!');
    } on IOException {
      throw FetchDataException('Erro desconhecido.🤷 Tente novamente!');
    }on ClientException {
      throw FetchDataException(
          'Conexão com o servidor fechada.⏲️ Tente novamente!');
    }
    return responseJson;
  }

  @override
  Future get(
      {required String query, required Map<String, String> header}) async {
    var responseJson;
    try {
      var uri = Uri.encodeFull('$_heroku/$query');
      var url = Uri.parse(uri);

      var response = await client.get(url, headers: header);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Sem conexão com a Internet🌐');
    } on HttpException {
      throw FetchDataException('O que procuras não existe🤷');
    } on FormatException {
      throw FetchDataException('Formato de resposta ruim📛');
    } on TimeoutException {
      throw FetchDataException('O pedido demorou muito.⏲️ Tente novamente!');
    } on IOException {
      throw FetchDataException('Erro desconhecido.🤷 Tente novamente!');
    }on ClientException {
      throw FetchDataException(
          'Conexão com o servidor fechada.⏲️ Tente novamente!');
    }
    return responseJson;
  }

  @override
  Future patch(
      {required String query,
      required Map<String, String> header,
      body}) async {
    var responseJson;
    try {
      var uri = Uri.encodeFull('$_heroku/$query');
      var url = Uri.parse(uri);
      var response = await client.patch(url,
          headers: header,
          body: body != null ? json.encode(body.toJson()) : null);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Sem conexão com a Internet🌐');
    } on HttpException {
      throw FetchDataException('O que procuras não existe🤷');
    } on FormatException {
      throw FetchDataException('Formato de resposta ruim📛');
    } on TimeoutException {
      throw FetchDataException('O pedido demorou muito.⏲️ Tente novamente!');
    } on IOException {
      throw FetchDataException('Erro desconhecido.🤷 Tente novamente!');
    }on ClientException {
      throw FetchDataException(
          'Conexão com o servidor fechada.⏲️ Tente novamente!');
    }
    return responseJson;
  }

  @override
  Future post(
      {required String query,
      required Map<String, String> header,
      body}) async {
    var responseJson;
    try {
      var uri = Uri.encodeFull('$_heroku/$query');
      var url = Uri.parse(uri);
      var response = await client.post(url,
          headers: header,
          body: body != null ? json.encode(body.toJson()) : null);

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Sem conexão com a Internet🌐');
    } on HttpException {
      throw FetchDataException('O que procuras não existe🤷');
    } on FormatException {
      throw FetchDataException('Formato de resposta ruim📛');
    } on TimeoutException {
      throw FetchDataException('O pedido demorou muito.⏲️ Tente novamente!');
    } on IOException {
      throw FetchDataException('Erro desconhecido.🤷 Tente novamente!');
    } on ClientException {
      throw FetchDataException(
          'Conexão com o servidor fechada.⏲️ Tente novamente!');
    }
    return responseJson;
  }

  @override
  Future put(
      {required String query,
      required Map<String, String> header,
      body}) async {
    var responseJson;
    try {
      var uri = Uri.encodeFull('$_heroku/$query');
      var url = Uri.parse(uri);
      var response = await client.put(url,
          headers: header,
          body: body != null ? json.encode(body.toJson()) : null);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Sem conexão com a Internet🌐');
    } on HttpException {
      throw FetchDataException('O que procuras não existe🤷');
    } on FormatException {
      throw FetchDataException('Formato de resposta ruim📛');
    } on TimeoutException {
      throw FetchDataException('O pedido demorou muito.⏲️ Tente novamente!');
    } on IOException {
      throw FetchDataException('Erro desconhecido.🤷 Tente novamente!');
    }on ClientException {
      throw FetchDataException(
          'Conexão com o servidor fechada.⏲️ Tente novamente!');
    } 
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    var msg = json.decode(response.body.toString());
    print(response.statusCode);
    switch (response.statusCode) {
      case 201:
      case 200:
        var responseJson = json.decode(response.body);

        return responseJson;
      case 400:
        throw BadRequestException(msg['message']);
      case 401:
      case 403:
        throw UnauthorisedException(msg['message']);
      case 500:
      default:
        throw FetchDataException(
            'Ocorreu um erro durante a comunicação com o servidor com código : ${response.statusCode}');
    }
  }
}
