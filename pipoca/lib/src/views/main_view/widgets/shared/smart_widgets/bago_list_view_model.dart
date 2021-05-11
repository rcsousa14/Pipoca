import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.router.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/routes/navigation.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BagoListViewModel extends StreamViewModel<ApiResponse<Feed>> {
  final _feedService = locator<FeedService>();
  final _location = locator<LocationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  String get creator => _userService.user.username;
  List<Data> get posts => _feedService.posts;

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  bool _isVisible = false;
  bool get isVisible => _isVisible;

  bool _showLoading = false;
  bool get loading => _showLoading;

  bool get filter => _authenticationService.filter;

  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  setVisible(bool visibility) {
    _authenticationService.setVisible(visibility);
    notifyListeners();
  }

  Future refreshFeed(bool isError, bool isRefresh) async {
    setBusy(true);
    print('im calling');
    _currentIndex = isError == true ? 1 : _currentIndex;

    await _feedService
        .fetchFeed(
            info: FeedInfo(
              coordinates: Coordinates(
                  latitude: _location.currentLocation.latitude,
                  longitude: _location.currentLocation.longitude),
              page: isRefresh == true ? 1 : _currentIndex,
              filter: filter == false ? 'date' : 'pipocar',
            ),
            isRefresh: isRefresh)
        .then((value) {
      setBusy(false);
    });

    notifyListeners();
  }

  Future post(
      {required Data bago,
      required Key key,
      required bool isCreator,
      required bool filter,
      required NavChoice choice,
      required int page}) async {
    return _navigationService.navigateTo(postRoute,
        id: choice.nestedKeyValue(),
        arguments: PostViewArguments(
            choice: choice,
            key: key,
            bago: bago,
            isCreator: isCreator,
            filter: filter,
            page: page));
  }

  Future handleItemCreated(int index, Feed feed) async {
    var itemPosition = index + 5;
    var itemRequestThreshold = feed.bagos!.limit;
    var requestMoreData = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = feed.bagos!.nextPage;
    if (requestMoreData && pageToRequest! > _currentIndex) {
      _currentIndex = pageToRequest;
      notifyListeners();
      _showLoadingIndicator();
      await refreshFeed(false, false)
          .then((value) => _removeLoadingIndicator());
    }
  }

  void _showLoadingIndicator() {
    _showLoading = true;
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _showLoading = false;
    notifyListeners();
  }

 

  @override
  Stream<ApiResponse<Feed>> get stream => _feedService.feedStream;
}
