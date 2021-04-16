

class AppException implements Exception {
  final _message; 
  final _prefix; 

  AppException([this._message, this._prefix]);

  @override
    String toString() {
      return "$_prefix$_message";
    }
}

 
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Erro durante a comunicação: ");
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Pedido Inválido: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, "Não Autorizado: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Entrada Inválida: ");
}
