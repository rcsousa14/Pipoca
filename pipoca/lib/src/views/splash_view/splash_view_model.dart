import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:location/location.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();
  final _userLocation = locator<LocationService>();
  final _authenticationService = locator<AuthenticationService>();

  /* LOCATION CHECK CANNOT USE THE APP WITHOUT IT*/
  Future<dynamic> locationCheck() async {
    Future.delayed(const Duration(seconds: 3), () async {
      var req = await _userLocation.location.hasPermission();
      if (req == PermissionStatus.granted) {
        var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
        if (hasLoggedInUser) {
          return _navigationService.replaceWith(Routes.mainView);
        } else {
          return _navigationService.replaceWith(Routes.loginView);
        }
      } else {
        return _navigationService.replaceWith(Routes.introView);
      }
    });
  }

  Future logout() async {
    await _authenticationService.signout();
  }
}
