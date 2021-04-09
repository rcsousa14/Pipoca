import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';

import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/repositories/feed/feed_repository.dart';

import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CreatePostViewModel extends BaseViewModel {
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final DialogService _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();
  final _location = locator<LocationService>();
  final FeedRepository _feedRepository = locator<FeedRepository>();
  String _gif;
  String _text = '';
  String get text => _text;
  String get gif => _gif;

  List<String> _hashes = [];
  List<String> _links = [];
  List<String> get links => _links;

  Usuario get user => _userService.user;
  //extractDetections("#Hello World #Flutter Dart #Thank you", hashTagRegExp);

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

  Future addPost() async {
    setBusy(true);

    var result = await _feedRepository.postFeed(CreatePost(
      latitude: _location.currentLocation.latitude,
      longitude: _location.currentLocation.longitude,
      content: _text,
      links: _links,
      hashes: _hashes,
    ));
    if (result != 201) {
      await _dialogService.showDialog(
          title: 'Não foi possível criar Bago', description: 'not possible');
    } else {
      _snackbarService.showSnackbar(message: 'seu Bago foi enviado');
    }

    setBusy(false);
  }
}
