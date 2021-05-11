import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:permission_handler/permission_handler.dart' as settings;

@lazySingleton
class MainViewModel extends IndexTrackingViewModel {

  final _currentLocation = locator<LocationService>();
  final _dialogService = locator<DialogService>();

  


  Future locationCheck() async {
    var permission = await _currentLocation.location.hasPermission();
    if (permission != PermissionStatus.granted) {
      DialogResponse? response = await _dialogService.showDialog(
          title: 'Localização',
          description:
              'Parece que não deu-nos permissão para sua localização.\nSe gostarias de usar sua localização para interagir com as pessoas próximas de si, clique "Sim".',
          buttonTitle: 'Sim',
          cancelTitle: 'Agora Não');

      if (response?.confirmed == true) {
        await settings.openAppSettings();
      }
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
  GlobalKey<NavigatorState>? get currentNestedKey =>
      StackedService.nestedNavigationKey(
          availableChoices[currentIndex].nestedKeyValue());

  NavChoice get currentChoice => availableChoices[currentIndex];
}
