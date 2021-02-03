import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class MainViewModel extends IndexTrackingViewModel {
  
  final NavigationService _navigationService = locator<NavigationService>();
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
