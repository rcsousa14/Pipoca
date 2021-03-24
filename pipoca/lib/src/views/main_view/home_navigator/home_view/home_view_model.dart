
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/routes/navigation.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/caller.service.dart';

import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends StreamViewModel<Feed> {
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();
  final _location = locator<LocationService>();
  final _localStorage = locator<SharedLocalStorageService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _callerService = locator<CallerService>();

  final NavigationService _navigationService = locator<NavigationService>();
 // final DialogService _dialogService = locator<DialogService>();

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;
  bool _isVisible;
  bool _isFilter = false;
  bool get isVisible => _isVisible;
  bool get isFilter => _isFilter;

  Usuario get user => _userService.user;
  String get errorMsg => _userService.error;

  NavChoice get choice => NavChoice.home;
  get choicePage => NavChoice.home.pageStorageKey();

  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  Future showBasicBottomSheet(
      {String latest,
      String trending,
      String latestD,
      String trendingD}) async {
    var response = await _bottomSheetService.showBottomSheet(
        confirmButtonTitle: 'Fixe',
        title: !_isFilter ? trending : latest,
        description: !_isFilter ? trendingD : latestD);
    if (response?.confirmed == true) {
      _isFilter = !_isFilter;
      await _localStorage.put('isFilter', _isFilter);
      await pushFeed();
      notifyListeners();
    }
  }

  Future refreshFeed() async {
    _isFilter = await _localStorage.recieve('isFilter');
    if (_isFilter == null) {
      _isFilter = false;
      notifyListeners();
    }

    int level = await _callerService.batteryLevel();
    await _callerService.battery(
        level,
        _feedService.getFeed(
          page: _currentIndex,
          lat: _location.currentLocation.latitude,
          lng: _location.currentLocation.longitude,
          filter: _isFilter == false ? 'date' : 'pipocar',
        ));
    notifyListeners();
  }

  Future pushFeed() async {
    _isFilter = await _localStorage.recieve('isFilter');

    if (_isFilter == null) {
      _isFilter = false;
      notifyListeners();
    }

    _feedService.feedInfo.add(FeedInfo(
      coordinates: Coordinates(
          latitude: _location.currentLocation.latitude,
          longitude: _location.currentLocation.longitude),
      page: _currentIndex,
      filter: _isFilter == false ? 'date' : 'pipocar',
    ));
  }

  Future<dynamic> goToPost(NavChoice choice) async {
    return _navigationService.navigateTo(postRoute,
        arguments: PostViewArguments(choice: choice),
        id: choice.nestedKeyValue());
  }

  @override
  Stream<Feed> get stream => _feedService.feedStream;
}
