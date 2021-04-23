import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';

import 'package:pipoca/src/app/locator.dart';
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

  String? _gif;
  String _text = '';
  String get text => _text;
  String get gif => _gif!;
  User get user => _userService.user;

  List<String> _hashes = [];
  List<String> _links = [];
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
    var result = await _feedService.postFeed(
        post: CreatePost(
            content: _text,
            hashes: _hashes,
            links: _links,
            latitude: _location.currentLocation.latitude,
            longitude: _location.currentLocation.longitude));
    // var result = await _feedRepository.postFeed(CreatePost(
    //  latitude: _location.currentLocation.latitude,
    //  longitude: _location.currentLocation.longitude,
    //   content: _text,
    //   links: _links,
    //   hashes: _hashes,
    // ));
    // if (result != 201) {
    //   await _dialogService.showDialog(
    //       title: 'Não foi possível criar Bago', description: 'not possible');
    // } else {
    //   await refreshFeed(index, filter);
    //   _snackbarService.showSnackbar(message: 'seu Bago foi enviado');
    // }
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
