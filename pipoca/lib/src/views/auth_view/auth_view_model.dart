import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:stacked/stacked.dart';

class AuthViewModel extends ReactiveViewModel {
  /* LOCATOR */

  final _authenticationService = locator<AuthenticationService>();
  final _localStorage = locator<SharedLocalStorageService>();
  bool get loggedIn => _authenticationService.loggedIn;
  String get token => _authenticationService.token;

  Future getToken() async {
    setBusy(true);

    await _authenticationService.getToken();
    setBusy(false);
  }

  Future logout() async {
    await _localStorage.clear();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authenticationService];
}
