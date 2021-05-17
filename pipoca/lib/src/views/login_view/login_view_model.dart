import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.router.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/repositories/user/auth_repository.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _socialRepo = locator<SocialRepository>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();

  getTokenNow() => _authenticationService.getToken();

  Future facebook() async {
    setBusy(true);

    try {
      var response = await _socialRepo.facebook('something');
      if (response is UserAuth) {
        return response;
      } else {
        _dialogService.showDialog(
            title: 'Login', description: '$response', buttonTitle: 'Ok');
        setBusy(false);
      }
    } catch (e) {
      await _dialogService.showDialog(
          title: 'Login do Facebook',
          description: 'Verifique sua conexão de internet',
          buttonTitle: 'Ok');
      setBusy(false);
    }
  }

  Future google() async {
    setBusy(true);

    try {
      var response = await _socialRepo.google('something');
      if (response is UserAuth) {
        return response;
      } else {
        _dialogService.showDialog(
            title: 'Login', description: '$response', buttonTitle: 'Ok');
        setBusy(false);
      }
    } catch (e) {
      await _dialogService.showDialog(
          title: 'Login',
          description:
              'Login cancelado pelo usuário.\nVerifique sua conexão de internet.',
          buttonTitle: 'Ok');
      setBusy(false);
    }
  }

  Future getToken(UserAuth body) async {
    var result = await _authenticationService.social(body);
    switch (result.status) {
      case Status.STOP:
      case Status.LOADING:
        break;
      case Status.COMPLETED:
        await getUser();
        break;
      case Status.ERROR:
        await _dialogService.showDialog(
            title: 'Login',
            description: '${result.message}',
            buttonTitle: 'Ok');
        setBusy(false);
        break;
    }
  }

  Future getUser() async {
    var result = await _userService.fetchUser();
    switch (result.status) {
       case Status.STOP:
      case Status.LOADING:
        break;
      case Status.COMPLETED:
     
         await _navigationService.navigateTo(Routes.mainView);
        break;
      case Status.ERROR:
        await _dialogService.showDialog(
            title: 'Login',
            description: '${result.message}',
            buttonTitle: 'Ok');
        setBusy(false);

        break;
    }
  }

  Future showError(String? message) async {
    await _dialogService.showDialog(
        title: 'Erro', description: '$message', buttonTitle: 'Ok');
  }
}
