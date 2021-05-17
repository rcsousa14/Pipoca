import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/comment_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';

class PostViewModel extends ReactiveViewModel {
  final int id;
  final int page;
  final bool filter;
  PostViewModel({required this.id, required this.page, required this.filter});
// LOCATORS
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();
  final _commentService = locator<CommentService>();
  final _location = locator<LocationService>();
  final _dialogService = locator<DialogService>();
  final _snackbarService = locator<SnackbarService>();
  final _feedService = locator<FeedService>();

  //GETTERS
  // bool get filter => _commentService.filter;
  String get creator => _userService.user.username;

//VARIABLE
  String _text = '';
  List<String> _hashes = [];
  List<String> _links = [];
  List<String> _gif = [];
  changeFilter() {
    //TODO: set it as a dropdown
    // bool newfilter = !filter;
    //_commentService.setFilter(newfilter);
    notifyListeners();
  }

  //FUNCTION TO UPDATE THE HASHES AND LINKS LIST TO POST
  void updateString(String value) {
    _text = value;

    _hashes = extractDetections(_text, hashTagRegExp);
    _links = extractDetections(_text, urlRegex);

    notifyListeners();
  }

  //FUNCTION TO RETURN BACK
  Future goBack() async {
    //await refreshFeed();
    return _navigationService.back();
  }

  //FUTURE TO POST COMMENT
  Future addComment() async {
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
    var result = await _commentService.postComment(post: post, postId: id);
    if (result.status == Status.ERROR) {

      return _dialogService.showDialog(
          title: 'Erro', description: '${result.message}');
    }
    if (result.status == Status.COMPLETED) {
     
      return _snackbarService.showSnackbar(message: '${result.message}');
    }
  }

  // FUTURE TO GET FEED BASED ON FEED INFO INITIAL
  Future refreshFeed() async {
    await _feedService.fetchFeed(
      isRefresh: false,
      info: FeedInfo(
        coordinates: Coordinates(
          latitude: _location.currentLocation.latitude,
          longitude: _location.currentLocation.longitude,
        ),
        page: page == 1 ? page : page - 1,
        filter: filter == false ? 'date' : 'pipocar',
      ),
    );

    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_commentService];
}
