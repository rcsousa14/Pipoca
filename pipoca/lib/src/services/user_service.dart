import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/repositories/user/user_repository.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class UserService with ReactiveServiceMixin {
  final _userRepo = locator<UserRepository>();
  final _localStorage = locator<SharedLocalStorageService>();
  final _authenticationService = locator<AuthenticationService>();
  RxValue<User> _user = RxValue<User>(
    User(
      id: 0,
      username: '',
      createdAt: '',
      email: '',
      interation: Interation(
        userCommentsTotal: 0,
        userPostsTotal: 0,
        userSubCommentsTotal: 0,
      ),
      interationTotal: 0,
      karma: Karma(
          postsVotesTotal: 0, commentsVotesTotal: 0, subCommentsVotesTotal: 0),
      karmaTotal: 0,
    ),
  );
  User get user => _user.value;

  UserService() {
    listenToReactiveValues([_user]);
  }

  Future<ApiResponse<Usuario>> fetchUser() async {
    ApiResponse.loading('fetching');

    try {
      Usuario data =
          await _userRepo.fetchUserData(token: _authenticationService.token);

      _user.value = data.user!;

      setAuth(Auth(id: data.user!.id, token: _authenticationService.token));

      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  logoutUser() {
    Usuario data = Usuario(
        user: User(
          id: 0,
          createdAt: '',
          username: '',
          email: '',
          interation: Interation(
            userCommentsTotal: 0,
            userPostsTotal: 0,
            userSubCommentsTotal: 0,
          ),
          interationTotal: 0,
          karma: Karma(
              postsVotesTotal: 0,
              commentsVotesTotal: 0,
              subCommentsVotesTotal: 0),
          karmaTotal: 0,
        ),
        message: '',
        success: true);
    _user.value = data.user!;

    ApiResponse.completed(data);
  }

 Future setAuth(Auth auth) async {
    
   await _localStorage.put('auth', json.encode(auth));
  }
}
