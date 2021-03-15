import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'dart:convert';

import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/connectivity_service.dart';

@lazySingleton
class UserApi {
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final token = locator<AuthenticationService>().currentToken;
  final _conn = locator<ConnectivityService>().status;
  //USER CRUD
  //TODO: use the _conn for ping timer
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
      var response = await client.patch(url,
          headers: _header.setTokenHeaders(token: token),
          body: {'fcm_token': fcmToken});
      var parsed = json.decode(response.body);
      Usuario user = Usuario.fromJson(parsed);
      return user;
    } catch (e) {
      return e;
    }
  }

  Future passReset({String email}) async {
    try {
      var url = Uri.encodeFull('$heroku_url/auth/forgot-password');
      var response = await client.post(url, headers: _header.setHeaders(), body: jsonEncode({'email': email}));
      print(response.statusCode);
      return response.body;
    } catch (e) {
      return e;
    }
  }
}
