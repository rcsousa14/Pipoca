import 'package:injectable/injectable.dart';

@lazySingleton
class ValidationService {
  String validateUsername(String value) {
    String pattern = r"^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{0,20}$";

    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "Nome de usuário é requerido!";
    } else if (value.length > 20) {
      return "😱 Nome do usuário é muito grande!";
    } else if (!regExp.hasMatch(value)) {
      return '🤷🏾‍♂️ alfanumérico, ponto (.) ou sublinhado (_)';
    }
    return null;
  }

  String validatePhone(String value) {
    String pattern =
        r"^[+]?(\d{1,3})?[\s.-]?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{3}$";
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return "📵 Telefone é requerido!";
    } else if (!regExp.hasMatch(value) || value.length > 9) {
      return "📵 Digite o número de telefone correto";
    }
    return null;
  }
}
