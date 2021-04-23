import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/base_helper.dart';
import 'package:pipoca/src/constants/api_helpers/header.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';

@lazySingleton
class FeedRepository {
  final _header = locator<ApiHeaders>();
  final _helper = locator<ApiBaseHelper>();
  final _authenticationService = locator<AuthenticationService>();

  Future<Feed> getFeedData(
      {required double lat,
      required double lng,
      required int page,
      required String filter}) async {
    Map<String, String> queryParams = {
      'lat': lat.toString(),
      'lng': lng.toString(),
      'page': page.toString(),
      'filter': filter
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await _helper.get(
        query: 'user/feed?$queryString',
        header: _header.setTokenHeaders(_authenticationService.token));

 

    Feed feed = Feed.fromJson(response);
    return feed;
  }

  Future<Generic> postFeedData(CreatePost post) async {
    final response = await _helper.post(
        query: 'posts',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: post);
    Generic created = Generic.fromJson(response);
    return created;
  }

  Future<Generic> postPointData(PostPoint point) async {
    final response = await _helper.post(
        query: 'post/votes',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: point);
    Generic vote = Generic.fromJson(response);

    return vote;
  }

  Future<Generic> deletePostData({required int id}) async {
    final response = await _helper.patch(
        query: 'posts/$id',
        header: _header.setTokenHeaders(_authenticationService.token));
    Generic generic = Generic.fromJson(response);
    return generic;
  }

  Future<Data> getPostData({required int id}) async {
    final response = await _helper.get(
        query: 'posts/$id',
        header: _header.setTokenHeaders(_authenticationService.token));
    Data data = Data.fromJson(response);
    return data;
  }
}
