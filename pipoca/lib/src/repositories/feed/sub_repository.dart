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
class SubRepository {
  final _header = locator<ApiHeaders>();
  final _helper = locator<ApiBaseHelper>();
  final _authenticationService = locator<AuthenticationService>();

//FUTURE TO POST A SUB_COMMENT WITH A COMMENT ID
  Future<Generic> postSubData(
      {required CreateSubComment post, required int commentId}) async {
    final response = await _helper.post(
        query: '$commentId/sub_comments',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: post);
    Generic created = Generic.fromJson(response);
    return created;
  }

//FUTURE TO GET ALL THE SUB_COMMENTS ASSOCIATED WITH A COMMENT
  Future<SubComentario> getSubData(
      {required Coordinates coords,
      required int commentId,
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
      query: '$commentId/sub_comments?$queryString',
      header: _header.setTokenHeaders(_authenticationService.token),
    );

    SubComentario created = SubComentario.fromJson(response);
    return created;
  }

  //FUTURE TO ADD A VOTE FOR THE SUB_COMMENT
  Future<Generic> subPointData(PostPoint point) async {
    final response = await _helper.post(
        query: 'sub_comment/votes',
        header: _header.setTokenHeaders(_authenticationService.token),
        body: point);

    Generic vote = Generic.fromJson(response);

    return vote;
  }

//FUTURE TO DELETE SUB_COMMENT
  Future<Generic> deleteSubData({required int id}) async {
    final response = await _helper.delete(
        query: 'sub_comments/$id',
        header: _header.setTokenHeaders(_authenticationService.token));
    Generic generic = Generic.fromJson(response);
    return generic;
  }
}
