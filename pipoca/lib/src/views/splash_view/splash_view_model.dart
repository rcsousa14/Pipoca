import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/dynamicLink_service.dart';
import 'package:pipoca/src/services/push_notification_service.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  //final _pushNotificationService = locator<PushNotificationService>();
  // final _dynamicLinkService = locator<DynamicLinkService>();

  Future handleStartUpLogic() async {
    //await _dynamicLinkService.handleDynamicLink();
    // await _pushNotificationService.initialise();
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
    print(hasLoggedInUser);
    if (hasLoggedInUser) {
      
      return await _navigationService.navigateTo(Routes.mainView);
    } else {
      
       return await _navigationService.navigateTo(Routes.loginView);
    }
  }
}
