import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:pipoca/src/app/router.gr.dart';

class LoginViewModel extends IndexTrackingViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  // validation
  String Function(String) get validateUsername =>
      _validationService.validateUsername;

  String Function(String) get validatePhone => _validationService.validatePhone;

  Future<dynamic> signup({String username, String phone}) async {
    setBusy(true);
    var validatedUsername = validateUsername(username);
    var validatedPhone = validatePhone(phone);
    if (validatedUsername != null || username.isEmpty) {
      await _dialogService.showDialog(
        title: 'Erro ao Inscrever',
        description:
            'Digite o nome de usuário correctamente. \n\n tente novamente!',
        buttonTitle: 'ok',
      );
      setBusy(false);
    } else if (validatedPhone != null || phone.isEmpty) {
      await _dialogService.showDialog(
        title: 'Erro ao Inscrever',
        description:
            'Digite o número de telefone correctamente. Tente novamente!',
        buttonTitle: 'ok',
      );
      setBusy(false);
    } else {
      await _navigationService.navigateTo(Routes.otpView,
          arguments: OtpViewArguments(phone: phone, username: username));
      setBusy(false);
    }
  }

  Future<dynamic> login({String phone}) async {
    setBusy(true);

    var validatedPhone = validatePhone(phone);

    if (validatedPhone != null || phone.isEmpty) {
      await _dialogService.showDialog(
        title: 'Erro ao Inscrever',
        description:
            'Digite o número de telefone correctamente. Tente novamente!',
        buttonTitle: 'ok',
      );
      setBusy(false);
    } else {
      await _navigationService.navigateTo(Routes.otpView,
          arguments: OtpViewArguments(phone: phone));
      setBusy(false);
    }
  }

  Future logout() async {
    await _authenticationService.signout();
  }
}
