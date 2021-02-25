import 'package:injectable/injectable.dart';

@lazySingleton
class ValidationService {
  String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";

    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return '📧 Digite email ';
    } else if (!regExp.hasMatch(value)) {
      return '📧 Digite o email correctamente';
    }
    return null;
  }

  String validatePass(String value) {
    String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return '🔐 A senha não pode estar vazia';
    } else if (!regExp.hasMatch(value)) {
      return '🔓 8 caracteres, [Aa-zZ], [0-9]';
    }
    return null;
  }

  String validateUsername(String value) {
    String pattern = r"^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,20}$";
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return '😞 O nome de usuário não pode estar vazio';
    } else if (value.length > 20) {
      return '😱 Nome do usuário é muito grande!';
    } else if (!regExp.hasMatch(value)) {
      return '🤿 [a-z A-Z 0-9] (.) e (_)';
    }
    return null;
  }
}
