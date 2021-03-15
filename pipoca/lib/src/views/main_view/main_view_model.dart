import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class MainViewModel extends IndexTrackingViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  String get token => _authenticationService.currentToken;
  Future logout() async {
    var result = await _authenticationService.signout();
    if (result is String) {
      if (result.isNotEmpty) {
        print(result);
      }
    } else {
      await _navigationService.clearStackAndShow(Routes.loginView);
    }
  }

 
  List<BottomNavigationBarItem> get availableItems =>
      availableChoices.map((elem) => elem.navChoiceItem()).toList();
  List<NavChoice> get availableChoices => [
        NavChoice.home,
        NavChoice.discovery,
        NavChoice.notfy,
        NavChoice.user,
      ];
  GlobalKey<NavigatorState> get currentNestedKey => _navigationService
      .nestedNavigationKey(availableChoices[currentIndex].nestedKeyValue());

  NavChoice get currentChoice => availableChoices[currentIndex];
}
