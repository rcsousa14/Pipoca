import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MainDrawerViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  Future logout() async {
    setBusy(true);
    await Future.delayed(Duration(seconds: 3));
    
    var result = await _authenticationService.signout();
    if (result is String) {
      if (result.isNotEmpty) {
        return await _dialogService.showDialog(
            title: 'Erro',
            description: 'Ocorreu um erro na função de logout! \n $result');
      }
      setBusy(false);
    } else {
      await _navigationService.clearStackAndShow(Routes.loginView);
    }
    setBusy(false);
  }

  Usuario get user => _userService.user;
  String get errorMsg => _userService.error;
}
