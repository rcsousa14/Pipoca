import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';

class NewPostViewModel extends ReactiveViewModel {
  final _feedService = locator<FeedService>();
  final _userService = locator<UserService>();
  final _authenticationService = locator<AuthenticationService>();

  CreatePost get post => _feedService.newPost;
  User get user => _userService.user;
  bool get filter => _authenticationService.filter;
  
  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_feedService, _userService];
}
