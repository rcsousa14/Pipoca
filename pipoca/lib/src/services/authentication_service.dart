import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'dart:convert';

@lazySingleton
class AuthenticationService {
  final _localStorage = locator<SharedLocalStorageService>();
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final _fb = FacebookAuth.instance;
  final _google = GoogleSignIn(scopes: ['profile', 'email']);

  //token setter to be use for all the api services
  String _currentToken;
  String get currentToken => _currentToken;

  //method for fetching token. Endpoint could be login or signup

  Future<bool> access({@required UserAuth user, @required String type}) async {
    try {
      var url = Uri.encodeFull('$heroku_url/auth/$type');
      var response = await client.post(
        url,
        headers: _header.setHeaders(),
        body: json.encode(user.toJson()),
      );
      var parsed = json.decode(response.body);
      Token token = Token.fromJson(parsed);
      if (token.token != null) {
        await _localStorage.put('token', token.token).then((value) {
          _currentToken = token.token;
        });
      }
      return token != null;
    } catch (e) {
      return e;
    }
  }

  Future facebook({String fcmToken}) async {
    try {
      AccessToken accessToken =
          await _fb.login(loginBehavior: LoginBehavior.NATIVE_ONLY);
      if (accessToken != null) {
        var userData =
            await _fb.getUserData(fields: "email,picture.width(200)");
        userData['type'] = 'facebook';
        userData['fcm_token'] = fcmToken;
        UserAuth user = UserAuth.fromJson(userData);

        var result = await access(user: user, type: 'social');
        return result;
      }
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          return " Tens uma operação de login anterior em andamento";
          break;
        case FacebookAuthErrorCode.CANCELLED:
          return "Login cancelado pelo usuário";
          break;
        case FacebookAuthErrorCode.FAILED:
          return "Falha na autenticação. Tente novamente!";
          break;
      }
    }
  }

  Future google(String fcmToken) async {
    try {
      GoogleSignInAccount google = await _google.signIn();
      if (google != null) {
        var result = await access(
            user: UserAuth(
              email: google.email,
              avatar: google.photoUrl,
              fcmToken: fcmToken,
              type: 'google',
            ),
            type: 'social');
        return result;
      }
    } catch (e) {
      return 'Falha na autenticação. Tente novamente!';
    }
  }

  //check if token is saved on localstorage and set currentToken
  Future<bool> isUserLoggedIn() async {
    var token = await _localStorage.recieve('token');
    _currentToken = token;
    return _currentToken != null;
  }

  //logout for the current user
  Future signout() async {
    await _localStorage.delete('token');
    await _fb.logOut();
    await _google.signOut();
  }
}
