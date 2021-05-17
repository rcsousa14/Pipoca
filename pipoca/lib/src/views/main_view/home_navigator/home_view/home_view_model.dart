import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  
  // THE LOCATORS
  final _homeNavigator = locator<HomeNavigatorViewModel>();
  final _authenticationService = locator<AuthenticationService>();
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();
  final _bottomSheetService = locator<BottomSheetService>();

  //GETTERS
  bool get filter => _homeNavigator.filter;
  Function(int index) get setIndex => _homeNavigator.setIndex;
  Future get pushFeed => _homeNavigator.pushFeed();
  User get user => _userService.user;


//FUNCTION TO SWITCH FILTERS
  Future showBasicBottomSheet(
      {required String latest,
      required String trending,
      required String latestD,
      required String trendingD}) async {
    var response = await _bottomSheetService.showBottomSheet(
        confirmButtonTitle: 'Fixe',
        title: filter ? latest : trending,
        description: filter ? latestD : trendingD);
    if (response?.confirmed == true) {
      bool newFilter = !filter;
      await _authenticationService.setFilter(newFilter);
      await pushFeed;
      notifyListeners();
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_authenticationService, _userService, _feedService];
}
