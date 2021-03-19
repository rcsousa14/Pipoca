import 'dart:async';
import 'dart:io';

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

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@lazySingleton
class AuthenticationService {
  final _localStorage = locator<SharedLocalStorageService>();
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final _fb = FacebookAuth.instance;
  final _google = GoogleSignIn(scopes: ['profile', 'email']);
  final _apple = SignInWithApple;

  //token setter to be use for all the api services
  String _currentToken;
  String get currentToken => _currentToken;

  //method for fetching token. Endpoint could be login or signup

  Future access({@required UserAuth user, @required String type}) async {
    try {
      var url = Uri.encodeFull('$heroku_url/auth/$type');
      var response = await client.post(
        url,
        headers: _header.setHeaders(),
        body: json.encode(user.toJson()),
      );
      var parsed = json.decode(response.body);
      Token token = Token.fromJson(parsed);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (token.token != null && token.token.isNotEmpty) {
          await _localStorage.put('token', token.token).then((value) {
            _currentToken = token.token;
          });
        }
        return token != null;
      } else {
        return token.message;
      }
    } on SocketException {
      throw 'Sem conexão com a Internet';
    } on TimeoutException catch (e) {
      return e.message;
    } on Error catch (e) {
      return 'Falha na autenticação. Tente novamente! $e';
    }
  }

  Future facebook({String fcmToken}) async {
    try {
      AccessToken accessToken =
          await _fb.login(loginBehavior: LoginBehavior.DIALOG_ONLY);
      if (accessToken != null) {
        var data = await _fb.getUserData(fields: "email,picture.width(200)");
        var userData = {
          'email': data['email'],
          'avatar': data['picture']['data']['url']
        };
        userData['type'] = 'facebook';
        userData['fcm_token'] = fcmToken;

        UserAuth user = UserAuth.fromJson(userData);
        if (userData['email'].isEmpty || userData['email'] == null) {
          return 'Você precisa verificar sua conta do Facebook';
        }

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
    } on SocketException {
      throw 'Sem conexão com a Internet';
    } on TimeoutException catch (e) {
      return e.message;
    } on Error catch (e) {
      return 'Falha na autenticação. Tente novamente! $e';
    }
  }

  Future google({String fcmToken}) async {
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
    } on SocketException {
      throw 'Sem conexão com a Internet';
    } on TimeoutException catch (e) {
      return e.message;
    } on Error catch (e) {
      return 'Falha na autenticação. Tente novamente! $e';
    }
  }

  //platform IOS
  Future apple({String fcmToken}) async {
    try {
    //  final apple = await _apple.getAppleIDCredential(
    //    scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
           
    //   ],
    //  );
      // if (google != null) {
      //   var result = await access(
      //       user: UserAuth(
      //         email: google.email,
      //         avatar: google.photoUrl,
      //         fcmToken: fcmToken,
      //         type: 'google',
      //       ),
      //       type: 'social');
      //   return result;
      //}
    } on SocketException {
      throw 'Sem conexão com a Internet';
    } on TimeoutException catch (e) {
      return e.message;
    } on Error catch (e) {
      return 'Falha na autenticação. Tente novamente! $e';
    }
  }

  //check if token is saved on localstorage and set currentToken
  Future<bool> isUserLoggedIn() async {
    var token = await _localStorage.recieve('token');
    _currentToken = token;
    return _currentToken != null;
  }

  Future refreshToken({String currentToken, int id}) async {
    try {
      var url = Uri.encodeFull('$heroku_url/auth/refresh-token');
      var response = await client.post(url,
          body: {'token': currentToken, 'id': id},
          headers: _header.setHeaders());
      var parsed = json.decode(response.body);
      Token token = Token.fromJson(parsed);
      if (response.statusCode == 200) {
        if (token.token != null && token.token.isNotEmpty) {
          await _localStorage.delete('token');
          await _localStorage.put('token', token.token).then((value) {
            _currentToken = token.token;
          });
        }
        return token != null;
      } else {
        return token.message; 
      }
    } on SocketException {
      throw 'Sem conexão com a Internet';
    } on TimeoutException catch (e) {
      return e;
    } on Error catch (e) {
      return 'Falha na autenticação. Tente novamente! $e';
    }
  }

  Future passReset({String email}) async {
    try {
      var url = Uri.encodeFull('$heroku_url/auth/forgot-password');
      var response = await client.post(url,
          headers: _header.setHeaders(), body: jsonEncode({'email': email}));
    
      return response.body;
    } catch (e) {
      return e;
    }
  }

  //logout for the current user
  Future signout() async {
    var url = Uri.encodeFull('$heroku_url/auth/logout');
    var response = await client.patch(
      url,
      headers: _header.setTokenHeaders(token: _currentToken),
    );
    if (response.statusCode == 200) {
      await _localStorage.clear();
      await _fb.logOut();
      await _google.signOut();
    } else {
      return 'unknown error';
    }
  }
}
