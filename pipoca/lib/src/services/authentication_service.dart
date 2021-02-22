import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'package:pipoca/src/repositories/user_repository.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'dart:convert';

@lazySingleton
class AuthenticationService {
  final _localStorage = locator<SharedLocalStorageService>();
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;

  //token setter to be use for all the api services
  String _currentToken;
  String get currentToken => _currentToken;

 //method for fetching token. Endpoint could be login or signup
  Future<bool> access({UserAuth user, String endpoint}) async {
    try {
      var url = Uri.encodeFull('$heroku_url/auth/$endpoint');
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
  //check if token is saved on localstorage and set currentToken
  Future<bool> isUserLoggedIn() async {
    var token = await _localStorage.recieve('token');
    _currentToken = token;
    return _currentToken != null;
  }

 

 
  //logout for the current user
  Future signout() async {
    await _localStorage.delete('token');
  }
}
