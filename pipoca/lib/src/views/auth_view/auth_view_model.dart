import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.router.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthViewModel extends ReactiveViewModel {
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();
  final _userService = locator<UserService>();
  bool get loggedIn => _authenticationService.loggedIn;

  Future resetToken() async {
    await Future.delayed(Duration(seconds: 2));
    var result = await _authenticationService.resetToken();

    switch (result.status) {
       case Status.STOP:
      case Status.LOADING:
        print('loading');
        setBusy(true);
        break;
      case Status.COMPLETED:
       
       return await getUser();
       
      case Status.ERROR:
        await _dialogService.showDialog(
            title: 'Autenticação',
            description: '${result.message}',
            buttonTitle: 'Tentar Novamente');
        await resetToken();
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
       return  _navigationService.navigateTo(Routes.mainView);
       
      case Status.ERROR:
        setBusy(false);
        return _navigationService.navigateTo(Routes.loginView,
            arguments: LoginViewArguments(message: '${result.message}'));
        
    }
  }

  Future goToLogin() async {
    Future.delayed(Duration(milliseconds: 500));
    
    return _navigationService.replaceWith(Routes.loginView, arguments: LoginViewArguments(message: ''));
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_authenticationService];
}
