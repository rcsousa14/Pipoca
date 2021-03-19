import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'dart:convert';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';

@lazySingleton
class UserRepository {

  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final _authenticationService = locator<AuthenticationService>();
  final _localStorage = locator<SharedLocalStorageService>();

  //USER CRUD

  Future<Usuario> getUser() async {
    try {
      var url = Uri.encodeFull('$heroku_url/users');
      var response = await client.get(
        url,
        headers:
            _header.setTokenHeaders(token: _authenticationService.currentToken),
      );

      var parsed = json.decode(response.body);
      Usuario user = Usuario.fromJson(parsed);
   
      await _localStorage.put('id', user.user.id);

      return user;
    } catch (e) {
      return e;
    }
  }

  Future<Usuario> patchFcmToken(String fcmToken) async {
    try {
      var url = Uri.encodeFull('$heroku_url/users');
      var response = await client.patch(url,
          headers: _header.setTokenHeaders(
              token: _authenticationService.currentToken),
          body: {'fcm_token': fcmToken});
      var parsed = json.decode(response.body);
      Usuario user = Usuario.fromJson(parsed);
      return user;
    } catch (e) {
      return e;
    }
  }
}


// if (user == null) {
      //   int id = await _localStorage.recieve('id');
      //   var result = await _authenticationService.refreshToken(
      //       currentToken: _authenticationService.currentToken, id: id);
      //   if (result is bool) {
      //     if (result) {
      //       var response = await client.get(
      //         url,
      //         headers: _header.setTokenHeaders(
      //             token: _authenticationService.currentToken),
      //       );
      //       var parsed = json.decode(response.body);
      //       Usuario user = Usuario.fromJson(parsed);
      //       await _localStorage.put('id', user.user.id);
      //       return user;
      //     }
      //   }
      // }