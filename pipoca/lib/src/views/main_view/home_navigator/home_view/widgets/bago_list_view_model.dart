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

  List<Data> get posts => _feedService.posts;
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  bool _isVisible = false;
  bool get isVisible => _isVisible;

  bool _showLoading = false;

  bool get filter => _authenticationService.filter;

  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  setVisible(bool visibility) {
    _authenticationService.setVisible(visibility);
    notifyListeners();
  }

  Future<void> refreshFeed(bool isError, bool isRefresh) async {
    setBusy(true);
 
    int level = await _callerService.batteryLevel();
    _currentIndex = isError == true ? 1 : _currentIndex;
    notifyListeners();
    await _callerService.battery(
        level,
        _feedService.fetchFeed(
          info: FeedInfo(
            coordinates: Coordinates(
                latitude: _location.currentLocation.latitude,
                longitude: _location.currentLocation.longitude),
            page: isRefresh == true ? 1 : _currentIndex,
            filter: filter == false ? 'date' : 'pipocar',
          ),
          isRefresh: isRefresh,
        ));
setBusy(false);
    notifyListeners();
    
  }

  Future handleItemCreated(int index, Feed feed) async {
    var itemPosition = index + 5;
    var itemRequestThreshold = feed.posts!.limit;
    var requestMoreData = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = feed.posts!.nextPage;
    if (requestMoreData && pageToRequest > _currentIndex) {
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
