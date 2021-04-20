import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/repositories/user/auth_repository.dart';
import 'package:pipoca/src/repositories/user/user_repository.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class AuthenticationService with ReactiveServiceMixin {
  final _userRepo = locator<UserRepository>();
  final _authRepo = locator<AuthenticationRepository>();
  final _localStorage = locator<SharedLocalStorageService>();
  final _socialRepo = locator<SocialRepository>();

  RxValue<Auth> _auth = RxValue<Auth>(Auth(id: 0));
  RxValue<bool> _filter = RxValue<bool>(false);
  bool get filter => _filter.value;
  String get token => _auth.value.token;
  bool get loggedIn => _auth.value.token.isNotEmpty ? true : false;

  AuthenticationService() {
    listenToReactiveValues([_auth, _filter]);
  }

  /// these are the social login will incorporate email/password later
  Future<ApiResponse<AuthenticationResponse>> social(dynamic body) async {
    ApiResponse.loading('fetching...');
    try {
      AuthenticationResponse data =
          await _authRepo.fetchTokenData(type: 'social', body: body);
      _auth.value = Auth(id: 0, token: data.token!);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Generic>> logout(String token) async {
    ApiResponse.loading('fetching');
    try {
      await _socialRepo.socialLogout();
      Generic data = await _userRepo.logout(token);
      deleteToken();
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<AuthenticationResponse>> resetToken() async {
    ApiResponse.loading('fetching');
    try {
      AuthenticationResponse data =
          await _userRepo.refreshToken(_auth.value.id, _auth.value.token);
      _auth.value = Auth(id: _auth.value.id, token: data.token!);

      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<Auth> getToken() async {
    var filter = await _localStorage.recieve('filter');
    var res = await _localStorage.recieve('auth');

    if (filter != null) {
      _filter.value = filter;
    }
    if (res != null) {
      var values = json.decode(res);
      Auth auth = Auth(id: values['id'], token: values['token']);
      _auth.value = auth;
    }

    return _auth.value;
  }

  Future setFilter(bool newFilter) async {
    await _localStorage.put('filter', newFilter);
    _filter.value = newFilter;
  }

  Future deleteToken() async {
    await _localStorage.delete('auth');
    await _localStorage.delete('filter');
    _filter.value = false;
    _auth.value = Auth(id: 0);
  }
}
