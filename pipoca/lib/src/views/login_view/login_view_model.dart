import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/push_notification_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends IndexTrackingViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _pushNotificationService = locator<PushNotificationService>();
  final _userService = locator<UserService>();


  Future<dynamic> access({String type, BuildContext context}) async {
    setBusy(true);

    var fcmToken = await _pushNotificationService.token();
    await Future.delayed(Duration(milliseconds: 900));
    var result = type == 'facebook'? await _authenticationService.facebook(fcmToken: fcmToken) : await _authenticationService.google(fcmToken: fcmToken);
    if (result is bool) {
      if (result) {
       await _userService.getUser();
        await _navigationService.replaceWith(Routes.mainView);
      } else {
        await _dialogService.showDialog(
          title: 'Login',
          description:
              'Ocorreu um erro na função de login, tente novamente! \n\n Verifique sua conexão de internet',
          buttonTitle: 'ok',
        );
        setBusy(false);
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login',
        description:
            'Ocorreu um erro na função de login, tente novamente! \n\n $result',
        buttonTitle: 'ok',
      );
      setBusy(false);
    }
    setBusy(false);
  }
}
