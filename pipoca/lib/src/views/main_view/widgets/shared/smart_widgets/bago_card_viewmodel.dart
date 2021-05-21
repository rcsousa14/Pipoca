import 'dart:async';
import 'dart:convert';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';

import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/comment_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/sub_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum Type { POST, COMMENT, SUB }

class BagoCardViewModel extends BaseViewModel {
  //LOCATORS
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();
  final _commentService = locator<CommentService>();
  final _subService = locator<SubService>();
  final _location = locator<LocationService>();
  final _homeNavigator = locator<HomeNavigatorViewModel>();
  final _snackbarService = locator<SnackbarService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _captureService = locator<CapturePngService>();

  //VARIABLES
  bool? _up;
  bool? _down;
  int? _points;

  // GETTERS

  String get creator => _userService.user.username;
  bool get filter => _homeNavigator.filter;
  Future get refreshFeed => _homeNavigator.refreshFeed(isRefresh: true);
  int get page => _homeNavigator.currentPage;
  bool? get up => _up;
  bool? get down => _down;
  int? get points => _points;

//FUTURE TO DELETE POST
  Future delete(
      {required int id, required bool isSingle, required Type type, int? postId, int? commentId}) async {
    var response = await _bottomSheetService.showBottomSheet(
        cancelButtonTitle: 'Não',
        confirmButtonTitle: 'Sim',
        title: type == Type.POST ? 'Eliminar Bago' : 'Eliminar Comentário',
        description: type == Type.POST
            ? 'Tem certeza de que deseja excluir este bago?'
            : 'Tem certeza de que deseja excluir este comentário?');
    if (response?.confirmed == true) {
      ApiResponse<Generic> result;
      switch (type) {
        case Type.POST:
          result = await _feedService.deletPost(id: id);

          return await deletingStatus(
              type: type,
              status: result.status,
              id: id,
              isSingle: isSingle,
              msg: result.data!.message
              );
        case Type.COMMENT:
          result = await _commentService.deletPost(id: id);
          return await deletingStatus(
              type: type,
              status: result.status,
              id: id,
              isSingle: isSingle,
              msg: result.data!.message,
              postId: postId);

        case Type.SUB:
          result = await _subService.deletPost(id: id);
          return await deletingStatus(
              type: type,
              status: result.status,
              id: id,
              isSingle: isSingle,
              msg: result.data!.message, 
              commentId: commentId);
      }
    }
  }

  Future deletingStatus(
      {required Status status,
      required int id,
      required bool isSingle,
      required Type type,
      String? msg, int? postId, int? commentId}) async {
    if (status == Status.ERROR) {
      _snackbarService.showSnackbar(message: msg!);
      switch (type) {
        case Type.POST:

         return await refreshFeed;
        case Type.COMMENT:
        case Type.SUB:
          // TODO: Future wait of both comment and sub list since they will always be together.
          break;
      }
    }
    if (status == Status.COMPLETED) {
      _feedService.delete(id, isSingle);
        switch (type) {
        case Type.POST:

         return await refreshFeed;
        case Type.COMMENT:
        case Type.SUB:
          // TODO: Future wait of both comment and sub list since they will always be together.
          break;
      }
    }
  }

//FUTURE TO MAKE A VOTE
  Future vote(
      {required String direction,
      required int id,
      required Type type,
      int? commentId,
      int? postId,
      int? points}) async {
    int vote = 0;
    if (direction == "up") {
      _up = true;
      _down = false;

      if (points != null) {
        _points = ++points;
      } else {
        _points = 1;
      }
      vote = _points!;
      notifyListeners();
    }
    if (direction == "down") {
      _up = false;
      _down = true;
      _points = 1;
      if (points != null) {
        _points = --points;
      } else {
        _points = -1;
      }
      vote = _points!;
      notifyListeners();
    }

    var result;

    switch (type) {
      case Type.POST:
        result = await _feedService.pointPost(
            point: PostPoint(
              id: id,
              voted: vote,
            ),
            filter: filter == false ? 'date' : 'pipocar');
        return await voteStatus(status: result.status, type: type, postId: id);
      case Type.COMMENT:
        result = await _commentService.pointComment(
            point: PostPoint(id: id, voted: vote),
            filter: "date"); // NEED TO CHANGE THIS
        return await voteStatus(
            status: result.status, type: type, postId: postId, commentId: id);

      case Type.SUB:
        result = await _subService.pointComment(
            point: PostPoint(id: id, voted: vote));
        return await voteStatus(
            status: result.status, type: type, commentId: commentId, subId: id);
    }
  }

  Future voteStatus(
      {required Status status,
      required Type type,
      int? commentId,
      int? subId,
      int? postId}) async {
    if (status == Status.ERROR) {
      await refreshFeed;
      _snackbarService.showSnackbar(message: 'Tenta Novamente');
    }
    if (status == Status.COMPLETED) {
      switch (type) {
        case Type.POST:
          await fetchSingle(id: postId!, type: type);
          setNull();
          return await refreshFeed;

        case Type.COMMENT:
          await fetchSingle(id: commentId!, type: type);
          setNull();
          return await _commentService.fetchComments(
              info: CommentInfo(
                  coordinates: _location.currentLocation,
                  filter: "date", // NEED TO CHANGE THIS
                  page: page,
                  id: postId!),
              isRefresh: true);
        case Type.SUB:
          await fetchSingle(id: subId!, type: type);
          setNull();

          return await _subService.fetchSubs(
              info: CommentInfo(
                  coordinates: _location.currentLocation,
                  page: page,
                  id: commentId!),
              isRefresh: true);
      }
    }
  }

  void setNull() {
    _up = null;
    _down = null;
    _points = null;
    notifyListeners();
  }

  //FUTURE TO SHARE POST
  Future share(key) async {
    return await _captureService.capturePng(key);
  }

  //FUTURE TO CALL SINGULAR POST
  Future<ApiResponse<SinglePost>> fetchSingle(
      {required int id, required Type type}) async {
    ApiResponse<SinglePost> result;
    switch (type) {
      case Type.POST:
        result = await _feedService.singlePost(
            info: PostInfo(coordinates: _location.currentLocation, id: id));
        return result;
      case Type.COMMENT:
        result = await _commentService.singlePost(
            info: PostInfo(coordinates: _location.currentLocation, id: id));
        return result;
      case Type.SUB:
        result = await _subService.singlePost(
            info: PostInfo(coordinates: _location.currentLocation, id: id));
        return result;
    }
  }
}
