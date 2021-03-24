

import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/validation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ForgotViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _validationService = locator<ValidationService>();
  //final _userApi = locator<UserRepository>();

  // validation
  String Function(String) get validateEmail => _validationService.validateEmail;

  Future access({String email}) async {
    setBusy(true);
   // var result = await _userApi.passReset(email: email);
   // print(result);
    setBusy(false);
  }

  Future<dynamic> goToLogin() async {
    return await _navigationService.navigateTo(Routes.loginView);
  }
}
