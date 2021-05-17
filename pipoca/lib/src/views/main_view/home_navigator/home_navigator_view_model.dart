import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class HomeNavigatorViewModel extends IndexTrackingViewModel {
  // THE LOCATORS
  final _feedService = locator<FeedService>();
  final _authenticationService = locator<AuthenticationService>();
  final _location = locator<LocationService>();

  //VARIABLES
  int _currentPage = 1;
  Data _data = Data();


  //GETTERS
  Data get posts => _data;
  int get currentPage => _currentPage;
  bool get filter => _authenticationService.filter;

  NavChoice get choice => NavChoice.home;
  get pageStorage => NavChoice.home.pageStorageKey();

  //FUNCTION TO SET CURRENT PAGE
  void setCurrentPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  //FUNCTION TO SET CURRENT DATA FOR POST PAGE
  void setCurrentData(Data data, bool isCreator) {
    _data = data;


    notifyListeners();
  }

// FUTURE TO GET FEED BASED ON FEED INFO INITIAL
  Future pushFeed() async {
    _feedService.feedInfo.add(FeedInfo(
      coordinates: Coordinates(
          latitude: _location.currentLocation.latitude,
          longitude: _location.currentLocation.longitude),
      page: _currentPage,
      filter: filter == false ? 'date' : 'pipocar',
    ));
  }

// FUTURE TO GET FEED BASED ON USER INTERACTION AND REFRESH CONTINUOUSLY
  Future refreshFeed({required bool isRefresh}) async {
    setBusy(true);
    int? newPage;
    if (_currentPage != 1) {
      newPage = _currentPage - 1;
    }
    await _feedService
        .fetchFeed(
      isRefresh: isRefresh,
      info: FeedInfo(
        coordinates: Coordinates(
          latitude: _location.currentLocation.latitude,
          longitude: _location.currentLocation.longitude,
        ),
        page: newPage ?? _currentPage,
        filter: filter == false ? 'date' : 'pipocar',
      ),
    )
        .then((value) {
      if (newPage != null) {
        setCurrentPage(newPage);
      }

      setBusy(false);
    });

    notifyListeners();
  }
}
