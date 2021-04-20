import 'dart:convert';

import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final _authenticationService = locator<AuthenticationService>();
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();
  final _location = locator<LocationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  bool get filter => _authenticationService.filter;
  User get user => _userService.user;

  int _currentIndex = 1;
  int get index => _currentIndex;

  Future showBasicBottomSheet(
      {required String latest,
      required String trending,
      required String latestD,
      required String trendingD}) async {
    var response = await _bottomSheetService.showBottomSheet(
        confirmButtonTitle: 'Fixe',
        title: filter ? trending : latest,
        description: filter ? trendingD : latestD);
    if (response?.confirmed == true) {
      bool newFilter = !filter;
      await _authenticationService.setFilter(newFilter);
      await pushFeed();
      notifyListeners();
    }
  }

  Future pushFeed() async {
  
    _feedService.feedInfo.add(FeedInfo(
      coordinates: Coordinates(
          latitude: _location.currentLocation.latitude,
          longitude: _location.currentLocation.longitude),
      page: _currentIndex,
      filter: filter == false ? 'date' : 'pipocar',
    ));
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_authenticationService, _userService];
}
