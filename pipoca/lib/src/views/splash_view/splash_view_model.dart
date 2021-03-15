import 'package:location/location.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/push_notification_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _currentLocation = locator<LocationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  // final _dynamicLinkService = locator<DynamicLinkService>();

  Future handleStartUpLogic() async {
    Future.delayed(const Duration(seconds: 3), () async {
      //await _dynamicLinkService.handleDynamicLink();
      await _pushNotificationService.initialise();
      var permission = await _currentLocation.location.hasPermission();
      if (permission == PermissionStatus.granted) {
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
}
