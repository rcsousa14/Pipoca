import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/base_helper.dart';
import 'package:pipoca/src/constants/api_helpers/header.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/auth_user_model.dart';

@lazySingleton
class AuthenticationRepository {
  final _header = locator<ApiHeaders>();
  final _helper = locator<ApiBaseHelper>();

  Future<AuthenticationResponse> fetchTokenData(
      {required String type, required dynamic body}) async {
    final response = await _helper.post(
        query: 'auth/$type', header: _header.setHeaders(), body: body);
    AuthenticationResponse token = AuthenticationResponse.fromJson(response);
    return token;
  }
}

@lazySingleton
class SocialRepository {
  final _fb = FacebookAuth.instance;
  final _google = GoogleSignIn(scopes: ['profile', 'email']);

  Future socialLogout() async {
    await _fb.logOut();
    await _google.signOut();
  }

  Future facebook(String fcmToken) async {
    try {
      final result = await _fb.login(loginBehavior: LoginBehavior.DIALOG_ONLY);

      if (result.status == LoginStatus.success) {
        var data = await _fb.getUserData(fields: "email,picture.width(200)");
        var userData = {
          'email': data['email'],
          'avatar': data['picture']['data']['url'],
          'fcm_token': fcmToken,
          'type': 'facebook'
        };

        UserAuth user = UserAuth.fromJson(userData);
      
        return user;
      }
      if (result.status == LoginStatus.cancelled) {
        return "Login cancelado pelo usuário";
      }
      if (result.status == LoginStatus.operationInProgress) {
        return "Tens uma operação de login anterior em andamento";
      }
      if (result.status == LoginStatus.failed) {
        return "Falha na autenticação. Tente novamente!";
      }
    } on SocketException {
      throw 'Sem conexão com a Internet🌐';
    } on PlatformException {
      throw 'Erro desconhecido, tenta Novamente';
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future google(String fcmToken) async {
    try {
      GoogleSignInAccount? google = await _google.signIn();
      var userData = {
        'email': google!.email,
        'avatar': google.photoUrl,
        'fcm_token': fcmToken,
        'type': 'google'
      };
      UserAuth user = UserAuth.fromJson(userData);
      return user;
    } catch (e) {
      throw e;
    }
  }
}
