import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/services/authentication_service.dart';

@lazySingleton
class PostPointRepository {
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final _authenticationService = locator<AuthenticationService>();

  Future postPoint(String id, String vote) async {
    try {
      var url = Uri.encodeFull('$heroku_url/post/votes');
      var response = await client.post(url,
          headers: _header.setTokenHeadersType(
              token: _authenticationService.currentToken),
          body: {"postId": id, "voted": vote});

      return response.statusCode;
    } catch (e) {
      throw e;
    }
  }
}
