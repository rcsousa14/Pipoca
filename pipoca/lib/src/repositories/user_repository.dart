import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'dart:convert';

import 'package:pipoca/src/services/authentication_service.dart';

@lazySingleton
class UserApi {
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final token = locator<AuthenticationService>().currentToken;
  //USER CRUD

  Future<Usuario> getUser() async { 
    try {
      var url = Uri.encodeFull('$heroku_url/users');
      var response = await client.get(
        url,
        headers: _header.setTokenHeaders(token: token),
      );
      var parsed = json.decode(response.body);
      Usuario user = Usuario.fromJson(parsed);
      return user;
    } catch (e) {
      return e;
    }
  }

  Future<Usuario> patchFcmToken(String fcmToken) async {
     try {
      var url = Uri.encodeFull('$heroku_url/users');
      var response = await client.patch(
        url,
        headers: _header.setTokenHeaders(token: token),
        body: {'fcm_token': fcmToken}
      );
      var parsed = json.decode(response.body);
      Usuario user = Usuario.fromJson(parsed);
      return user;
    } catch (e) {
      return e;
    }
  }
}
