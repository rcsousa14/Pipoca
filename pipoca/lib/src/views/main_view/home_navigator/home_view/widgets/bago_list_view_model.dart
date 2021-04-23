import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/caller.service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked/stacked.dart';

class BagoListViewModel extends StreamViewModel<ApiResponse<Feed>> {
  final _feedService = locator<FeedService>();
  final _callerService = locator<CallerService>();
  final _location = locator<LocationService>();
  final _authenticationService = locator<AuthenticationService>();

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  bool _isVisible = false;
  bool get isVisible => _isVisible;

  bool get filter => _authenticationService.filter;

  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  setVisible(bool visibility) {
    _authenticationService.setVisible(visibility);
    notifyListeners();
  }

  Future<void> refreshFeed() async {
    int level = await _callerService.batteryLevel();
    await _callerService.battery(
        level,
        _feedService.fetchFeed(FeedInfo(
          coordinates: Coordinates(
              latitude: _location.currentLocation.latitude,
              longitude: _location.currentLocation.longitude),
          page: _currentIndex,
          filter: filter == false ? 'date' : 'pipocar',
        )));

    notifyListeners();
  }

  @override
  Stream<ApiResponse<Feed>> get stream => _feedService.feedStream;
}
