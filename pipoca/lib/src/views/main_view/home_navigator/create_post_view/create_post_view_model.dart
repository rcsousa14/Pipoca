import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreatePostViewModel extends BaseViewModel {
  //THE LOCATORS
  final _feedService = locator<FeedService>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();
  final _homeNaviagator = locator<HomeNavigatorViewModel>();
  final _location = locator<LocationService>();

  //VARIABLES
  String _text = '';
  List<String> _hashes = [];
  List<String> _links = [];
  List<String> _gif = [];

  

  //FUNCTION TO UPDATE THE HASHES AND LINKS LIST TO POST
  void updateString(String value) {
    _text = value;
 
    _hashes = extractDetections(_text, hashTagRegExp);
    _links = extractDetections(_text, urlRegex);

    notifyListeners();
  }

  //GETTERS
  String get text => _text;
  User get user => _userService.user;
  Future get refreshFeed => _homeNaviagator.refreshFeed(isRefresh: false);
  Function(int index) get setIndex => _homeNaviagator.setIndex;
  List<String> get links => _links;

//FUNCTION TO DELETE THE TEXT
  void deleteString() {
    _text = '';
    notifyListeners();
  }

//FUTURE TO ADD A NEW POST
  Future addPost() async {
    String text = '';
    RegExp exp = urlRegex;
    if (_gif.length == 0 && _links.length > 0) {
      RegExpMatch? match = exp.firstMatch(_text);
      if (match != null) {
        var link = _text.substring(match.start, match.end);
        text = _text.replaceAll(link, '').trim();
        notifyListeners();
      }
    }
    CreatePost post = CreatePost(
      content: text.isEmpty ? _text.trim() : text.trim(),
      hashes: _hashes,
      links: _gif.length > 0 ? _gif : _links,
      latitude: _location.currentLocation.latitude,
      longitude: _location.currentLocation.longitude,
    );
    //RETURN TO INITIAL PAGE THEN MAKES A POST
    setIndex(0);
    var result = await _feedService.postFeed(post: post);

    if (result.status == Status.ERROR) {
      await refreshFeed;
      Future.delayed(Duration(seconds: 4));
      return _dialogService.showDialog(
          title: 'Erro', description: '${result.message}');
    }
    if (result.status == Status.COMPLETED) {
      await refreshFeed;
      Future.delayed(Duration(seconds: 4));
      return _snackbarService.showSnackbar(
          message: 'Bago Criado com Successo!');
    }
  }
}
