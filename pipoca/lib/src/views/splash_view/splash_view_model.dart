import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();

  /* LOCATION CHECK CANNOT USE THE APP WITHOUT IT*/

  Future<dynamic> locationCheck() async {
    Future.delayed(const Duration(seconds: 3), () async {
      var result = await _authenticationService.isUserLoggedIn();
      print(result);
      // return _navigationService.replaceWith(Routes.loginView);
    });
  }
}
