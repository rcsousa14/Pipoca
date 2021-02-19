import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/locator.dart';

class AppViewModel extends BaseViewModel {
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();

// check on the shared preferences if there is a token or not then either go to login or main
  /* NAVIGATION KEY */
  GlobalKey<NavigatorState> get key => _navigationService.navigatorKey;
}
