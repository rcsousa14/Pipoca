import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/base_helper.dart';
import 'package:pipoca/src/constants/api_helpers/header.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/post_comments_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';

@lazySingleton
class CommentRepository {
  final _header = locator<ApiHeaders>();
  final _helper = locator<ApiBaseHelper>();
  final _authenticationService = locator<AuthenticationService>();
  
  // FUTURE TO POST A COMMENT WITH A POST ID
  Future<Generic> postCommentData(
      {required CreatePost post, required int postId}) async {
    final response = await _helper.post(
        query: '$postId/comments',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: post);
    Generic created = Generic.fromJson(response);
    return created;
  }

  //FUTURE TO GET ALL THE COMMENTS ASSOCIATED WITH A POST
  Future<Comentario> getCommentData(
      {required Coordinates coords,
      required int postId,
      required int page,
      required String filter}) async {
    Map<String, String> queryParams = {
      'lat': coords.latitude.toString(),
      'lng': coords.longitude.toString(),
      'page': page.toString(),
      'filter': filter
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await _helper.get(
      query: '$postId/comments?$queryString',
      header: _header.setTokenHeaders(_authenticationService.token),
    );
    Comentario created = Comentario.fromJson(response);
    return created;
  }

  //FUTURE TO ADD A VOTE FOR THE COMMENT
  Future<Generic> commentPointData(PostPoint point) async {
    final response = await _helper.post(
        query: 'comment/votes',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: point);

    Generic vote = Generic.fromJson(response);

    return vote;
  }

//FUTURE TO DELETE COMMENT
  Future<Generic> deleteCommentData({required int id}) async {
    final response = await _helper.delete(
        query: 'comments/$id',
        header: _header.setTokenHeaders(_authenticationService.token));
    Generic generic = Generic.fromJson(response);
    return generic;
  }
}
