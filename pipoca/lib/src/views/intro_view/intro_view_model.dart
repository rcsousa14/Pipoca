import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as settings;
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class IntroViewModel extends BaseViewModel {
  /* LOCATORS*/
  final _currentLocation = locator<LocationService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();

  /* LOCATION CHECK CANNOT USE THE APP WITHOUT IT*/
  Future<dynamic> locationCheck() async {
    setBusy(true);
    var permission = await _currentLocation.location.hasPermission();
    if (permission == PermissionStatus.granted) {
      var hasLoggedInUser = await _authenticationService.isUserLoggedIn();
      if (hasLoggedInUser) {
        return _navigationService.replaceWith(Routes.mainView);
      } else {
        return _navigationService.replaceWith(Routes.loginView);
      }
    } else {
      DialogResponse response = await _dialogService.showDialog(
          title: 'Localização',
          description:
              'Parece que não deu-nos permissão para sua localização.\nVá para as configurações do aplicativo para isso!',
          buttonTitle: 'ok',
          cancelTitle: 'Não');
      if (response?.confirmed == true) {
        await settings.openAppSettings();
      }
    }
    setBusy(false);
  }
}
