import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked/stacked.dart';

import 'app/locator.dart';

class AppViewModel extends FutureViewModel<Auth> {
  final _authenticationService = locator<AuthenticationService>();

  bool get loggedIn => _authenticationService.loggedIn;

  getToken() => _authenticationService.getToken();



  @override
  Future<Auth> futureToRun() => _authenticationService.getToken();

// check on the shared preferences if there is a token or not then either go to login or main
  /* NAVIGATION KEY */

}
