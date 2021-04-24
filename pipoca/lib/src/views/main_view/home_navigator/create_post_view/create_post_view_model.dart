import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';

import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/caller.service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreatePostViewModel extends BaseViewModel {
  final _feedService = locator<FeedService>();
  final _userService = locator<UserService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _location = locator<LocationService>();
  final _callerService = locator<CallerService>();

  String _text = '';
  String get text => _text;

  User get user => _userService.user;

  List<String> _hashes = [];
  List<String> _links = [];
  List<String> _gif = [];
  List<String> get links => _links;

  void updateString(String value) {
    _text = value;
    _hashes = extractDetections(_text, hashTagRegExp);
    _links = extractDetections(_text, urlRegex);

    notifyListeners();
  }

  void deleteString() {
    _text = '';
    notifyListeners();
  }

  goBack() {
    return _navigationService.back();
  }

  Future addPost(int index, bool filter) async {
    String text = '';
    RegExp exp = urlRegex;
    if (_gif.length == 0) {
      RegExpMatch? match = exp.firstMatch(_text);
      if (match != null) {
        var link = _text.substring(match.start, match.end);
        text = _text.replaceAll(link, '').trim();
        notifyListeners();
      }
    }
    var result = await _feedService.postFeed(
      post: CreatePost(
        content: text,
        hashes: _hashes,
        links: _gif.length > 0 ? _gif : _links,
        latitude: _location.currentLocation.latitude,
        longitude: _location.currentLocation.longitude,
      ),
    );
    if (result.status == Status.LOADING) {
      _navigationService.back();
    }
    if (result.status == Status.ERROR) {
      //_navigationService.back();
      _snackbarService.showSnackbar(message: result.message!);
      return await refreshFeed(index, filter);
    }
    if (result.status == Status.COMPLETED) {
      // _navigationService.back();
      _snackbarService.showSnackbar(message: result.message!);
      return await refreshFeed(index, filter);
    }
  }

  Future<void> refreshFeed(int index, bool filter) async {
    int level = await _callerService.batteryLevel();
    await _callerService.battery(
        level,
        _feedService.fetchFeed(FeedInfo(
          coordinates: Coordinates(
              latitude: _location.currentLocation.latitude,
              longitude: _location.currentLocation.longitude),
          page: index,
          filter: filter == false ? 'date' : 'pipocar',
        )));

    notifyListeners();
  }
}
