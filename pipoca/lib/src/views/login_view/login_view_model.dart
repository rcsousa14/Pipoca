import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:pipoca/src/app/router.gr.dart';

class LoginViewModel extends BaseViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  Future fbLogin() async {
    setBusy(true);
    var result = await _authenticationService.loginWithFB();
    if (result is bool) {
      if (result) {
        assert(_authenticationService.currentUser != null);
        _navigationService.replaceWith(Routes.mainView);
      } else {
        await _dialogService.showDialog(
          title: 'Login',
          description:
              'Ocorreu um erro na função de registo, tente novamente! \n\n $result',
          buttonTitle: 'ok',
        );
        setBusy(false);
      }
    } else {
      await _dialogService.showDialog(
        title: '${result.localizedTitle}',
        description:
            'Ocorreu um erro na função de registo, tente novamente! \n\n${result.localizedDescription}',
        buttonTitle: 'ok',
      );
      setBusy(false);
    }

    setBusy(false);
  }

  Future loginWithGoogle() async {
    setBusy(true);
    var result = await _authenticationService.signInWithGoogle();
    if (result is bool) {
      if (result) {
        assert(_authenticationService.currentUser != null);
        _navigationService.replaceWith(Routes.mainView);
      } else {
        await _dialogService.showDialog(
          title: 'Login',
          description:
              'Ocorreu um erro na função de registo, tente novamente! \n\n $result',
          buttonTitle: 'ok',
        );
        setBusy(false);
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login',
        description:
            'Ocorreu um erro na função de registo, tente novamente! \n\n$result',
        buttonTitle: 'ok',
      );
      setBusy(false);
    }

    setBusy(false);
  }

  Future logout() async {
    await _authenticationService.signout();
  }
}
