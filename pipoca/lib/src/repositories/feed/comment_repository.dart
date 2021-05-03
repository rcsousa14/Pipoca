import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/base_helper.dart';
import 'package:pipoca/src/constants/api_helpers/header.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';

@lazySingleton
class CommentRepository {
  final _header = locator<ApiHeaders>();
  final _helper = locator<ApiBaseHelper>();
  final _authenticationService = locator<AuthenticationService>();

  Future<SinglePost> getPostData(
      {required double lat, required double lng, required int postId}) async {
    Map<String, String> queryParams = {
      'lat': lat.toString(),
      'lng': lng.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await _helper.get(
        query: 'posts/$postId?$queryString',
        header: _header.setTokenHeaders(_authenticationService.token));

    SinglePost post = SinglePost.fromJson(response);
    return post;
  }

  Future<Generic> postCommentData({ required CreatePost post, required int postId}) async {
    final response = await _helper.post(
        query: '$postId/comments',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: post);
    Generic created = Generic.fromJson(response);
    return created;
  }
 //TODO: need to do this part at home
  Future<Generic> getCommentData({ required int postId}) async {
    final response = await _helper.get(
        query: '$postId/comments',
        header: _header.setTokenHeaders(_authenticationService.token),
        );
    Generic created = Generic.fromJson(response);
    return created;
  }
}
