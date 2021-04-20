import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.router.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainDrawerViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();

  User get user => _userService.user;

  Future logout() async {
    setBusy(true);
    var result =
        await _authenticationService.logout(_authenticationService.token);
    if (result.status == Status.COMPLETED) {
      _userService.logoutUser();
      return _navigationService.clearTillFirstAndShow(Routes.loginView);
    }
    if (result.status == Status.ERROR) {
   await _dialogService.showDialog(
          title: 'Login', description: '${result.message}', buttonTitle: 'Ok');
    }

    setBusy(false);
  }
}
