import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/connectivity_status.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/connectivity_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/push_notification_service.dart';
import 'package:pipoca/src/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


class LoginViewModel extends IndexTrackingViewModel {
  
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  // final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  final _pushNotificationService = locator<PushNotificationService>();


  // validation
  String Function(String) get validateEmail => _validationService.validateEmail;

  String Function(String) get validatePass => _validationService.validatePass;

  Future<dynamic> access({String email, String password, String type}) async {
    setBusy(true);
    var fcmToken = await _pushNotificationService.token();
    var validatedEmail = validateEmail(email);
    var validatedPass = validatePass(password);
    if (validatedEmail != null || email.isEmpty) {
      await _dialogService.showDialog(
        title: 'Erro ao Inscrever',
        description: 'Digite o Email correctamente. \n\n tente novamente!',
        buttonTitle: 'ok',
      );
      setBusy(false);
    } else if (validatedPass != null || password.isEmpty) {
      await _dialogService.showDialog(
        title: 'Erro ao Inscrever',
        description: 'Digite a senha correctamente. Tente novamente!',
        buttonTitle: 'ok',
      );
      setBusy(false);
    } else {
      UserAuth user = UserAuth(
          email: email,
          password: password,
          fcmToken: fcmToken,
          type: 'email/password');
      await _authenticationService.access(user: user, type: null);
      setBusy(false);
    }
  }
}
