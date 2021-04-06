import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'dart:convert';
import 'package:pipoca/src/services/authentication_service.dart';

@lazySingleton
class FeedRepository {
  final _header = locator<ApiHeaders>();
  final client = locator<ApiHeaders>().client;
  final _authenticationService = locator<AuthenticationService>();

  Future<Feed> getFeed(double lat, double lng, int page, String filter) async {
    try {
      Map<String, String> queryParams = {
        'lat': lat.toString(),
        'lng': lng.toString(),
        'page': page.toString(),
        'filter': filter
      };
      String queryString = Uri(queryParameters: queryParams).query;
      var url = Uri.encodeFull('$heroku_url/user/feed?$queryString');

      var response = await client.get(
        url,
        headers:
            _header.setTokenHeaders(token: _authenticationService.currentToken),
      );

      var parsed = json.decode(response.body);

      Feed feed = Feed.fromJson(parsed);
    
      return feed;
    } catch (e) {
      throw e;
    }
  }
}
