import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/base_helper.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/constants/api_helpers/header.dart';

@lazySingleton
class UserRepository {
  final _header = locator<ApiHeaders>();
  final _helper = locator<ApiBaseHelper>();

  //USER CRUD

  Future<Usuario> fetchUserData({required String token}) async {
    final response = await _helper.get(
        query: 'users', header: _header.setTokenHeaders(token));
    Usuario user = Usuario.fromJson(response);

    return user;
  }

  Future<Generic> deleteUserData({required String token}) async {
    final response = await _helper.get(
        query: 'users', header: _header.setTokenHeaders(token));
    Generic generic = Generic.fromJson(response);
    return generic;
  }

  Future<Generic> updateUserData(
      {required UserAuth user, required String token}) async {
    final response = await _helper.patch(
        query: 'users', header: _header.setTokenHeaders(token), body: user);
    Generic users = Generic.fromJson(response);
    return users;
  }

  Future<Generic> logout(String token) async {
    final response = await _helper.patch(
        query: 'auth/logout', header: _header.setTokenHeaders(token));
    Generic logout = Generic.fromJson(response);
    return logout;
  }

  Future<AuthenticationResponse> refreshToken(
      int id, String currentToken) async {
   
    final response = await _helper.post(
      query: 'auth/refresh-token?id=$id&token=$currentToken',
      header: _header.setHeaders(),
    );
    AuthenticationResponse token = AuthenticationResponse.fromJson(response);

    return token;
  }
}
