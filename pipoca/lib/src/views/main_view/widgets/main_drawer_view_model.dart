import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';

class MainDrawerViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _userService = locator<UserService>();

  User get user => _userService.user;

  Future logout() async {
    setBusy(true);
    await _authenticationService.logout();
    _userService.logoutUser();

    setBusy(false);
  }
}
