import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/caller.service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:stacked/stacked.dart';

class BagoListViewModel extends StreamViewModel<ApiResponse<Posts>>  {
  final _feedService = locator<FeedService>();
  final _localStorage = locator<SharedLocalStorageService>();
  final _callerService = locator<CallerService>();
  final _location = locator<LocationService>();

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;
  bool? _isVisible;
  bool get isVisible => _isVisible!;

  bool _isFilter = false;

  bool get isFilter => _isFilter;

  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
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
        _feedService.fetchFeed(
          FeedInfo(
      coordinates: Coordinates(
          latitude: _location.currentLocation.latitude,
          longitude: _location.currentLocation.longitude),
      page: _currentIndex,
      filter: _isFilter == false ? 'date' : 'pipocar',
    )
        ));
    
    notifyListeners();
  }

  @override
  Stream<ApiResponse<Posts>> get stream => _feedService.feedStream;
}
