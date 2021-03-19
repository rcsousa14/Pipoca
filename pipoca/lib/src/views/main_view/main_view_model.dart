import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/constants/widgets/connectivity_status.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/battery_service.dart';
import 'package:pipoca/src/services/connectivity_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class MainViewModel extends IndexTrackingViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _conn = locator<ConnectivityService>();
  final _location = locator<LocationService>();
  final _battery = locator<BatteryService>();


  ConnectivityStatus get result => _conn.status;
  Coordinates get coords => _location.currentLocation;
  String get token => _authenticationService.currentToken;

  BatteryState get state => _battery.batteryState;


  

  List<BottomNavigationBarItem> get availableItems =>
      availableChoices.map((elem) => elem.navChoiceItem()).toList();
  List<NavChoice> get availableChoices => [
        NavChoice.home,
        NavChoice.discovery,
        NavChoice.notfy,
        NavChoice.user,
      ];
  GlobalKey<NavigatorState> get currentNestedKey => StackedService.nestedNavigationKey(availableChoices[currentIndex].nestedKeyValue());

  NavChoice get currentChoice => availableChoices[currentIndex];
}
