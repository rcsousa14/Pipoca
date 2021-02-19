import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';

@lazySingleton
class AuthenticationService {
  
  final _localStorage = locator<SharedLocalStorageService>();

  Future<bool> isUserLoggedIn() async {}

  Future _populateCurrentUser() async {}

  Future signout() async {}
}
