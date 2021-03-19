import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/repositories/user/user_repository.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'authentication_service.dart';

@lazySingleton
class UserService {
  final _api = locator<UserRepository>();
  final _authenticationService = locator<AuthenticationService>();
  final _localStorage = locator<SharedLocalStorageService>();

  String _error;
  Usuario _usuario;
  Usuario get user => _usuario;
  String get error => _error; 

  Future<Usuario> getUser() async {
    _usuario = await _api.getUser();
    if (_usuario == null) {
      int id = await _localStorage.recieve('id');
      var result = await _authenticationService.refreshToken(
          currentToken: _authenticationService.currentToken, id: id);
      if (result is bool) {
        if (result) {
          _usuario = await _api.getUser();
          return _usuario;
        }
      }
      _error = result; 
      throw result;
    }
    return _usuario;
  }
}
