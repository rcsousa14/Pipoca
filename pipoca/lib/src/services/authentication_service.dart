import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/repositories/user/auth_repository.dart';
import 'package:pipoca/src/repositories/user/user_repository.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class AuthenticationService with ReactiveServiceMixin {
  final _userRepo = locator<UserRepository>();
  final _authRepo = locator<AuthenticationRepository>();
  final _localStorage = locator<SharedLocalStorageService>();

  RxValue<String> _token = RxValue<String>('');
  String get token => _token.value;
  bool get loggedIn => _token.value.isNotEmpty ? true : false;

  AuthenticationService() {
    listenToReactiveValues([_token]);
  }

  /// these are the social login will incorporate email/password later
  Future<ApiResponse<AuthenticationResponse>> social(dynamic body) async {
    ApiResponse.loading('fetching...');
    try {
      AuthenticationResponse data =
          await _authRepo.fetchTokenData(type: 'social', body: body);
      _token.value = data.token!;

      setToken(data.token!);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Generic>> logout() async {
    ApiResponse.loading('fetching');
    try {
      Generic data = await _userRepo.logout(_token.value);
      deleteToken();
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<AuthenticationResponse>> resetToken() async {
    ApiResponse.loading('fetching');
    try {
      var id = await _localStorage.recieve('id');
      AuthenticationResponse data =
          await _userRepo.refreshToken(id, _token.value);
      print(data);
      _token.value = data.token!;
      setToken(data.token!);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // sharelocalStorage for token
  //
  Future getToken() async {
    var token = await _localStorage.recieve('token');
    if (token != null) {
      _token.value = token;
    }
  }

  void setToken(String token) async {
    await _localStorage.put('token', token);
  }

  void deleteToken() async {
    AuthenticationResponse data =
        AuthenticationResponse(token: "", message: '', success: true);
    _token.value = data.token!;
    await _localStorage.clear();
  }
}
