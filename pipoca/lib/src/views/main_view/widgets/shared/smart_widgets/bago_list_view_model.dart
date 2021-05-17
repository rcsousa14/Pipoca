import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.router.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BagoListViewModel extends StreamViewModel<ApiResponse<Feed>> {
  //THE LOCATORS
  final _homeNavigator = locator<HomeNavigatorViewModel>();
  final _feedService = locator<FeedService>();
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  //GETTERS
  NavChoice get choice => _homeNavigator.choice;
  get pageStorage => _homeNavigator.pageStorage;
  bool get filter => _homeNavigator.filter;
  Function(int index) get setPage => _homeNavigator.setCurrentPage;
  int get page => _homeNavigator.currentPage;
  Function(int index) get setIndex => _homeNavigator.setIndex;
  Function(Data data, bool isCreator) get setData =>
      _homeNavigator.setCurrentData;
  Future get refreshFeedFalse => _homeNavigator.refreshFeed(isRefresh: false);
  Future get refreshFeedTrue => _homeNavigator.refreshFeed(isRefresh: true);
  String get creator => _userService.user.username;
  List<Data> get posts => _feedService.posts;
  bool get isVisible => _isVisible;
  bool get loading => _showLoading;

  //VARIABLES
  bool _isVisible = false;
  bool _showLoading = false;

// LIST VISIBILITY CHANGE TO CALL FEEDER
  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

  // FUTURE TO GO TO POST PAGE IT SETS BAGO AND ISCREATOR ON THE HOME_NAVIGATOR
  Future goToPost({
    required Data bago,

  }) async {
    return _navigationService.navigateTo(Routes.postView,
        arguments: PostViewArguments(data: bago, filter: filter, page: page));
  }

  // FUTURE THAT HANDLES PAGINATION FOR THE FEED
  Future handleItemCreated(int index, Feed feed) async {
    var itemPosition = index + 5;
    var itemRequestThreshold = feed.bagos!.limit;
    var requestMoreData = itemPosition % itemRequestThreshold == 0;
    var pageToRequest = feed.bagos!.nextPage;
    if (requestMoreData && pageToRequest! > page) {
      setPage(pageToRequest);

      _showLoadingIndicator();
      await refreshFeedFalse.then((value) => _removeLoadingIndicator());
    }
  }

  // FUNCTION FOR PAGINATION LOADING
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
